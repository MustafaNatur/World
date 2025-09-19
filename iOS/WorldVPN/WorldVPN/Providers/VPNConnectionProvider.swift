//
//  VPNConnectionProvider.swift
//  WorldVPN
//
//  Created by Mustafa on 19.09.2025.
//

import Foundation

protocol VPNConnectionProvider {
    func fetchCountries() async throws -> [Country]
    func connect() async throws
}

class VPNConnectionProviderImpl: VPNConnectionProvider {
    func fetchCountries() async throws -> [Country] {
        try await Task.sleep(for: .seconds(3))
        return Country.sampleData
    }

    func connect() async throws {
        try await Task.sleep(for: .seconds(3))
    }
}
