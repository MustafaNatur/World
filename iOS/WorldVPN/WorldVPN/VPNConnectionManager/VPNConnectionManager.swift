//
//  VPNConnectionManager.swift
//  WorldVPN
//
//  Created by Mustafa Natur on 27.09.2025.
//

import Foundation
import NetworkExtension
import Combine

final class VPNConnectionManager: ObservableObject {
    @Published var state: VPNConnectionState = .disconnected

    private let vpnManager = NEVPNManager.shared()

    init() {
        setupStatusMonitoring()
    }

    func connect(to server: Server, with protocolType: VPNProtocolType) throws {
        let connectionProtocolProvider = switch protocolType {
        case .IKEv2: IKEv2ConnectionProviderImpl()
        }

        try connectionProtocolProvider.connect(server: server)
    }

    func disconnect() {
        vpnManager.connection.stopVPNTunnel()
    }

    private func setupStatusMonitoring() {
        NotificationCenter.default.addObserver(
            forName: .NEVPNStatusDidChange,
            object: vpnManager.connection,
            queue: .main
        ) { [weak self] _ in
            self?.handleVPNStatusChange()
        }
    }

    private func handleVPNStatusChange() {
        let status = vpnManager.connection.status

        state = switch status {
        case .connected: .connected
        case .connecting: .connecting
        case .invalid: .disconnected
        case .disconnected: .disconnected
        case .reasserting: .connecting
        case .disconnecting: .disconnecting
        @unknown default: fatalError()
        }
    }
}

class IKEv2ConnectionProviderImpl: ConnectionProtocolProvider {
    private let vpnManager: NEVPNManager
    private let configFactory: VPNProtocolConfigFactory = VPNProtocolConfigFactory()
    private var connectionTask: Task<Void, Error>? = nil {
        willSet {
            connectionTask?.cancel()
        }
    }

    init(vpnManager: NEVPNManager = .shared()) {
        self.vpnManager = vpnManager
    }

    func connect(server: Server) throws {
        vpnManager.loadFromPreferences { loadError in
            guard loadError == nil else { return }

            let config = self.configFactory.getIKEv2Config(server: server)
            self.vpnManager.localizedDescription = "Secure IKEv2 VPN"
            self.vpnManager.protocolConfiguration = config
            self.vpnManager.isEnabled = true

            self.vpnManager.saveToPreferences { saveError in
                guard saveError == nil else {
                    print(saveError)
                    return
                }

                self.connectionTask = Task { @MainActor in
                    try await Task.sleep(for: .seconds(1))
                    try self.vpnManager.connection.startVPNTunnel()
                }
            }
        }
    }
    
    func disconnect() throws {}
}

protocol ConnectionProtocolProvider {
    func connect(server: Server) throws
    func disconnect() throws
}
