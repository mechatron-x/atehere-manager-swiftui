//
//  RestaurantTableDetailView.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 8.12.2024.
//

import SwiftUI

struct RestaurantTableDetailView: View {
    let tableID: String
    let tableName: String
    @StateObject private var viewModel: RestaurantTableDetailViewModel

    init(tableID: String, tableName: String) {
        self.tableID = tableID
        self.tableName = tableName
        _viewModel = StateObject(wrappedValue: RestaurantTableDetailViewModel(tableID: tableID))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading orders...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if viewModel.orderItems.isEmpty {
                Text("No orders have been placed for this table yet.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.orderItems) { order in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(order.menuItemName)
                                .font(.headline)
                            Spacer()
                            Text("Qty: \(order.quantity)")
                                .font(.subheadline)
                        }

                        HStack {
                            Text("Unit Price:")
                            Text(String(format: "%.2f %@", order.unitPrice, viewModel.currency))
                                .fontWeight(.medium)
                        }
                        .font(.subheadline)

                        HStack {
                            Text("Line Total:")
                            Text(String(format: "%.2f %@", order.totalPrice, viewModel.currency))
                                .fontWeight(.medium)
                        }
                        .font(.subheadline)
                        .padding(.bottom, 8)
                    }
                    .padding(.vertical, 4)
                }

                if viewModel.totalPrice > 0 {
                    HStack {
                        Text("Total Price for Table:")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f %@", viewModel.totalPrice, viewModel.currency))
                            .font(.headline)
                            .bold()
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Table: \(tableName)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchOrders()
        }
    }
}
