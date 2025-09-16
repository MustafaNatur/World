//
//  GlobeResetButtonView.swift
//  WorldVPN
//
//  Created by Mustafa on 16.09.2025.
//

import SwiftUI

// MARK: - Presentable Models

/// Presentable data for the reset button component
struct GlobeResetButtonPresentable {
    let onTap: () -> Void
}

// MARK: - GlobeResetButtonView (Simple View Component)

/// Simple View component for the floating reset button
/// Contains no state, only receives props and presentable data
struct GlobeResetButtonView: View {
    
    // MARK: - Properties
    
    let presentable: GlobeResetButtonPresentable
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                resetButton
                    .padding(.top, 20)
                    .padding(.trailing, 20)
            }
            Spacer()
        }
    }
    
    // MARK: - Private Views
    
    /// Semi-transparent floating reset button with globe icon
    private var resetButton: some View {
        Button(action: presentable.onTap) {
            Image(systemName: "globe")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain) // Prevent default button styling
    }
}
