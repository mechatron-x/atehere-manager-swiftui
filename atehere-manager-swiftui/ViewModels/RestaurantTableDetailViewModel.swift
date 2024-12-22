//
//  RestaurantTableDetailViewModel.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 8.12.2024.
//

import Foundation
import SwiftUI

class RestaurantTableDetailViewModel: ObservableObject {
    @Published var orderItems: [TableOrderItem] = []
    @Published var totalPrice: Double = 0.0
    @Published var currency: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    var tableID: String

    init(tableID: String) {
        self.tableID = tableID
    }

    func fetchOrders() {
        guard !tableID.isEmpty else {
            self.errorMessage = "Table ID is missing."
            return
        }

        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "\(Config.baseURL)/api/v1/tables/\(tableID)/orders?role=manager") else {
            self.errorMessage = "Invalid URL."
            self.isLoading = false
            return
        }
    
        AuthService.shared.getIdToken { [weak self] token in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard let bearerToken = token else {
                    self.errorMessage = "Failed to retrieve bearer token."
                    self.isLoading = false
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

                URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        self.isLoading = false

                        if let error = error {
                            self.errorMessage = "Network error: \(error.localizedDescription)"
                            return
                        }

                        guard let data = data else {
                            self.errorMessage = "No data received from server."
                            return
                        }

                        do {
                            let decoder = JSONDecoder()
                            let payload = try decoder.decode(ResponsePayload<TableOrders>.self, from: data)

                            if let data = payload.data {
                                self.orderItems = data.orders
                                self.totalPrice = data.totalPrice
                                self.currency = data.currency
                            } else if let payloadError = payload.error {
                                self.errorMessage = payloadError.message
                            } else {
                                self.errorMessage = "Failed to load table orders."
                            }
                        } catch {
                            self.errorMessage = "Failed to parse table orders."
                        }
                    }
                }.resume()
            }
        }
    }
}
