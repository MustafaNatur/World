//
//  GlobeResetButtonView.swift
//  WorldVPN
//
//  Created by Mustafa on 16.09.2025.
//

import SwiftUI

struct SearchButtonView: View {
    let onTap: () -> Void
    
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

    private var resetButton: some View {
        Button(action: onTap) {
            Image(systemName: "magnifyingglass")
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
        .buttonStyle(.plain)
    }
}
