//
//  MiniInfoView.swift
//  WorldVPN
//
//  Created by Mustafa on 16.09.2025.
//

import SwiftUI

struct MiniInfoView: View {
    struct Presentable {
        let chosenServer: Server?
        let connectionState: ConnectionButtonView.Presentable.ConnectionState
    }
    let presentable: Presentable

    var body: some View {
        HStack(spacing: 12) {
            CountryInfoSection
            Spacer()
            ConnectionStatusBadge
        }
        .padding(.horizontal, 32)
        .padding(.top, UIDevice.isiPad ? 0 : 16)
    }
    
    private var CountryInfoSection: some View {
        HStack(spacing: 8) {
            if let location = presentable.chosenServer?.location {
                CountryFlag(emoji: location.flagEmoji ?? "🌎")

                CountryDetails(
                    countryName: location.city,
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

extension UIDevice {
    fileprivate static var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

#Preview {
    VStack(spacing: 20) {
        MiniInfoView(
            presentable: MiniInfoView.Presentable(
                chosenServer: .mock,
                connectionState: .connected
            )
        )
        
        MiniInfoView(
            presentable: MiniInfoView.Presentable(
                chosenServer: .mock,
                connectionState: .loading
            )
        )
        
        MiniInfoView(
            presentable: MiniInfoView.Presentable(
                chosenServer: nil,
                connectionState: .notConnected
            )
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
