//
//  ManagerProfile.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 9.11.2024.
//

import Foundation
struct ManagerProfile: Codable {
    var email: String?
    var fullName: String?
    var phoneNumber: String?

    enum CodingKeys: String, CodingKey {
        case email
        case fullName = "full_name"
        case phoneNumber = "phone_number"
    }
}
