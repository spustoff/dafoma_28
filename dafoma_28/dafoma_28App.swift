//
//  dafoma_28App.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

@main
struct EduWiseMostApp: App {
    @StateObject private var userViewModel = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if userViewModel.isAuthenticated {
                    MainTabView()
                        .environmentObject(userViewModel)
                } else {
                    OnboardingView()
                }
            }
            .onAppear {
                // Check if user is already authenticated
                // This will be handled by UserViewModel's init
            }
        }
    }
}
