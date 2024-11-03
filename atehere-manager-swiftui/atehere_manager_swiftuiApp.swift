//
//  atehere_manager_swiftuiApp.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 3.11.2024.
//

import SwiftUI
import Firebase

@main
struct atehere_manager_swiftuiApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
