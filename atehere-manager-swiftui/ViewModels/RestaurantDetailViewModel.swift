//
//  RestaurantDetailViewModel.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 5.12.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

class RestaurantDetailViewModel: ObservableObject {
    @Published var updates: [Update] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false


    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    let restaurantID: String

    init(restaurantID: String) {
        self.restaurantID = restaurantID
//        if let user = Auth.auth().currentUser {
//            print("User is authenticated with UID: \(user.uid)")
//        } else {
//            print("User is not authenticated.")
//        }
        
        listenToUpdates()
    }

    deinit {
        listener?.remove()
    }

    private func listenToUpdates() {
        isLoading = true
        listener = db.collection(restaurantID)
            .order(by: "invoke_time", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                self.isLoading = false

                if let error = error as NSError? {
                            DispatchQueue.main.async {
                                self.errorMessage = "Error listening to updates: \(error.localizedDescription)"
                                print("Error code: \(error.code)")
                                print("Error domain: \(error.domain)")
                                print("Error userInfo: \(error.userInfo)")
                            }
                            return
                        }

                guard let documents = snapshot?.documents else {
                    DispatchQueue.main.async {
                        self.errorMessage = "No updates found."
                    }
                    return
                }

                let updates = documents.compactMap { doc -> Update? in
                    let data = doc.data()
                    guard
                        let invokeTimeStamp = data["invoke_time"] as? Timestamp,
                        let message = data["message"] as? String,
                        let tableName = data["table_name"] as? String
                    else {
                        return nil
                    }
                    let invokeTime = invokeTimeStamp.dateValue()
                    return Update(id: doc.documentID, invokeTime: invokeTime, message: message, tableName: tableName)
                }

                DispatchQueue.main.async {
                    self.updates = updates
                }
            }
    }
}

