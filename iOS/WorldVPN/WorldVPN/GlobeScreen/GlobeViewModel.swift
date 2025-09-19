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
import UIKit

@Observable
final class GlobeViewModel {
    struct Config {
        let initialDistance: CLLocationDistance
        let initialCoordinate: CLLocationCoordinate2D
        let initialPitch: Double
        let initialHeading: Double

        static let `default` = Config(
            initialDistance: 100_000_000, // 100 million meters
            initialCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), // Equator & Prime Meridian
            initialPitch: 0, // Looking straight at globe
            initialHeading: 0 // North orientation
        )
    }

    var connectionState: ConnectionButtonView.ConnectionState = .notConnected
    var cameraPosition: MapCameraPosition = .automatic
    var hasAnimatedToInitialPosition = false
    var tappedCoordinate: CLLocationCoordinate2D?
    var chosenCountry: Country?
    let config: Config
    let vpnProvider: VPNConnectionProvider

    init(config: Config = .default, vpnProvider: VPNConnectionProvider = VPNConnectionProviderImpl()) {
        self.config = config
        self.vpnProvider = vpnProvider
    }

    func animateToInitialPosition() {
        let initialCamera = MapCamera(
            centerCoordinate: config.initialCoordinate,
            distance: config.initialDistance,
            heading: config.initialHeading,
            pitch: config.initialPitch
        )

        withAnimation(.easeInOut(duration: 2.0)) {
            cameraPosition = .camera(initialCamera)
        }
        
        hasAnimatedToInitialPosition = true
    }

    func handleMapTap(at location: CGPoint) {
        print("Map tapped at location: \(location)")
        identifyCountryAtCenter()
    }

    func resetCameraPosition() {
        animateToInitialPosition()
    }
    
    func animateToCountry(_ country: Country) {
        let countryCamera = MapCamera(
            centerCoordinate: country.coordinate,
            distance: config.initialDistance,
            heading: config.initialHeading,
            pitch: config.initialPitch
        )
        
        withAnimation(.easeInOut(duration: 1.5)) {
            cameraPosition = .camera(countryCamera)
        }
    }
    
    func handleConnectionTap() {
        switch connectionState {
        case .notConnected:
            // Light haptic for starting connection
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            connectionState = .loading
            // Simulate connection process
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.connectionState = .connected
                if let chosenCountry = self.chosenCountry {
                    self.animateToCountry(chosenCountry)
                }
                
                // Success haptic for successful connection
                let successFeedback = UINotificationFeedbackGenerator()
                successFeedback.notificationOccurred(.success)
            }
        case .loading:
            // Medium haptic for canceling connection
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            connectionState = .notConnected
        case .connected:
            // Heavy haptic for disconnecting
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
            
            connectionState = .notConnected
        }
    }

    private func identifyCountryAtCenter() {
        let coordinate = config.initialCoordinate
        performGeocoding(for: coordinate)
    }

    private func performGeocoding(for coordinate: CLLocationCoordinate2D) {}
}
