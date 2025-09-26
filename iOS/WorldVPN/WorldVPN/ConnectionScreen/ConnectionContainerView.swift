//
//  ConnectionContainerView.swift
//  WorldVPN
//
//  Created by Mustafa on 19.09.2025.
//

import SwiftUI

struct ConnectionContainerView: View {
    @Bindable var globeViewModel: GlobeViewModel
    @State private var showCountriesList = false

    var body: some View {
        ConnectionView(
            presentable: ConnectionView.Presentable(
                connectionState: globeViewModel.connectionState,
                chosenServer: globeViewModel.chosenServer,
                onConnectionTap: {
                    globeViewModel.handleConnectionTap()
                },
                onCountryTap: {
                    showCountriesList = true
                }
            )
        )
        .sheet(isPresented: $showCountriesList) {
            ServersListView(
                servers: Array(globeViewModel.serversData.keys),
                selectedServer: $globeViewModel.chosenServer
            )
        }
    }
}

#Preview {
    ConnectionContainerView(globeViewModel: GlobeViewModel())
}
