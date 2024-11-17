//
//  RestaurantDetailView.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 17.11.2024.
//

import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Restaurant Image
                AsyncImage(url: URL(string: restaurant.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
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
                }
                .padding()
            }
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


