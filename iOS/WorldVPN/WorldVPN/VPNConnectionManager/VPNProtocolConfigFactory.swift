//
//  VPNProtocolConfigFactory.swift
//  WorldVPN
//
//  Created by Mustafa Natur on 27.09.2025.
//

import Foundation
import NetworkExtension

final class VPNProtocolConfigFactory {
    let userName: String = "adminMusta"
    let userPassword: String = "adminMusta"
    let sharedSecret: String = "321inter"

    func getIKEv2Config(server: Server) -> NEVPNProtocol {
        getIKEv2Config(
            serverAddress: server.ip,
            remoteIdentifier: server.name
        )
    }

    private func getIKEv2Config(
        serverAddress: String,
        remoteIdentifier: String
    ) -> NEVPNProtocol {
        let configuration = NEVPNProtocolIKEv2()

        // The VPN server's hostname or IP address
        // - Primary endpoint for connection
        // - Can be FQDN, IPv4, or IPv6 address
        // - DNS resolution happens during connection
        configuration.serverAddress = serverAddress

        // Server's identity for IKE authentication
        // - Usually matches serverAddress or server's certificate CN
        // - Used in IKE_IDr (Responder Identity) payload
        // - Prevents man-in-the-middle attacks
        configuration.remoteIdentifier = remoteIdentifier

        // Purpose: Client's identity for IKE authentication (Local ID is the vpn username)
        // - Used in IKE_IDi (Initiator Identity) payload
        // - Can be email, FQDN, or custom string
        // - Often matches username or certificate subject
        configuration.localIdentifier = userName

        // .none - Only username/password (rare)
        // .certificate - X.509 certificate-based
        // .sharedSecret - Pre-shared key (PSK)
        configuration.authenticationMethod = .sharedSecret

        // Purpose: Pre-shared key for IKE authentication
        // - Required when authenticationMethod = .sharedSecret
        // - Should be strong, random string
        // - Both client and server must know this key
        configuration.sharedSecretReference = sharedSecret.data(using: .utf8)!

        // Purpose: Extended authentication (XAuth) credentials
        // - Used after IKE phase 1 completes
        // - passwordReference should be stored securely in Keychain
        configuration.username = userName
        configuration.passwordReference = userPassword.data(using: .utf8)

        // Purpose: For client certificate authentication
        // - Required when authenticationMethod = .certificate
        // - Reference to certificate in Keychain
        configuration.identityReference = nil

        configuration.ikeSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES256
        configuration.ikeSecurityAssociationParameters.integrityAlgorithm = .SHA256
        configuration.ikeSecurityAssociationParameters.diffieHellmanGroup = .group14
        configuration.ikeSecurityAssociationParameters.lifetimeMinutes = 1440

        configuration.childSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES256
        configuration.childSecurityAssociationParameters.integrityAlgorithm = .SHA256
        configuration.childSecurityAssociationParameters.diffieHellmanGroup = .group14

        // Purpose: How often to check if server is still responsive
        // - .off - No DPD (not recommended)
        // - .low - Every 30+ minutes
        // - .medium - Every 10-30 minutes (Recommended)
        // - .high - Every 1-10 minutes
        configuration.deadPeerDetectionRate = .medium

        // Purpose: Enable/disable IKEv2 mobility extension
        // - false = MOBIKE enabled (Recommended)
        // - Allows seamless network changes (Wi-Fi → Cellular)
        // - Automatic reconnection when IP changes
        configuration.disableMOBIKE = false

        // Purpose: Allow server to redirect to different endpoint
        // - false = Redirects allowed
        // - Useful for load balancing or failover
        configuration.disableRedirect = false

        // Purpose: Use new DH exchange for each rekey
        // - true = More secure (Recommended)
        // - Prevents compromise of long-term keys from affecting past sessions
        configuration.enablePFS = true

        // Purpose: Enable XAuth (Extended Authentication)
        // - true = Send username/password after IKE phase 1
        // - Required for most enterprise VPN
        // configuration.useExtendedAuthentication = true

        // Purpose: Whether to disconnect when device sleeps
        // - false = Maintain connection during sleep (Recommended for always-on)
        // - true = Disconnect to save battery
        configuration.disconnectOnSleep = false


        return configuration
    }
}
