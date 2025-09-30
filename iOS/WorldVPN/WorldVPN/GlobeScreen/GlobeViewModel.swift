//
//  GlobeViewModel.swift
//  WorldVPN
//
//  Created by Mustafa on 16.09.2025.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine
import Observation
import UIKit

@Observable
final class GlobeViewModel {
    struct Config {
        let initialDistance: CLLocationDistance
        let initialCoordinate: CLLocationCoordinate2D
        let initialPitch: Double
        let initialHeading: Double
        let focusZoomValue: CGFloat
        let focusLocationLatitude: CLLocationDegrees
        var focusZoomDistance: CLLocationDistance {
            initialDistance / focusZoomValue
        }

        static let `default` = Config(
            initialDistance: 100_000_000,
            initialCoordinate: CLLocationCoordinate2D(latitude: 45, longitude: 40),
            initialPitch: 0,
            initialHeading: 0,
            focusZoomValue: 10,
            focusLocationLatitude: 10
        )
    }

    var connectionState: ConnectionButtonView.Presentable.ConnectionState = .notConnected
    var cameraPosition: MapCameraPosition = .automatic
    var hasAnimatedToInitialPosition = false
    var tappedCoordinate: CLLocationCoordinate2D?
    var chosenServer: Server?
    var serversData: [Server: CLLocation] = [:]
    let config: Config
    let vpnService: VPNService
    let vpnConnectionManager: VPNConnectionManager

    private var cancellables: Set<AnyCancellable> = []

    init(
        config: Config = .default,
        vpnService: VPNService = VPNServiceImpl(),
        vpnConnectionManager: VPNConnectionManager = VPNConnectionManager()
    ) {
        self.config = config
        self.vpnService = vpnService
        self.vpnConnectionManager = vpnConnectionManager

        vpnConnectionManager.$state
            .sink { [weak self] state in
                self?.handleConnectionStateChange(state)
            }
            .store(in: &cancellables)
    }

    deinit {
        cancellables.removeAll()
    }

    private func handleConnectionStateChange(_ newState: VPNConnectionState) {
        switch newState {
        case .connected:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            connectionState = .connected
        case .disconnected:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            connectionState = .notConnected
        case .connecting:
            connectionState = .loading
        case .disconnecting:
            connectionState = .loading
        }


    }

    func loadSevers() async {
        do {
            try await fetchServersAndLocations()
        }
        catch {
            print("Error fetching servers: \(error)")
        }
    }

    private func fetchServersAndLocations() async throws {
        let servers = try await vpnService.fetchServers()
        await withTaskGroup { [weak self] group in
            for server in servers {
                group.addTask {
                    let location = await server.getCoordinate()
                    await MainActor.run {
                        self?.serversData[server] = location
                    }
                }
            }
        }
    }

    func animateToInitialPosition() {
        let initialCamera = MapCamera(
            centerCoordinate: config.initialCoordinate,
            distance: config.initialDistance,
            heading: config.initialHeading,
            pitch: config.initialPitch
        )

        withAnimation(.easeInOut(duration: 2.0)) {
            cameraPosition = .camera(initialCamera)
        }
        
        hasAnimatedToInitialPosition = true
    }

    func resetCameraPosition() {
        animateToInitialPosition()
    }

    func animateToServer(_ server: Server) {
        guard let location = serversData[server] else {
            return
        }

        let focusLocation = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude - config.focusLocationLatitude,
            longitude: location.coordinate.longitude
        )

        let countryCamera = MapCamera(
            centerCoordinate: focusLocation,
            distance: config.focusZoomDistance,
            heading: config.initialHeading,
            pitch: config.initialPitch
        )

        withAnimation(.easeInOut(duration: 1.5)) {
            cameraPosition = .camera(countryCamera)
        }
    }


    func handleConnectionTap() {
        switch connectionState {
        case .notConnected:
            guard let chosenServer else { return }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            try? vpnConnectionManager.connect(to: chosenServer, with: .IKEv2)
        case .loading:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            vpnConnectionManager.disconnect()
        case .connected:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            vpnConnectionManager.disconnect()
        }
    }
}
