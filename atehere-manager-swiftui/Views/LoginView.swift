//
//  LoginView.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 3.11.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @State private var isPasswordVisible = false
    @State private var navigateToProfile = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background view
                Color("MainColor").ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // Login Title
                    HStack {
                        Text("Manager Login")
                            .font(.title)
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    
                    Group {
                        // Email Field
                        HStack {
                            Image(systemName: "at")
                                .padding(.trailing, 5)
                                .foregroundColor(.white)
                            
                            TextField("Email", text: $loginViewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                        
                        Divider()
                            .background(Color.white)
                            .padding(.bottom)
                        
                        // Password Field
                        HStack {
                            Image(systemName: "lock")
                                .padding(.trailing, 5)
                                .foregroundColor(.white)
                            
                            if isPasswordVisible {
                                TextField("Password", text: $loginViewModel.password)
                                    .foregroundColor(.white)
                            } else {
                                SecureField("Password", text: $loginViewModel.password)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .padding(.trailing, 5)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                        
                        Divider()
                            .background(Color.white)
                        
                    }
                    
                    // Error Message
                    if let errorMessage = loginViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    // Login Button
                    Button(action: {
                        loginViewModel.login()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("Secondary").opacity(0.1))
                                .frame(width: UIScreen.main.bounds.size.width - 60, height: 50)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                .frame(width: UIScreen.main.bounds.size.width - 60, height: 70)
                            
                            Text("Login")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 30)
                    }
                    .padding()
                    
                    // Loading Indicator
                    if loginViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                    }
                    
                    Spacer()
                    
        
                }
    
                .onReceive(loginViewModel.$isAuthenticated) { isAuthenticated in
                                    if isAuthenticated {
                                        navigateToProfile = true
                                    }
                                }

                NavigationLink(destination: RestaurantListView(), isActive: $navigateToProfile) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}


#Preview {
    LoginView()
}
