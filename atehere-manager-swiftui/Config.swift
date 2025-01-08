//
//  Config.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 3.11.2024.
//

import Foundation


struct Config {
    static let environment: Environment = .production // Change to .production when needed

    enum Environment {
        case development
        case production
    }

    static var baseURL: String {
        switch environment {
        case .development:
            return "http://127.0.0.1:8080"
        case .production:
            return "https://dorduncuboyut.media"
        }
    }

}
