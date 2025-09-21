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
    
    struct Presentable {
        let state: ConnectionState
        let onTap: () -> Void
    }
    
    let presentable: Presentable
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            if presentable.state == .loading {
                LoadingRing
            }
            
            Button(action: presentable.onTap) {
                ZStack {
                    GlassBackground
                    
                    InnerGlassCircle
                    
                    GlassHighlight
                    
                    StateContent
                }
            }
            .buttonStyle(GlassButtonStyle())
        }
        .onAppear {
            if presentable.state == .loading {
                startLoadingAnimation()
            }
        }
        .onChange(of: presentable.state) { _, newState in
            if newState == .loading {
                startLoadingAnimation()
            } else {
                stopLoadingAnimation()
            }
        }
    }
    
    // MARK: - Sub-views as computed vars
    
    private var LoadingRing: some View {
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
    
    private var GlassBackground: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .frame(width: 200, height: 200)
            .background {
                Circle()
                    .fill(BackgroundGradient)
                    .blur(radius: 20)
                    .opacity(0.6)
            }
            .overlay {
                Circle()
                    .stroke(GlassStrokeGradient, lineWidth: 1.5)
                    .opacity(0.8)
            }
            .shadow(color: ShadowColor.opacity(0.15), radius: 30, x: 0, y: 15)
            .shadow(color: ShadowColor.opacity(0.1), radius: 60, x: 0, y: 30)
    }
    
    private var InnerGlassCircle: some View {
        Circle()
            .fill(.regularMaterial)
            .frame(width: 160, height: 160)
            .background {
                Circle()
                    .fill(InnerBackgroundGradient)
                    .blur(radius: 15)
                    .opacity(0.5)
            }
            .overlay {
                Circle()
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            }
    }
    
    private var GlassHighlight: some View {
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
    }
    
    @ViewBuilder
    private var StateContent: some View {
        switch presentable.state {
        case .loading:
            LoadingContent
        case .connected:
            ConnectedContent
        case .notConnected:
            NotConnectedContent
        }
    }
    
    private var LoadingContent: some View {
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
    
    private var ConnectedContent: some View {
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
    
    private var NotConnectedContent: some View {
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
    
    private var BackgroundGradient: LinearGradient {
        switch presentable.state {
        case .loading:
            return LinearGradient(
                colors: [Color.green.opacity(0.4), Color.mint.opacity(0.3)],
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
                colors: [Color.primary.opacity(0.2), Color.secondary.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var InnerBackgroundGradient: LinearGradient {
        switch presentable.state {
        case .loading:
            return LinearGradient(
                colors: [Color.green.opacity(0.2), Color.mint.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .connected:
            return LinearGradient(
                colors: [Color.green.opacity(0.15), Color.mint.opacity(0.08)],
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
    
    private var GlassStrokeGradient: LinearGradient {
        switch presentable.state {
        case .loading:
            return LinearGradient(
                colors: [.white.opacity(0.4), .green.opacity(0.3), .white.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .connected:
            return LinearGradient(
                colors: [.white.opacity(0.5), .green.opacity(0.4), .white.opacity(0.3)],
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
    
    private var ShadowColor: Color {
        switch presentable.state {
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
        isAnimating = true
    }
    
    private func stopLoadingAnimation() {
        isAnimating = false
    }
}

// MARK: - Glass Button Style

struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 30) {
        VStack {
            Text("Not Connected")
                .font(.caption)
                .foregroundColor(.secondary)
            ConnectionButtonView(
                presentable: ConnectionButtonView.Presentable(
                    state: .notConnected,
                    onTap: { print("Not connected tapped") }
                )
            )
        }
        
        VStack {
            Text("Loading")
                .font(.caption)
                .foregroundColor(.secondary)
            ConnectionButtonView(
                presentable: ConnectionButtonView.Presentable(
                    state: .loading,
                    onTap: { print("Loading tapped") }
                )
            )
        }
        
        VStack {
            Text("Connected")
                .font(.caption)
                .foregroundColor(.secondary)
            ConnectionButtonView(
                presentable: ConnectionButtonView.Presentable(
                    state: .connected,
                    onTap: { print("Connected tapped") }
                )
            )
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}