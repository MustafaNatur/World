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
        NavigationStack {
            ConnectionView(
                connectionState: globeViewModel.connectionState,
                chosenCountry: globeViewModel.chosenCountry,
                onConnectionTap: {
                    globeViewModel.handleConnectionTap()
                },
                onCountryTap: {
                    showCountriesList = true
                }
            )
            .navigationDestination(isPresented: $showCountriesList) {
                CountriesListView(selectedCountry: $globeViewModel.chosenCountry)
            }
        }
    }
}

#Preview {
    ConnectionContainerView(globeViewModel: GlobeViewModel())
}
