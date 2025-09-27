//
//  VPNConnectionManager.swift
//  WorldVPN
//
//  Created by Mustafa Natur on 27.09.2025.
//

import Foundation
import NetworkExtension

@Observable
final class VPNConnectionManager {
    var state: VPNConnectionState = .disconnected

    private let configFactory: VPNProtocolConfigFactory = VPNProtocolConfigFactory()
    private let neVPNManager = NEVPNManager.shared()

    func connect(to server: Server, with protocolType: VPNProtocolType) async throws {
        state = .connecting
        let config = await configFactory.getConfig(for: protocolType, server: server)
        try neVPNManager.connection.startVPNTunnel()
        state = .connected
    }

    func disconnect() {
        state = .disconnecting
    }
}
