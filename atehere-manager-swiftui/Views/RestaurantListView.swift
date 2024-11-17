//
//  RestaurantListView.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 17.11.2024.
//

import SwiftUI

struct RestaurantListView: View {
    @StateObject private var viewModel = RestaurantListViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Restaurants...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                        Button("Retry") {
                            viewModel.fetchRestaurants()
                        }
                        .padding()
                    }
                } else if viewModel.restaurants.isEmpty {
                    Text("No restaurants available.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.restaurants) { restaurant in
                        NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                            RestaurantRowView(restaurant: restaurant)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Restaurants")
            .onAppear {
                viewModel.fetchRestaurants()
            }
        }
    }
}

#Preview {
    RestaurantListView()
}
