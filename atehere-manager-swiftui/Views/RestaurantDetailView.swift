//
//  RestaurantDetailView.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 17.11.2024.
//

import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    @StateObject private var viewModel: RestaurantDetailViewModel

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        _viewModel = StateObject(wrappedValue: RestaurantDetailViewModel(restaurantID: restaurant.id))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Restaurant Image
                AsyncImage(url: URL(string: restaurant.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 500)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(maxWidth: .infinity)
                .clipped()

                // Restaurant Details
                VStack(alignment: .leading, spacing: 8) {
                    Text(restaurant.name)
                        .font(.largeTitle)
                        .bold()

                    HStack {
                        Text("Founded:")
                            .font(.headline)
                        Text(restaurant.foundationYear)
                            .font(.subheadline)
                    }

                    HStack {
                        Text("Phone:")
                            .font(.headline)
                        Text(restaurant.phoneNumber)
                            .font(.subheadline)
                    }

                    HStack {
                        Text("Hours:")
                            .font(.headline)
                        Text("\(restaurant.openingTime) - \(restaurant.closingTime)")
                            .font(.subheadline)
                    }

                    Text("Working Days:")
                        .font(.headline)
                    Text(restaurant.workingDays.joined(separator: ", "))
                        .font(.subheadline)

                    Text("Tables:")
                        .font(.headline)
                        .padding(.top, 8)

                    ForEach(restaurant.tables) { table in
                        Text("- \(table.name)")
                            .font(.subheadline)
                    }

                    // Updates Section
                    Divider()
                        .padding(.vertical)

                    Text("Updates:")
                        .font(.headline)

                    if viewModel.isLoading {
                        ProgressView("Loading updates...")
                            .padding(.top, 8)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding(.top, 8)
                    } else if viewModel.updates.isEmpty {
                        Text("No updates available.")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    } else {
                        ForEach(viewModel.updates) { update in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(update.message)
                                    .font(.headline)
                                Text("Table: \(update.tableName)")
                                    .font(.subheadline)
                                Text("Time: \(update.invokeTime, formatter: dateFormatter)")
                                    .font(.caption)
                            }
                            .padding(.vertical, 4)
                            Divider()
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
