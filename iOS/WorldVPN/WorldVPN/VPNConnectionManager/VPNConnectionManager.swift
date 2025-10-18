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
        let connectionProtocolProvider: ConnectionProtocolProvider = switch protocolType {
        case .IKEv2: IKEv2ConnectionProviderImpl()
        case .OpenVPN: OpenVPNConnectionProviderImpl()
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
