//
//  ConnectionButtonView.swift
//  WorldVPN
//
//  Created by Mustafa on 19.09.2025.
//

import SwiftUI

struct ConnectionButtonView: View {
    enum ConnectionState {
        case loading
        case connected
        case notConnected
    }
    
    let state: ConnectionState
    let onTap: () -> Void
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Circular loading ring (only visible during loading)
            if state == .loading {
                Circle()
                    .stroke(Color.clear, lineWidth: 4)
                    .frame(width: 220, height: 220)
                    .overlay {
                        Circle()
                            .trim(from: 0, to: 0.8)
                            .stroke(
                                LinearGradient(
                                    colors: [.green, .mint, .green.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                            .animation(
                                .linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                                value: isAnimating
                            )
                    }
            }
            
            Button(action: onTap) {
                ZStack {
                    // Glass background with blur effect
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 200, height: 200)
                        .background {
                            Circle()
                                .fill(backgroundGradient)
                                .blur(radius: 20)
                                .opacity(0.6)
                        }
                        .overlay {
                            Circle()
                                .stroke(glassStrokeGradient, lineWidth: 1.5)
                                .opacity(0.8)
                        }
                        .shadow(color: shadowColor.opacity(0.15), radius: 30, x: 0, y: 15)
                        .shadow(color: shadowColor.opacity(0.1), radius: 60, x: 0, y: 30)
                    
                    // Inner glass circle
                    Circle()
                        .fill(.regularMaterial)
                        .frame(width: 160, height: 160)
                        .background {
                            Circle()
                                .fill(innerBackgroundGradient)
                                .blur(radius: 15)
                                .opacity(0.5)
                        }
                        .overlay {
                            Circle()
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        }
                    
                    // Highlight effect for glass look
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.white.opacity(0.3), .clear],
                                center: .init(x: 0.3, y: 0.3),
                                startRadius: 0,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .blendMode(.overlay)
                    
                    // Content based on state
                    Group {
                        switch state {
                        case .loading:
                            loadingContent
                        case .connected:
                            connectedContent
                        case .notConnected:
                            notConnectedContent
                        }
                    }
                }
            }
            .buttonStyle(GlassButtonStyle())
        }
        .onAppear {
            if state == .loading {
                startLoadingAnimation()
            }
        }
        .onChange(of: state) { _, newState in
            if newState == .loading {
                startLoadingAnimation()
            } else {
                stopLoadingAnimation()
            }
        }
    }
    
    // MARK: - State-specific content
    
    @ViewBuilder
    private var loadingContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi")
                .font(.system(size: 50, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .green.opacity(0.3), radius: 6, x: 0, y: 3)
            
            Text("Connecting...")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
    
    @ViewBuilder
    private var connectedContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 50, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .mint.opacity(0.9)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
            
            Text("Connected")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .mint.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
    
    @ViewBuilder
    private var notConnectedContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "power")
                .font(.system(size: 50, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primary, .secondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .primary.opacity(0.2), radius: 6, x: 0, y: 3)
            
            Text("Connect")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primary, .secondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
    
    // MARK: - Computed properties
    
    private var backgroundGradient: LinearGradient {
        switch state {
        case .loading:
            return LinearGradient(
                colors: [Color.green.opacity(0.4), Color.mint.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .connected:
            return LinearGradient(
                colors: [Color.green.opacity(0.4), Color.mint.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .notConnected:
            return LinearGradient(
                colors: [Color.primary.opacity(0.1), Color.secondary.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var innerBackgroundGradient: LinearGradient {
        switch state {
        case .loading:
            return LinearGradient(
                colors: [Color.green.opacity(0.2), Color.mint.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .connected:
            return LinearGradient(
                colors: [Color.green.opacity(0.3), Color.mint.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .notConnected:
            return LinearGradient(
                colors: [Color.primary.opacity(0.05), Color.secondary.opacity(0.02)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var glassStrokeGradient: LinearGradient {
        switch state {
        case .loading:
            return LinearGradient(
                colors: [.white.opacity(0.4), .green.opacity(0.3), .white.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .connected:
            return LinearGradient(
                colors: [.white.opacity(0.4), .green.opacity(0.3), .white.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .notConnected:
            return LinearGradient(
                colors: [.white.opacity(0.3), .primary.opacity(0.2), .white.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var shadowColor: Color {
        switch state {
        case .loading:
            return .green
        case .connected:
            return .green
        case .notConnected:
            return .primary
        }
    }
    
    // MARK: - Animation methods
    
    private func startLoadingAnimation() {
        withAnimation {
            isAnimating = true
        }
    }
    
    private func stopLoadingAnimation() {
        withAnimation {
            isAnimating = false
        }
    }
}

// MARK: - Custom Glass Button Style

struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Previews

#Preview("All States") {
    ZStack {
        // Glass background for preview
        LinearGradient(
            colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack(spacing: 40) {
            Text("Glass Connection Button")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Not Connected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ConnectionButtonView(state: .notConnected) {
                        print("Not connected tapped")
                    }
                }
                
                VStack {
                    Text("Loading")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ConnectionButtonView(state: .loading) {
                        print("Loading tapped")
                    }
                }
                
                VStack {
                    Text("Connected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ConnectionButtonView(state: .connected) {
                        print("Connected tapped")
                    }
                }
            }
        }
        .padding()
    }
}

#Preview("Interactive Demo") {
    ConnectionButtonDemo()
}

// MARK: - Demo View for Interactive Preview

struct ConnectionButtonDemo: View {
    @State private var connectionState: ConnectionButtonView.ConnectionState = .notConnected

    var body: some View {
        ZStack {
            // Glass background for demo
            LinearGradient(
                colors: [.indigo.opacity(0.1), .teal.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Interactive Glass Button")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                ConnectionButtonView(state: connectionState) {
                    handleConnectionTap()
                }
                
                Text(statusText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
    
    private var statusText: String {
        switch connectionState {
        case .notConnected:
            return "Tap to connect to VPN"
        case .loading:
            return "Establishing secure connection..."
        case .connected:
            return "Connected securely\nTap to disconnect"
        }
    }
    
    private func handleConnectionTap() {
        switch connectionState {
        case .notConnected:
            connectionState = .loading
            // Simulate connection process
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                connectionState = .connected
            }
        case .loading:
            // Optionally allow canceling during loading
            connectionState = .notConnected
        case .connected:
            connectionState = .notConnected
        }
    }
}
