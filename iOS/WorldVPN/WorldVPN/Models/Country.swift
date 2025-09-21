//
//  Country.swift
//  WorldVPN
//
//  Created by Mustafa on 19.09.2025.
//


import SwiftUI
import CoreLocation

struct Country: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let location: CLLocation
}

extension Country {
    static var mock: Country {
        Country(name: "Russia", emoji: "🇷🇺", location: CLLocation(latitude: 61.5240, longitude: 105.3188))
    }
}

extension [Country] {
    static let mock: [Country] = [
        Country(name: "United States", emoji: "🇺🇸", location: CLLocation(latitude: 39.8283, longitude: -98.5795)),
        Country(name: "United Kingdom", emoji: "🇬🇧", location: CLLocation(latitude: 55.3781, longitude: -3.4360)),
        Country(name: "France", emoji: "🇫🇷", location: CLLocation(latitude: 46.2276, longitude: 2.2137)),
        Country(name: "Japan", emoji: "🇯🇵", location: CLLocation(latitude: 36.2048, longitude: 138.2529)),
        Country(name: "Australia", emoji: "🇦🇺", location: CLLocation(latitude: -25.2744, longitude: 133.7751)),
        Country(name: "Germany", emoji: "🇩🇪", location: CLLocation(latitude: 51.1657, longitude: 10.4515)),
        Country(name: "Italy", emoji: "🇮🇹", location: CLLocation(latitude: 41.8719, longitude: 12.5674)),
        Country(name: "United Arab Emirates", emoji: "🇦🇪", location: CLLocation(latitude: 23.4241, longitude: 53.8478)),
        Country(name: "Canada", emoji: "🇨🇦", location: CLLocation(latitude: 56.1304, longitude: -106.3468)),
        Country(name: "Spain", emoji: "🇪🇸", location: CLLocation(latitude: 40.4637, longitude: -3.7492)),
        Country(name: "Netherlands", emoji: "🇳🇱", location: CLLocation(latitude: 52.1326, longitude: 5.2913)),
        Country(name: "Singapore", emoji: "🇸🇬", location: CLLocation(latitude: 1.3521, longitude: 103.8198)),
        Country(name: "South Korea", emoji: "🇰🇷", location: CLLocation(latitude: 35.9078, longitude: 127.7669)),
        Country(name: "Russia", emoji: "🇷🇺", location: CLLocation(latitude: 61.5240, longitude: 105.3188)),
        Country(name: "Egypt", emoji: "🇪🇬", location: CLLocation(latitude: 26.0975, longitude: 30.0444))
    ]
}
