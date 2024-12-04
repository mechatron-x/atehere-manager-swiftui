//
//  RestaurantListView.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 17.11.2024.
//

import SwiftUI

struct RestaurantListView: View {
    @StateObject private var viewModel = RestaurantListViewModel()
    @State private var showProfile = false

    var body: some View {
        ZStack {
            VStack {
                // Custom Navigation Bar
                HStack {
                    Text("Restaurants")
                        .font(.system(size: 50))
                        .bold()
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showProfile.toggle()
                        }
                    }) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 50))
                            .padding()
                    }
                }
                .background(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)

                // Main Content
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
                .onAppear {
                    viewModel.fetchRestaurants()
                }
            }

            // Sliding Profile View
            if showProfile {
                ZStack {
                    // Dimmed Background
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showProfile = false
                            }
                        }

                    // Profile Panel
                    ProfileView(closeProfile: {
                        withAnimation {
                            showProfile = false
                        }
                    })
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    .offset(x: showProfile ? 0 : UIScreen.main.bounds.width)
                }
                .zIndex(1)
                .navigationBarHidden(true)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
}



#Preview {
    RestaurantListView()
}
