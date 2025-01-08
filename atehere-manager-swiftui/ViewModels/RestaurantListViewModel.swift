//
//  RestaurantListViewModel.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 17.11.2024.
//

import Foundation

class RestaurantListViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var navigateToLogin: Bool = false

    private let authService = AuthService.shared

    func fetchRestaurants(completion: (() -> Void)? = nil) {
        isLoading = true
        errorMessage = nil

        authService.getIdToken { [weak self] idToken in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let idToken = idToken {
                    self.performFetchRestaurantsRequest(with: idToken, completion: completion)
                } else {
                    self.errorMessage = "Authentication token is missing or expired. Please log in again."
                    self.isLoading = false
                    self.navigateToLogin = true
                }
            }
        }
    }

    private func performFetchRestaurantsRequest(with idToken: String, completion: (() -> Void)? = nil) {
        guard let url = URL(string: "\(Config.baseURL)/api/v1/managers/restaurants") else {
            self.errorMessage = "Invalid URL."
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")

        performRequest(request, completion: completion)
    }

    private func performRequest(_ request: URLRequest, completion: (() -> Void)? = nil) {
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self?.errorMessage = "No data received from server."
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let payload = try decoder.decode(ResponsePayload<RestaurantList>.self, from: data)
                    //print(payload)
                    
                    if let payloadData = payload.data {
                        let normalizedRestaurants = payloadData.restaurants.map { restaurant -> Restaurant in
                            var restaurant = restaurant
                            restaurant.workingDays = restaurant.workingDays.map { $0.lowercased() }
                            return restaurant
                        }
                        self?.restaurants = normalizedRestaurants
                        completion?()
                    } else if let error = payload.error {
                        self?.errorMessage = error.message
                    } else {
                        self?.errorMessage = "Unexpected response format."
                    }
                } catch let decodingError {
                    //print("Decoding error: \(decodingError)")
                    self?.errorMessage = "Failed to parse data: \(decodingError.localizedDescription)"
                }
            }
        }.resume()
    }

    private func handleErrorResponse(data: Data?, defaultMessage: String) {
        if let data = data,
           let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
            self.errorMessage = serverError.message
        } else {
            self.errorMessage = defaultMessage
        }
    }
}

