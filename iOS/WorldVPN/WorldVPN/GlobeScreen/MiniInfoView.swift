//
//  MiniInfoView.swift
//  WorldVPN
//
//  Created by Mustafa on 16.09.2025.
//

import SwiftUI

struct MiniInfoView: View {
    struct Presentable {
        let chosenCountry: Country?
        let connectionState: ConnectionButtonView.ConnectionState
    }
    
    let presentable: Presentable
    
    var body: some View {
        HStack(spacing: 12) {
            CountryInfoSection
            
            Spacer()
            
            ConnectionStatusBadge
        }
        .padding(.horizontal, 32)
        .padding(.top, 16)
    }
    
    // MARK: - Sub-views as computed vars
    
    private var CountryInfoSection: some View {
        HStack(spacing: 8) {
            if let country = presentable.chosenCountry {
                CountryFlag(emoji: country.emoji)
                
                CountryDetails(
                    countryName: country.name,
                    isSelected: true
                )
            } else {
                CountryDetails(
                    countryName: "Select a country",
                    isSelected: false
                )
            }
        }
    }
    
    private var CountryFlag: some View {
        Text(presentable.chosenCountry?.emoji ?? "🌍")
            .font(.largeTitle)
    }
    
    private func CountryFlag(emoji: String) -> some View {
        Text(emoji)
            .font(.largeTitle)
    }
    
    private func CountryDetails(countryName: String, isSelected: Bool) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(isSelected ? "Connected to" : "No location")
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(countryName)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
    
    private var ConnectionStatusBadge: some View {
        HStack(spacing: 6) {
            StatusIcon
            
            StatusText
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(StatusBackgroundColor.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var StatusIcon: some View {
        Image(systemName: StatusIconName)
            .font(.caption)
            .foregroundColor(StatusColor)
    }
    
    private var StatusText: some View {
        Text(StatusTextString)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(StatusColor)
    }
    
    // MARK: - Computed properties
    
    private var StatusIconName: String {
        switch presentable.connectionState {
        case .notConnected:
            return "power"
        case .loading:
            return "wifi"
        case .connected:
            return "checkmark.shield.fill"
        }
    }
    
    private var StatusTextString: String {
        switch presentable.connectionState {
        case .notConnected:
            return "Disconnected"
        case .loading:
            return "Connecting..."
        case .connected:
            return "Connected"
        }
    }
    
    private var StatusColor: Color {
        switch presentable.connectionState {
        case .notConnected:
            return .secondary
        case .loading:
            return .orange
        case .connected:
            return .green
        }
    }
    
    private var StatusBackgroundColor: Color {
        switch presentable.connectionState {
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
            presentable: MiniInfoView.Presentable(
                chosenCountry: .mock,
                connectionState: .connected
            )
        )
        
        MiniInfoView(
            presentable: MiniInfoView.Presentable(
                chosenCountry: .mock,
                connectionState: .loading
            )
        )
        
        MiniInfoView(
            presentable: MiniInfoView.Presentable(
                chosenCountry: nil,
                connectionState: .notConnected
            )
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
