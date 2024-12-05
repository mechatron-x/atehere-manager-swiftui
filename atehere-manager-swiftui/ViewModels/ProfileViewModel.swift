//
//  ProfileViewModel.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 9.11.2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var profile: ManagerProfile?
    @Published var isLoading: Bool = false
    @Published var isEditing: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var navigateToLogin: Bool = false

    private let authService = AuthService.shared

    
    func fetchProfile() {
        isLoading = true
        errorMessage = nil

        authService.getIdToken { [weak self] idToken in
            guard let self = self else { return }

            if let idToken = idToken {
                self.performProfileRequest(with: idToken)
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Authentication token is missing or expired. Please log in again."
                    self.isLoading = false
                    self.navigateToLogin = true
                }
            }
        }
    }

    private func performProfileRequest(with idToken: String) {
        guard let url = URL(string: "\(Config.baseURL)/api/v1/managers") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
                self.isLoading = false
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                if let data = data {
                    do {
                        let payload = try JSONDecoder().decode(ResponsePayload<ManagerProfile>.self, from: data)
                        
                        if let payloadData = payload.data{
                            self.profile = payloadData
                        }
                        else if let payloadError = payload.error {
                            self.errorMessage = payloadError.message
                        }
                        else {
                            self.errorMessage = "An unexpected error occurred. Please try again."
                        }
                        
                    } catch {
                        self.errorMessage = "Failed to get profile data."
                    }
                }
            }
        }.resume()
    }


    func updateProfile() {
        guard let profile = profile else { return }
        isLoading = true
        errorMessage = nil

        authService.getIdToken { [weak self] idToken in
            guard let self = self else { return }

            if let idToken = idToken {
                self.performUpdateProfileRequest(with: idToken, profile: profile)
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Authentication token is missing or expired. Please log in again."
                    self.isLoading = false
                    self.navigateToLogin = true
                }
            }
        }
    }
    
    private func performUpdateProfileRequest(with idToken: String, profile: ManagerProfile) {
        guard let url = URL(string: "\(Config.baseURL)/api/v1/managers") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
                self.isLoading = false
            }
            return
        }

        guard let jsonData = try? JSONEncoder().encode(profile) else {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to encode profile data."
                self.isLoading = false
            }
            return
        }
        


        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                                print("Response Data from Server: \(responseString)")
                            }
                
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid server response."
                    return
                }

                switch httpResponse.statusCode {
                case 200...299:
                    self.isEditing = false
                    self.fetchProfile()
                case 300...499:
                    self.handleErrorResponse(data: data, defaultMessage: "An error occurred. Please try again.")
                default:
                    self.errorMessage = "An unexpected error occurred. Please try again."
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
    
    func logout() {
        authService.logout { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.navigateToLogin = true
                case .failure(let error):
                    self?.errorMessage = "Logout failed: \(error.localizedDescription)"
                }
            }
        }
    }
}
