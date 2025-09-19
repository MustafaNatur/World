//
//  CountriesListView.swift
//  WorldVPN
//
//  Created by Mustafa on 19.09.2025.
//

import SwiftUI

struct CountriesListView: View {
    @Binding var selectedCountry: Country?
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss

    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return Country.sampleData
        } else {
            return Country.sampleData.filter { 
                $0.name.lowercased().contains(searchText.lowercased()) 
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar


            // Countries List
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
//                .padding(.top, 20)


                LazyVStack(spacing: 0) {
                    ForEach(filteredCountries) { country in
                        CountryRowView(
                            country: country,
                            isSelected: selectedCountry?.id == country.id,
                            onTap: {
                                selectedCountry = country
                                dismiss()
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
            .padding(.top, 16)
        }
        .navigationTitle("Choose Country")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
}

struct CountryRowView: View {
    let country: Country
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Text(country.emoji)
                    .font(.largeTitle)
                    .frame(width: 40, height: 40)
                
                Text(country.name)
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
        CountriesListView(selectedCountry: .constant(Country.sampleData.first))
    }
}
