//
//  GlobeContainerView.swift
//  WorldVPN
//
//  Created by Mustafa on 16.09.2025.
//

import SwiftUI
import MapKit

// MARK: - GlobeContainerView (Container View Component)

/// Container View component that manages state and coordinates between Simple View components
/// Contains @State viewModel and passes observed properties to Simple Views
struct GlobeContainerView: View {
    
    // MARK: - State Properties
    
    /// View model containing all business logic and state
    @State private var viewModel = GlobeViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Main 3D Globe Map Component
            GlobeMapView(
                presentable: GlobeMapPresentable(
                    cameraPosition: $viewModel.cameraPosition,
                    onTap: { location in
                        viewModel.handleMapTap(at: location)
                    },
                    onAppear: {
                        // Animate to initial position when view appears
                        if !viewModel.hasAnimatedToInitialPosition {
                            viewModel.animateToInitialPosition()
                        }
                    }
                )
            )
            
            // Floating Reset Button Component
            GlobeResetButtonView(
                presentable: GlobeResetButtonPresentable(
                    onTap: {
                        viewModel.resetCameraPosition()
                    }
                )
            )
        }
    }
}

// MARK: - Preview

#Preview {
    GlobeContainerView()
}
