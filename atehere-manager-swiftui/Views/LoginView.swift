//
//  LoginView.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 3.11.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

        var body: some View {
            VStack {
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)

                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                Button(action: {
                    viewModel.login()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(5)
                }
                .padding()
                .disabled(viewModel.isLoading)

                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .padding()
            .navigationTitle("Manager Login")
            .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
                ContentView()
            }
        }
}

#Preview {
    LoginView()
}
