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
    let coordinate: CLLocationCoordinate2D
    
    // MARK: - Hashable & Equatable Conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(emoji)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.emoji == rhs.emoji &&
               lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude
    }
    
    static let sampleData: [Country] = [
        Country(name: "United States", emoji: "🇺🇸", coordinate: CLLocationCoordinate2D(latitude: 39.8283, longitude: -98.5795)),
        Country(name: "United Kingdom", emoji: "🇬🇧", coordinate: CLLocationCoordinate2D(latitude: 55.3781, longitude: -3.4360)),
        Country(name: "France", emoji: "🇫🇷", coordinate: CLLocationCoordinate2D(latitude: 46.2276, longitude: 2.2137)),
        Country(name: "Japan", emoji: "🇯🇵", coordinate: CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)),
        Country(name: "Australia", emoji: "🇦🇺", coordinate: CLLocationCoordinate2D(latitude: -25.2744, longitude: 133.7751)),
        Country(name: "Germany", emoji: "🇩🇪", coordinate: CLLocationCoordinate2D(latitude: 51.1657, longitude: 10.4515)),
        Country(name: "Italy", emoji: "🇮🇹", coordinate: CLLocationCoordinate2D(latitude: 41.8719, longitude: 12.5674)),
        Country(name: "United Arab Emirates", emoji: "🇦🇪", coordinate: CLLocationCoordinate2D(latitude: 23.4241, longitude: 53.8478)),
        Country(name: "Canada", emoji: "🇨🇦", coordinate: CLLocationCoordinate2D(latitude: 56.1304, longitude: -106.3468)),
        Country(name: "Spain", emoji: "🇪🇸", coordinate: CLLocationCoordinate2D(latitude: 40.4637, longitude: -3.7492)),
        Country(name: "Netherlands", emoji: "🇳🇱", coordinate: CLLocationCoordinate2D(latitude: 52.1326, longitude: 5.2913)),
        Country(name: "Singapore", emoji: "🇸🇬", coordinate: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198)),
        Country(name: "South Korea", emoji: "🇰🇷", coordinate: CLLocationCoordinate2D(latitude: 35.9078, longitude: 127.7669)),
        Country(name: "Russia", emoji: "🇷🇺", coordinate: CLLocationCoordinate2D(latitude: 61.5240, longitude: 105.3188)),
        Country(name: "Egypt", emoji: "🇪🇬", coordinate: CLLocationCoordinate2D(latitude: 26.0975, longitude: 30.0444))
    ]
}