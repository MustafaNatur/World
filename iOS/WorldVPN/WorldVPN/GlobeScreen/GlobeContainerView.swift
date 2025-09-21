//
//  GlobeContainerView.swift
//  WorldVPN
//
//  Created by Mustafa on 16.09.2025.
//

import SwiftUI
import MapKit

struct GlobeContainerView: View {
    @State private var viewModel = GlobeViewModel()
    @State private var showSheet: Bool = false
    @State private var selectedDetent: PresentationDetent = .fraction(0.50)

    var body: some View {
        GlobeMapView(
            presentable: GlobeMapView.Presentable(
                cameraPosition: $viewModel.cameraPosition,
                onTap: { location in
                    viewModel.handleMapTap(at: location)
                }
            )
        )
        .overlay(alignment: .bottomTrailing) {
            SearchButton
        }
        .onAppear {
            if viewModel.hasAnimatedToInitialPosition == false {
                viewModel.animateToInitialPosition()
            }
            showSheet = true
        }
        .onChange(of: viewModel.chosenCountry) { _, newCountry in
            if let country = newCountry {
                viewModel.animateToCountry(country)
            }
        }
        .sheet(isPresented: $showSheet) {
            SheetContent
        }
    }
    
    // MARK: - Sub-views as computed vars
    
    private var SearchButton: some View {
        SearchButtonView(
            presentable: SearchButtonView.Presentable {
                showSheet = true
            }
        )
        .opacity(showSheet ? 0 : 1)
        .animation(.default, value: showSheet)
    }
    
    private var SheetContent: some View {
        ZStack(alignment: .center) {
            MiniInfoView(
                presentable: MiniInfoView.Presentable(
                    chosenCountry: viewModel.chosenCountry,
                    connectionState: viewModel.connectionState
                )
            )
            .opacity(selectedDetent == .height(100) ? 1 : 0)
            .onTapGesture {
                selectedDetent = .fraction(0.50)
            }

            ConnectionContainerView(globeViewModel: viewModel)
                .opacity(selectedDetent == .fraction(0.50) || selectedDetent == .large ? 1 : 0)
        }
        .presentationDetents([.height(100), .fraction(0.50)], selection: $selectedDetent)
        .presentationBackgroundInteraction(.enabled)
        .interactiveDismissDisabled()
    }
}

#Preview {
    GlobeContainerView()
}