//
//  RestaurantDetailView.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 17.11.2024.
//

/*
import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    @StateObject private var viewModel: RestaurantDetailViewModel

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        _viewModel = StateObject(wrappedValue: RestaurantDetailViewModel(restaurantID: restaurant.id))
    }

    var body: some View {
        GeometryReader { geometry in
            HStack {
                // Left Side: Restaurant Details (1/3 of the screen width)
                VStack(alignment: .leading, spacing: 16) {
                    
                    AsyncImage(url: URL(string: restaurant.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 220)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 220)
                    }
                    VStack(alignment: .leading) {
                        
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
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                }
                .frame(width: geometry.size.width / 3)
                
                Divider()

                // Right Side: Tables and Updates (2/3 of the screen width)
                VStack(spacing: 0) {
                    // Upper Half: Tables
                    Text("Tables:")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Divider()
                        .padding()
                    
                    ScrollView {

                        LazyVGrid(
                            columns: Array(repeating: GridItem(.fixed(150), spacing: 16), count: 4),
                            alignment: .center,
                            spacing: 16
                        ) {
                            ForEach(restaurant.tables) { table in
                                NavigationLink(destination: RestaurantTableDetailView(tableID: table.id, tableName: table.name)) {
                                    ZStack {
                                        Color("MainColor")
                                            .opacity(0.15)
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color("MainColor"), lineWidth: 2)
                                            )
                                        Text(table.name)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                            .frame(width: 150, height: 150)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: geometry.size.height / 2)

                    Divider()

                    Text("Updates:")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Divider()
                        .padding()
                    
                    // Lower Half: Updates
                    ScrollView {
                        if viewModel.isLoading {
                            ProgressView("Loading updates...")
                                .padding(.top, 8)
                                .frame(maxWidth: .infinity, alignment: .leading) // Align progress indicator to the left
                        } else if let errorMessage = viewModel.errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .padding(.top, 8)
                                .frame(maxWidth: .infinity, alignment: .leading) // Align error message to the left
                        } else if viewModel.updates.isEmpty {
                            Text("No updates available.")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .frame(maxWidth: .infinity, alignment: .leading) // Align empty message to the left
                        } else {
                            ForEach(viewModel.updates) { update in
                                VStack(alignment: .leading, spacing: 8) { // Ensure vertical alignment to the left
                                    Text(update.message)
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                                    Text("Time: \(update.invokeTime, formatter: dateFormatter)")
                                        .font(.caption)
                                        .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                                }
                                .padding(.vertical, 4)
                                Divider()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .frame(height: geometry.size.height / 2)
                    .padding(.horizontal)
                }
                .frame(width: (geometry.size.width / 3) * 2)
            }
        }
        .navigationTitle("Restaurant Details")
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


*/

import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    @StateObject private var viewModel: RestaurantDetailViewModel

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        _viewModel = StateObject(wrappedValue: RestaurantDetailViewModel(restaurantID: restaurant.id))
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Left Half: Tables
                VStack {
                    Text("Tables:")
                        .font(.headline)
                        .padding(.top, 8)

                    Divider()
                        .frame(maxWidth: .infinity)

                    VStack(alignment: .leading) {
                        ScrollView {
                            LazyVGrid(
                                columns: Array(repeating: GridItem(.fixed(150), spacing: 16), count: 3),
                                spacing: 16
                            ) {
                                ForEach(restaurant.tables) { table in
                                    NavigationLink(destination: RestaurantTableDetailView(tableID: table.id, tableName: table.name)) {
                                        TableItemView(tableName: table.name)
                                    }
                                }
                            }
                            .padding([.horizontal, .top], 16)
                        }
                    }
                }
                .frame(width: geometry.size.width / 2)

                Divider()

                // Right Half: Updates
                VStack {
                    Text("Updates:")
                        .font(.headline)
                        .padding(.top, 8)

                    Divider()

                    ScrollView {
                        if viewModel.isLoading {
                            ProgressView("Loading updates...")
                                .padding(.top, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else if let errorMessage = viewModel.errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .padding(.top, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else if viewModel.updates.isEmpty {
                            Text("No updates available.")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ForEach(viewModel.updates) { update in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(update.message)
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Time: \(update.invokeTime, formatter: dateFormatter)")
                                        .font(.caption)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.vertical, 4)
                                Divider()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(width: geometry.size.width / 2)
            }
        }
        .navigationTitle("Restaurant Details")
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


struct TableItemView: View {
    let tableName: String

    var body: some View {
        ZStack {
            Color("MainColor")
                .opacity(0.15)
                .frame(width: 150, height: 150)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("MainColor"), lineWidth: 2)
                )
            Text(tableName)
                .font(.headline)
                .foregroundColor(.black)
                .frame(width: 150, height: 150)
        }
    }
}
