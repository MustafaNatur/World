//
//  GlobeBottomSheet.swift
//  WorldVPN
//
//  Created by Mustafa on 19.09.2025.
//

import SwiftUI

struct GlobeBottomSheet: View {
    @Binding var selectedCountry: Country?
    @State private var searchText = ""
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return Country.sampleData
        } else {
            return Country.sampleData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
            .background(Color(.systemBackground))
            .clipShape(.capsule)
            .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredCountries) { country in
                        CountryRowView(
                            country: country,
                            isSelected: selectedCountry?.id == country.id,
                            onTap: {
                                selectedCountry = country
                            }
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        
                        if country.id != filteredCountries.last?.id {
                            Divider()
                                .padding(.leading)
                        }
                    }
                }
            }
        }
        .padding(.top, 20)
    }
}


#Preview {
    GlobeBottomSheet(selectedCountry: .constant(Country.sampleData.first))
}
