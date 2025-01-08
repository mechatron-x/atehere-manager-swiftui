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
    @Published var updates: [UpdateEvent] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false


    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    let restaurantID: String

    init(restaurantID: String) {
        self.restaurantID = restaurantID
        listenToUpdates()
    }

    deinit {
        listener?.remove()
    }

    
    func listenToUpdates() {
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
                    
                    let updates = documents.compactMap { doc -> UpdateEvent? in
                        let data = doc.data()
                        //print("Document Data:", data)
                        
                        if let invokeTimeNumber = data["invoke_time"] as? Int64,
                           let message = data["message"] as? String {
                            let invokeTime = Date(timeIntervalSince1970: TimeInterval(invokeTimeNumber))
                            let newEvent = UpdateEvent(id: doc.documentID, invokeTime: invokeTime, message: message)
                            //print("Parsed UpdateEvent:", newEvent)
                            return newEvent
                        }
                        
                        print("Failed to parse invoke_time for document:", doc.documentID)
                        return nil
                    }

                    DispatchQueue.main.async {
                        self.updates = updates.sorted(by: { $0.invokeTime > $1.invokeTime })
                        print("Updates Array:", self.updates)
                    }
                }
        }
}

