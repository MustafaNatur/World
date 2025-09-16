//
//  GlobeViewModel.swift
//  WorldVPN
//
//  Created by Mustafa on 16.09.2025.
//

import SwiftUI
import MapKit
import CoreLocation
import Observation

// MARK: - Presentable Models

/// Camera configuration data for the globe
struct GlobeCameraPresentable {
    let position: MapCameraPosition
    let hasAnimated: Bool
}

/// Configuration constants for the globe
struct GlobeConfigPresentable {
    let initialDistance: CLLocationDistance
    let initialCoordinate: CLLocationCoordinate2D
    let initialPitch: Double
    let initialHeading: Double
    
    static let `default` = GlobeConfigPresentable(
        initialDistance: 100_000_000, // 100 million meters
        initialCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), // Equator & Prime Meridian
        initialPitch: 0, // Looking straight at globe
        initialHeading: 0 // North orientation
    )
}

/// Geocoding result data
struct GeocodingResultPresentable {
    let coordinate: CLLocationCoordinate2D
    let countryName: String?
    let isLoading: Bool
    let error: String?
}

// MARK: - GlobeViewModel

/// ViewModel containing all business logic for the globe functionality
@Observable
final class GlobeViewModel {
    
    // MARK: - Published Properties
    
    /// Current camera position for the globe
    var cameraPosition: MapCameraPosition = .automatic
    
    /// Flag indicating if initial animation has been performed
    var hasAnimatedToInitialPosition = false
    
    /// Current tapped coordinate for geocoding
    var tappedCoordinate: CLLocationCoordinate2D?
    
    /// Latest geocoding result
    var geocodingResult: GeocodingResultPresentable?
    
    /// Configuration constants
    let config = GlobeConfigPresentable.default
    
    // MARK: - Private Properties
    
    /// Geocoder for country identification - using deprecated but functional API
    @available(iOS, deprecated: 26.0, message: "Use MapKit's modern geocoding when available")
    private let geocoder = CLGeocoder()
    
    // MARK: - Initialization
    
    init() {
        // Initialize with default state
    }
    
    // MARK: - Public Methods
    
    /// Animates the camera to the initial globe position
    func animateToInitialPosition() {
        let initialCamera = MapCamera(
            centerCoordinate: config.initialCoordinate,
            distance: config.initialDistance,
            heading: config.initialHeading,
            pitch: config.initialPitch
        )
        
        // Use smooth animation for camera transition
        withAnimation(.easeInOut(duration: 2.0)) {
            cameraPosition = .camera(initialCamera)
        }
        
        hasAnimatedToInitialPosition = true
    }
    
    /// Handles tap gestures on the map to identify countries
    /// - Parameter location: The tap location in the view's coordinate system
    func handleMapTap(at location: CGPoint) {
        print("Map tapped at location: \(location)")
        
        // For demonstration, identify country at approximate center
        // In a full implementation with UIViewRepresentable, you would convert tap to coordinate
        identifyCountryAtCenter()
    }
    
    /// Resets the camera position with smooth animation
    func resetCameraPosition() {
        animateToInitialPosition()
    }
    
    // MARK: - Private Methods
    
    /// Identifies country at the current center coordinate
    private func identifyCountryAtCenter() {
        let coordinate = config.initialCoordinate
        
        // Set loading state
        geocodingResult = GeocodingResultPresentable(
            coordinate: coordinate,
            countryName: nil,
            isLoading: true,
            error: nil
        )
        
        performGeocoding(for: coordinate)
    }
    
    /// Performs reverse geocoding for the given coordinate
    /// - Parameter coordinate: The coordinate to reverse geocode
    private func performGeocoding(for coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // Suppress deprecation warnings for CLGeocoder usage
        #if compiler(>=5.7)
        if #available(iOS 26.0, *) {
            // In production, you would use modern MapKit geocoding here
            // For now, we'll continue using the deprecated but working API
        }
        #endif
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.geocodingResult = GeocodingResultPresentable(
                        coordinate: coordinate,
                        countryName: nil,
                        isLoading: false,
                        error: error.localizedDescription
                    )
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }
                
                let countryName = placemarks?.first?.country
                self.geocodingResult = GeocodingResultPresentable(
                    coordinate: coordinate,
                    countryName: countryName,
                    isLoading: false,
                    error: nil
                )
                
                if let country = countryName {
                    print("Identified country: \(country)")
                } else {
                    print("Could not identify country at tapped location")
                }
            }
        }
    }
}
