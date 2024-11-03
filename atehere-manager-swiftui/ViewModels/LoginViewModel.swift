//
//  LoginViewModel.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 3.11.2024.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var isVerified: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    private let authService = AuthService.shared

    func login() {
        isLoading = true
        errorMessage = nil
        print("Login ViewModel: Login method called")
        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    if user.isEmailVerified {
                        self?.isVerified = true
                        self?.isAuthenticated = true
                    } else {
                        self?.isVerified = false
                        self?.isAuthenticated = false
                        self?.sendEmailVerification()
                        self?.errorMessage = "Please verify your email to continue."
                    }
                case .failure(let error):
                    self?.handleAuthError(error)
                }
            }
        }
    }

    func sendEmailVerification() {
        authService.sendEmailVerification { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.alertMessage = "A verification email has been sent. Please check your inbox."
                    self?.showAlert = true
                case .failure(let error):
                    self?.errorMessage = "Email verification error: \(error.localizedDescription)"
                }
            }
        }
    }

    private func handleAuthError(_ error: Error) {
        if let error = error as NSError? {
            switch AuthErrorCode(rawValue: error.code) {
            case .networkError:
                self.errorMessage = "Network error. Please try again."
            case .wrongPassword:
                self.errorMessage = "Incorrect password. Please try again."
            case .invalidEmail:
                self.errorMessage = "Invalid email address."
            case .userNotFound:
                self.errorMessage = "No account found with this email."
            default:
                self.errorMessage = "Login error: \(error.localizedDescription)"
            }
        } else {
            self.errorMessage = "An unknown error occurred."
        }
    }
}
