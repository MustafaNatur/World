//
//  VPNServer.swift
//  WorldVPN
//
//  Created by Mustafa on 25.09.2025.
//

import SwiftUI
import CoreLocation

struct Server: Identifiable, Hashable {
    struct Location: Hashable, Codable {
        let city: String
        let countryCode: String
    }

    let id = UUID()
    let location: Location
    let ip: String
    let name: String
}

extension Server: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case ip
        case countryCode = "country_code"
        case city
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let city = try container.decode(String.self, forKey: .city)
        let countryCode = try container.decode(String.self, forKey: .countryCode)

        self.location = Location(city: city, countryCode: countryCode)
        self.ip = try container.decode(String.self, forKey: .ip)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

extension Server {
    func getCoordinate() async -> CLLocation? {
        let address = "\(location.city), \(location.countryCode)"

        do {
            let placemarks = try await CLGeocoder().geocodeAddressString(address)
            return placemarks.first?.location
        } catch {
            print("Geocoding error: \(error)")
            return nil
        }
    }
}

extension Server.Location {
    var countryName: String {
        Locale.current.localizedString(forRegionCode: countryCode) ?? countryCode
    }

    var flagEmoji: String? {
        let base: UInt32 = 127397
        var emoji = ""

        for scalar in countryCode.uppercased().unicodeScalars {
            if let unicodeScalar = UnicodeScalar(base + scalar.value) {
                emoji.append(String(unicodeScalar))
            }
        }

        return emoji.isEmpty ? nil : emoji
    }
}

// MARK: - Mock Data
extension Server {
    static var mock: Server {
        Server(
            location: Location(city: "Moscow", countryCode: "RU"),
            ip: "185.123.45.67",
            name: "Russia Moscow #1"
        )
    }
}

extension [Server] {
    static let mock: [Server] = [
        Server(location: Server.Location(city: "New York", countryCode: "US"), ip: "192.168.1.1", name: "US New York #1"),
        Server(location: Server.Location(city: "London", countryCode: "GB"), ip: "192.168.1.2", name: "UK London #1"),
        Server(location: Server.Location(city: "Paris", countryCode: "FR"), ip: "192.168.1.3", name: "France Paris #1"),
        Server(location: Server.Location(city: "Tokyo", countryCode: "JP"), ip: "192.168.1.4", name: "Japan Tokyo #1"),
        Server(location: Server.Location(city: "Sydney", countryCode: "AU"), ip: "192.168.1.5", name: "Australia Sydney #1"),
        Server(location: Server.Location(city: "Berlin", countryCode: "DE"), ip: "192.168.1.6", name: "Germany Berlin #1"),
        Server(location: Server.Location(city: "Rome", countryCode: "IT"), ip: "192.168.1.7", name: "Italy Rome #1"),
        Server(location: Server.Location(city: "Dubai", countryCode: "AE"), ip: "192.168.1.8", name: "UAE Dubai #1"),
        Server(location: Server.Location(city: "Toronto", countryCode: "CA"), ip: "192.168.1.9", name: "Canada Toronto #1"),
        Server(location: Server.Location(city: "Madrid", countryCode: "ES"), ip: "192.168.1.10", name: "Spain Madrid #1"),
        Server(location: Server.Location(city: "Amsterdam", countryCode: "NL"), ip: "192.168.1.11", name: "Netherlands Amsterdam #1"),
        Server(location: Server.Location(city: "Singapore", countryCode: "SG"), ip: "192.168.1.12", name: "Singapore #1"),
        Server(location: Server.Location(city: "Seoul", countryCode: "KR"), ip: "192.168.1.13", name: "South Korea Seoul #1"),
        Server(location: Server.Location(city: "Moscow", countryCode: "RU"), ip: "192.168.1.14", name: "Russia Moscow #1"),
        Server(location: Server.Location(city: "Cairo", countryCode: "EG"), ip: "192.168.1.15", name: "Egypt Cairo #1")
    ]
}
