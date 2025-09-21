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
        let onTap: (CGPoint) -> Void
    }

    let presentable: Presentable

    var body: some View {
        Map(position: presentable.cameraPosition)
            .mapStyle(.hybrid(elevation: .realistic))
            .ignoresSafeArea(.all)
            .onTapGesture { location in
                presentable.onTap(location)
            }
    }
}
