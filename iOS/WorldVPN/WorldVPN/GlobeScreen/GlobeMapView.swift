//
//  GlobeMapView.swift
//  WorldVPN
//
//  Created by Mustafa on 16.09.2025.
//

import SwiftUI
import MapKit

struct GlobeMapView: View {
    struct Presentable {
        let cameraPosition: Binding<MapCameraPosition>
        let servers: [Server: CLLocation]
    }

    let presentable: Presentable

    var body: some View {
        Map(position: presentable.cameraPosition) {
            ForEach(Array(presentable.servers), id: \.key) { (server, location) in
                Annotation(server.location.city, coordinate: location.coordinate) {
                    Color.green.opacity(0.6)
                        .frame(width: 10, height: 10)
                        .clipShape(.circle)
                }

            }
        }
        .mapStyle(.imagery(elevation: .realistic))
    }
}
