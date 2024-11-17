//
//  Restaurant.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 17.11.2024.
//

import Foundation

struct Restaurant: Codable, Identifiable {
    let id: String
    let name: String
    let foundationYear: String
    let phoneNumber: String
    let openingTime: String
    let closingTime: String
    let imageUrl: String
    var workingDays: [String]
    let tables: [RestaurantTable]
    
    
}
