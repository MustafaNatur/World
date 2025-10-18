//
//  IKEv2ConnectionProviderImpl.swift
//  WorldVPN
//
//  Created by Mustafa on 10.10.2025.
//

import Foundation
import NetworkExtension

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
