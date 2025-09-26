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
    @State private var selectedDetent: PresentationDetent = .full
    @State private var sheetHeight: CGFloat = 0

    var body: some View {
        GlobeMapView(
            presentable: GlobeMapView.Presentable(
                cameraPosition: $viewModel.cameraPosition,
                servers: viewModel.serversData
            )
        )
        .task {
            await viewModel.loadSevers()
        }
        .onAppear {
            if viewModel.hasAnimatedToInitialPosition == false {
                viewModel.animateToInitialPosition()
            }
            showSheet = true
        }
        .onChange(of: viewModel.chosenServer) { _, newServer in
            if let server = newServer {
                viewModel.animateToServer(server)
            }
        }
        .sheet(isPresented: $showSheet) {
            SheetContent
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                sheetHeight = geometry.size.height
                            }
                            .onChange(of: geometry.size.height) { _, newHeight in
                                sheetHeight = newHeight
                                print(sheetHeight)
                            }
                    }
                )
        }
    }

    private var InfoView: some View {
        MiniInfoView(
            presentable: MiniInfoView.Presentable(
                chosenServer: viewModel.chosenServer,
                connectionState: viewModel.connectionState
            )
        )
        .opacity(selectedDetent == .small ? 1 : 0)
        .onTapGesture {
            selectedDetent = .full
        }
    }

    private var ConnectionView: some View {
        ConnectionContainerView(globeViewModel: viewModel)
            .opacity(selectedDetent == .full || selectedDetent == .large ? 1 : 0)
    }

    private var SheetContent: some View {
        ZStack(alignment: .center) {
            InfoView
            ConnectionView
        }
        .animation(.default, value: selectedDetent)
        .presentationDetents([.small, .full], selection: $selectedDetent)
        .presentationBackgroundInteraction(.enabled)
        .interactiveDismissDisabled()
    }
}

extension PresentationDetent {
    static let full: PresentationDetent = .height(370)
    static let small: PresentationDetent = .height(100)
}

#Preview {
    GlobeContainerView()
}
