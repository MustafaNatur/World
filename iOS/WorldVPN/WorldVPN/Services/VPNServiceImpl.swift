//
//  VPNService.swift
//  WorldVPN
//
//  Created by Mustafa on 25.09.2025.
//

import Foundation
import CoreLocation

final class VPNServiceImpl: VPNService {
    
    // MARK: - Properties
    private let session: URLSession
    private let baseURL: String
    private let apiKey: String
    
    // MARK: - Initialization
    init(
        apiKey: String = Secrets.vpnResellersApiKey,
        baseURL: String = "https://api.vpnresellers.com/v3_2",
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.session = session
    }
    
    // MARK: - Public Methods
    func fetchServers() async throws -> [Server] {
        let endpoint = "\(baseURL)/servers"

        guard let url = URL(string: endpoint) else {
            throw VPNServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let (data, httpResponse) = try await session.data(for: request)

        if let httpResponse = httpResponse as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 401:
                throw VPNServiceError.unauthorized
            case 429:
                throw VPNServiceError.rateLimited
            default:
                throw VPNServiceError.serverError(httpResponse.statusCode)
            }
        }

        guard !data.isEmpty else {
            throw VPNServiceError.noData
        }

        let decoder = JSONDecoder()
        let servers = try decoder.decode(APIResponse<[Server]>.self, from: data).data

        return servers.unique(by: \.location.countryCode).sorted { $0.name < $1.name }
    }
}
