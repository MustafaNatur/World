//
//  VPNService.swift
//  WorldVPN
//
//  Created by Mustafa on 26.09.2025.
//

import Foundation

protocol VPNService {
    func fetchServers() async throws -> [Server]
}
