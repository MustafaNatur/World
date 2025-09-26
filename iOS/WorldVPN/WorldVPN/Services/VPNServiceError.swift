//
//  VPNServiceError.swift
//  WorldVPN
//
//  Created by Mustafa on 26.09.2025.
//

import Foundation

enum VPNServiceError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError(Int)
    case unauthorized
    case rateLimited
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .noData:
            return "No data received from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .unauthorized:
            return "Unauthorized access. Please check your API credentials."
        case .rateLimited:
            return "Rate limit exceeded. Please try again later."
        }
    }
}
