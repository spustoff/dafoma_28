//
//  SignInView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @Environment(\.presentationMode) var presentationMode
    
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
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                                .foregroundColor(.textSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 40)
                            
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.accentOrange)
                                .neomorphismCard(cornerRadius: 30, shadowRadius: 8)
                                .frame(width: 80, height: 80)
                            
                            Text("Welcome Back")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.textPrimary)
                            
                            Text("Sign in to continue your learning journey")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                        
                        // Sign In Form
                        VStack(spacing: 20) {
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
                        }
                        .padding(.horizontal, 40)
                        
                        // Forgot Password
                        Button(action: {
                            // Handle forgot password
                        }) {
                            Text("Forgot Password?")
                                .font(.subheadline)
                                .foregroundColor(.accentOrange)
                        }
                        
                        // Error Message
                        if let errorMessage = userViewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal, 40)
                        }
                        
                        // Sign In Button
                        Button(action: signIn) {
                            HStack {
                                if userViewModel.isLoading {
                                    SwiftUI.ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Sign In")
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
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .onChange(of: userViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && email.contains("@")
    }
    
    private func signIn() {
        // Special admin login for Apple reviewers
        if email.lowercased() == "admin@gmail.com" && password == "admin" {
            // Create a mock admin user and sign in directly
            var adminUser = User(email: "admin@gmail.com", name: "Admin User")
            
            // Add some sample progress for the admin user
            adminUser.progress.totalLessonsCompleted = 15
            adminUser.progress.totalTimeSpent = 7200 // 2 hours
            adminUser.progress.currentStreak = 7
            adminUser.progress.longestStreak = 12
            adminUser.progress.totalPoints = 850
            adminUser.progress.level = 3
            adminUser.progress.experiencePoints = 2850
            
            // Add sample languages and goals
            adminUser.selectedLanguages = [.french, .spanish]
            adminUser.learningGoals = [
                LearningGoal(
                    title: "Master French Banking",
                    description: "Become fluent in French financial terminology",
                    targetLanguage: .french,
                    targetSkill: .banking,
                    targetDate: Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()
                )
            ]
            
            userViewModel.setCurrentUser(adminUser)
            return
        }
        
        // Regular login flow
        userViewModel.signIn(email: email, password: password)
    }
}

#Preview {
    SignInView()
        .environmentObject(UserViewModel())
}
