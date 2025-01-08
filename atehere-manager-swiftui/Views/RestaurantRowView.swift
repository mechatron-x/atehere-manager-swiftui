//
//  RestaurantRowView.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 17.11.2024.
//

import SwiftUI

struct RestaurantRowView: View {
    let restaurant: Restaurant

    var body: some View {
        HStack(alignment: .top) {
            // Restaurant Image
            AsyncImage(url: URL(string: restaurant.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 200, height: 120)
            .cornerRadius(8)
            .clipped()

            // Restaurant Details
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.headline)

                Text("Founded: \(restaurant.foundationYear)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Phone: \(restaurant.phoneNumber)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Hours: \(restaurant.openingTime) - \(restaurant.closingTime)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack{
                    Text("Working Days:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(restaurant.workingDays.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
