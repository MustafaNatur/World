//
//  GlobeContainerView.swift
//  WorldVPN
//
//  Created by Mustafa on 16.09.2025.
//

import SwiftUI
import MapKit

struct GlobeContainerView: View {
    @State private var viewModel = GlobeViewModel()
    @State private var showSheet: Bool = false
    @State private var selectedDetent: PresentationDetent = .fraction(0.50)

    var body: some View {
        GlobeMapView(
            presentable: GlobeMapView.Presentable(
                cameraPosition: $viewModel.cameraPosition,
                onTap: { location in
                    viewModel.handleMapTap(at: location)
                }
            )
        )
        .overlay(alignment: .bottomTrailing) {
            SearchButtonView {
                showSheet = true
            }
            .opacity(showSheet ? 0 : 1)
            .animation(.default, value: showSheet)
        }
        .onAppear {
            if viewModel.hasAnimatedToInitialPosition == false {
                viewModel.animateToInitialPosition()
            }
            showSheet = true
        }
        .onChange(of: viewModel.chosenCountry) { _, newCountry in
            if let country = newCountry {
                viewModel.animateToCountry(country)
            }
        }
        .sheet(isPresented: $showSheet) {
            ZStack(alignment: .center) {
                MiniInfoView(
                    chosenCountry: viewModel.chosenCountry,
                    connectionState: viewModel.connectionState
                )
                .opacity(selectedDetent == .height(100) ? 1 : 0)
                .onTapGesture {
                    selectedDetent = .fraction(0.50)
                }

                ConnectionContainerView(globeViewModel: viewModel)
                    .opacity(selectedDetent == .fraction(0.50) || selectedDetent == .large ? 1 : 0)
            }
            .presentationDetents([.height(100), .fraction(0.50)], selection: $selectedDetent)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
        }
    }
}

// MARK: - Mini Info View

struct MiniInfoView: View {
    let chosenCountry: Country?
    let connectionState: ConnectionButtonView.ConnectionState
    
    var body: some View {
        HStack(spacing: 12) {
            // Country info
            HStack(spacing: 8) {
                if let country = chosenCountry {
                    Text(country.emoji)
                        .font(.largeTitle)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Connected to")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(country.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("No location")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("Select a country")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                }
            }
            
            Spacer()
            
            // Connection status
            HStack(spacing: 6) {
                statusIcon
                Text(statusText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(statusColor)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusBackgroundColor.opacity(0.1))
            .cornerRadius(8)
        }
        .padding(.horizontal, 32)
        .padding(.top, 16)
    }
    
    // MARK: - Computed Properties
    
    private var statusIcon: some View {
        Image(systemName: statusIconName)
            .font(.caption)
            .foregroundColor(statusColor)
    }
    
    private var statusIconName: String {
        switch connectionState {
        case .notConnected:
            return "power"
        case .loading:
            return "wifi"
        case .connected:
            return "checkmark.shield.fill"
        }
    }
    
    private var statusText: String {
        switch connectionState {
        case .notConnected:
            return "Disconnected"
        case .loading:
            return "Connecting..."
        case .connected:
            return "Connected"
        }
    }
    
    private var statusColor: Color {
        switch connectionState {
        case .notConnected:
            return .secondary
        case .loading:
            return .orange
        case .connected:
            return .green
        }
    }
    
    private var statusBackgroundColor: Color {
        switch connectionState {
        case .notConnected:
            return .secondary
        case .loading:
            return .orange
        case .connected:
            return .green
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        MiniInfoView(
            chosenCountry: Country.sampleData[0],
            connectionState: .connected
        )
        
//        MiniInfoView(
//            chosenCountry: Country.sampleData[1],
//            connectionState: .loading
//        )
//        
//        MiniInfoView(
//            chosenCountry: nil,
//            connectionState: .notConnected
//        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview {
    GlobeContainerView()
}
