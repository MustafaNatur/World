//
//  CountriesListView.swift
//  WorldVPN
//
//  Created by Mustafa on 19.09.2025.
//

import SwiftUI

struct ServersListView: View {
    let servers: [Server]
    @Binding var selectedServer: Server?
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss

    var filteredCountries: [Server] {
        if searchText.isEmpty {
            servers
        } else {
            servers.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search countries...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.primary)

                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.secondary)
                .clipShape(.capsule)
                .padding(.horizontal)

                LazyVStack(spacing: 0) {
                    ForEach(filteredCountries) { server in
                        ServerRowView(
                            server: server,
                            isSelected: selectedServer?.id == server.id,
                            onTap: {
                                selectedServer = server
                                dismiss()
                            }
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        
                        if server.id != filteredCountries.last?.id {
                            Divider()
                                .padding(.leading)
                        }
                    }
                }
            }
            .padding(.top, 16)
        }
    }
}

struct ServerRowView: View {
    let server: Server
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Text(server.location.flagEmoji ?? "🌎")
                    .font(.largeTitle)
                    .frame(width: 40, height: 40)
                
                Text(server.location.city)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        ServersListView(servers: .mock, selectedServer: .constant(.mock))
    }
}
