//
//  SearchButtonView.swift
//  WorldVPN
//
//  Created by Mustafa on 16.09.2025.
//

import SwiftUI

struct SearchButtonView: View {
    struct Presentable {
        let onTap: () -> Void
    }
    
    let presentable: Presentable
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                SearchButton
                    .padding(.top, 20)
                    .padding(.trailing, 20)
            }
            Spacer()
        }
    }
    
    // MARK: - Sub-views as computed vars
    
    private var SearchButton: some View {
        Button(action: presentable.onTap) {
            SearchButtonIcon
                .frame(width: 44, height: 44)
                .background(SearchButtonBackground)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
    
    private var SearchButtonIcon: some View {
        Image(systemName: "magnifyingglass")
            .font(.title2)
            .foregroundColor(.white)
    }
    
    private var SearchButtonBackground: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}