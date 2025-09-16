//
//  GlobeMapView.swift
//  WorldVPN
//
//  Created by Mustafa on 16.09.2025.
//

import SwiftUI
import MapKit

// MARK: - Presentable Models

/// Presentable data for the globe map component
struct GlobeMapPresentable {
    let cameraPosition: Binding<MapCameraPosition>
    let onTap: (CGPoint) -> Void
    let onAppear: () -> Void
}

// MARK: - GlobeMapView (Simple View Component)

/// Simple View component for displaying the 3D globe map
/// Contains no state, only receives props and presentable data
struct GlobeMapView: View {
    
    // MARK: - Properties
    
    let presentable: GlobeMapPresentable
    
    // MARK: - Body
    
    var body: some View {
        Map(position: presentable.cameraPosition) {
            // We can add map annotations here if needed in the future
        }
        .mapStyle(.hybrid(elevation: .realistic)) // Hybrid style with 3D terrain
        .mapControls {
            // Hide all default MapKit controls for clean UI
            // Note: In iOS 17+, we disable individual controls
        }
        .ignoresSafeArea(.all) // Expand to fill entire screen
        .onTapGesture { location in
            presentable.onTap(location)
        }
        .onAppear {
            presentable.onAppear()
        }
    }
}
