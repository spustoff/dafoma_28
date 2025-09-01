//
//  SignUpView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var userViewModel = UserViewModel()
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showSignIn = false
    @State private var showPersonalization = false
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.primaryWhite, Color.neomorphLight]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 16) {
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.accentOrange)
                                .neomorphismCard(cornerRadius: 30, shadowRadius: 8)
                                .frame(width: 80, height: 80)
                            
                            Text("EduWise Most")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.textPrimary)
                            
                            Text("Create your account to start learning")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 60)
                        
                        // Sign Up Form
                        VStack(spacing: 20) {
                            // Name Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Full Name")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("Enter your full name", text: $name)
                                    .textFieldStyle(NeomorphismTextFieldStyle())
                            }
                            
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("email", text: $email)
                                    .textFieldStyle(NeomorphismTextFieldStyle())
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.textPrimary)
                                
                                HStack {
                                    if isPasswordVisible {
                                        TextField("password", text: $password)
                                    } else {
                                        SecureField("password", text: $password)
                                    }
                                    
                                    Button(action: {
                                        isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundColor(.textSecondary)
                                    }
                                }
                                .textFieldStyle(NeomorphismTextFieldStyle())
                            }
                            
                            // Confirm Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Confirm Password")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.textPrimary)
                                
                                HStack {
                                    if isConfirmPasswordVisible {
                                        TextField("password", text: $confirmPassword)
                                    } else {
                                        SecureField("password", text: $confirmPassword)
                                    }
                                    
                                    Button(action: {
                                        isConfirmPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundColor(.textSecondary)
                                    }
                                }
                                .textFieldStyle(NeomorphismTextFieldStyle())
                            }
                        }
                        .padding(.horizontal, 40)
                        
                        // Error Message
                        if let errorMessage = userViewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal, 40)
                        }
                        
                        // Sign Up Button
                        Button(action: signUp) {
                            HStack {
                                if userViewModel.isLoading {
                                    SwiftUI.ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Create Account")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                            }
                            .foregroundColor(.textOnAccent)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.accentOrange : Color.gray)
                            .cornerRadius(15)
                        }
                        .buttonStyle(NeomorphismButtonStyle())
                        .disabled(!isFormValid || userViewModel.isLoading)
                        .padding(.horizontal, 40)
                        
                        // Sign In Link
                        HStack {
                            Text("Already have an account?")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                            
                            Button(action: {
                                showSignIn = true
                            }) {
                                Text("Sign In")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.accentOrange)
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .sheet(isPresented: $showSignIn) {
            SignInView()
        }
        .fullScreenCover(isPresented: $showPersonalization) {
            PersonalizationView()
        }
        .onChange(of: userViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                showPersonalization = true
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        password.count >= 6 &&
        email.contains("@")
    }
    
    private func signUp() {
        userViewModel.signUp(email: email, name: name, password: password)
    }
}

struct NeomorphismTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.neomorphLight)
            .neomorphismInset(cornerRadius: 12, shadowRadius: 3)
    }
}

#Preview {
    SignUpView()
}
