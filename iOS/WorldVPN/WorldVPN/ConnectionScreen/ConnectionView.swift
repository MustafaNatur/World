//
//  ConnectionView.swift
//  WorldVPN
//
//  Created by Mustafa on 19.09.2025.
//

import SwiftUI

struct ConnectionView: View {
    struct Presentable {
        let connectionState: ConnectionButtonView.Presentable.ConnectionState
        let chosenServer: Server?
        let onConnectionTap: () -> Void
        let onCountryTap: () -> Void
    }
    
    let presentable: Presentable
    
    var body: some View {
        ZStack {
            BackgroundGradient
            
            VStack {
                ConnectionButtonSection
                
                CountrySelectionSection
            }
        }
    }
    
    // MARK: - Sub-views as computed vars
    
    private var BackgroundGradient: some View {
        LinearGradient(
            colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var ConnectionButtonSection: some View {
        ConnectionButtonView(
            presentable: ConnectionButtonView.Presentable(
                state: presentable.connectionState,
                onTap: presentable.onConnectionTap
            )
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.top, 10)
    }
    
    private var CountrySelectionSection: some View {
        VStack(spacing: 16) {
            CountrySelectionButton
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 12)
    }
    
    private var CountrySelectionButton: some View {
        Button(action: presentable.onCountryTap) {
            HStack(spacing: 16) {
                CountryFlag
                
                CountryInfo
                
                Spacer()
                
                ChevronIcon
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
    
    private var CountryFlag: some View {
        Text(presentable.chosenServer?.location.flagEmoji ?? "🌍")
            .font(.system(size: 32))
            .frame(width: 50, height: 50)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
    }
    
    private var CountryInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(presentable.chosenServer?.location.city ?? "Choose Country")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            Text(presentable.chosenServer != nil ? "Tap to change" : "Select your preferred location")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var ChevronIcon: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.secondary)
    }
}

#Preview {
    ConnectionView(
        presentable: ConnectionView.Presentable(
            connectionState: .notConnected,
            chosenServer: .mock,
            onConnectionTap: {},
            onCountryTap: {}
        )
    )
}
