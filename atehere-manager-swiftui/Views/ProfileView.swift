//
//  ProfileView.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 9.11.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var profileViewModel = ProfileViewModel()
    @State private var isPasswordVisible = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Text("Profile")
                        .font(.largeTitle)
                        .bold()
                        .padding(.leading)
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    if profileViewModel.isLoading {
                        // Loading Indicator
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .padding()
                    } else if let errorMessage = profileViewModel.errorMessage {
                        // Error Message
                        Text(errorMessage)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else if let profile = profileViewModel.profile {
                        Group {
                            HStack {
                                Text("Manager Information")
                                    .frame(alignment: .leading)
                                    .font(.title)
                                    .bold()
                                    .padding(.leading)
                                
                                Spacer()
                            }
                            Spacer()
                            // Email Field
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.black)
                                if let email = profile.email {
                                    Text(email)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, geometry.size.width > 600 ? 100 : 16)
                            
                            // Full Name Field
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.black)
                                if profileViewModel.isEditing {
                                    TextField("Full Name", text: Binding(
                                        get: { profile.fullName ?? "" },
                                        set: { newValue in
                                            profileViewModel.profile?.fullName = newValue.isEmpty ? nil : newValue
                                        }
                                    ))
                                    .autocapitalization(.words)
                                    .foregroundColor(.black)
                                } else {
                                    if let fullName = profile.fullName {
                                        Text(fullName)
                                            .foregroundColor(.black)
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(profileViewModel.isEditing ? Color.clear : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, geometry.size.width > 600 ? 100 : 16)
                        }
                        
                        // Phone Number Field
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.black)
                            if profileViewModel.isEditing {
                                TextField("Phone Number", text: Binding(
                                    get: { profile.phoneNumber ?? "" },
                                    set: { newValue in
                                        profileViewModel.profile?.phoneNumber = newValue.isEmpty ? nil : newValue
                                    }
                                ))
                                .foregroundColor(.black)
                                .keyboardType(.phonePad)
                                
                            } else {
                                if let phoneNumber = profile.phoneNumber {
                                    Text(phoneNumber)
                                        .foregroundColor(.black)
                                }
                                
                            }
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(profileViewModel.isEditing ? Color.clear : Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal, geometry.size.width > 600 ? 100 : 16)
                        
                        Spacer()
                        
                        // Edit Button
                        Button(action: {
                            if profileViewModel.isEditing {
                                profileViewModel.updateProfile()
                                profileViewModel.isEditing = false
                            } else {
                                profileViewModel.isEditing = true
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color("MainColor"))
                                    .frame(width: geometry.size.width > 600 ? 500 : UIScreen.main.bounds.size.width - 60, height: 50)
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                    .frame(width: geometry.size.width > 600 ? 500 : UIScreen.main.bounds.size.width - 60, height: 50)
                                Text(profileViewModel.isEditing ? "Save Changes" : "Edit")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, geometry.size.width > 600 ? 100 : 16)
                        .padding()
                        
                        // Logout Button
                        Button(action: {
                            profileViewModel.logout()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.red.opacity(0.85))
                                    .frame(width: geometry.size.width > 600 ? 500 : UIScreen.main.bounds.size.width - 60, height: 50)
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                    .frame(width: geometry.size.width > 600 ? 500 : UIScreen.main.bounds.size.width - 60, height: 50)
                                Text("Logout")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, geometry.size.width > 600 ? 100 : 16)
                        
                        Spacer()
                    }
                    
                    NavigationLink(destination: LoginView(), isActive: $profileViewModel.navigateToLogin) {
                        EmptyView()
                    }
                }
                .onAppear {
                    profileViewModel.fetchProfile()
                }
                .navigationBarBackButtonHidden(true)
                
            }
            
        }
        
    }
        
}

#Preview {
    ProfileView()
}
