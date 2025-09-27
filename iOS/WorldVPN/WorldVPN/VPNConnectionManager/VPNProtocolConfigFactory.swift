//
//  VPNProtocolConfigFactory.swift
//  WorldVPN
//
//  Created by Mustafa Natur on 27.09.2025.
//

import Foundation
import NetworkExtension

final class VPNProtocolConfigFactory {
    func getConfig(for protocolType: VPNProtocolType, server: Server) async -> VPNProtocolConfig {
        switch protocolType {
        case .IKEv2: getIKEv2Config()
        }
    }

    private func getIKEv2Config() -> VPNProtocolConfig {
        let ikev2Protocol = NEVPNProtocolIKEv2()
        // Protocol setup
        return .IKEv2(ikev2Protocol)
    }
}
