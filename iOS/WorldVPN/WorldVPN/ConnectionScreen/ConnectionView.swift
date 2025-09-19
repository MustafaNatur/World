//
//  ConnectionView.swift
//  WorldVPN
//
//  Created by Mustafa on 19.09.2025.
//

import SwiftUI

struct ConnectionView: View {
    let connectionState: ConnectionButtonView.ConnectionState
    let chosenCountry: Country?
    let onConnectionTap: () -> Void
    let onCountryTap: () -> Void
    
    var body: some View {
        ZStack {
            // Glass background
            LinearGradient(
                colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                // Connection Button
                ConnectionButtonView(
                    state: connectionState,
                    onTap: onConnectionTap
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.top, 10)

                // Chosen Country Section
                VStack(spacing: 16) {
                    Button(action: onCountryTap) {
                        HStack(spacing: 16) {
                            // Country flag/emoji
                            Text(chosenCountry?.emoji ?? "🌍")
                                .font(.system(size: 32))
                                .frame(width: 50, height: 50)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(chosenCountry?.name ?? "Choose Country")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                
                                if chosenCountry != nil {
                                    Text("Tap to change")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text("Select your preferred location")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 12)
            }
        }
    }
}

#Preview {
    ConnectionView(
        connectionState: .notConnected,
        chosenCountry: Country.sampleData.first,
        onConnectionTap: {},
        onCountryTap: {}
    )
}
