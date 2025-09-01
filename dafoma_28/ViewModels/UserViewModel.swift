//
//  UserViewModel.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let userService: UserService
    
    init(userService: UserService = UserService()) {
        self.userService = userService
        loadCurrentUser()
    }
    
    func signUp(email: String, name: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        userService.signUp(email: email, name: name, password: password)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] user in
                    self?.currentUser = user
                    self?.isAuthenticated = true
                    self?.saveUserToDefaults(user)
                }
            )
            .store(in: &cancellables)
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        userService.signIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] user in
                    self?.currentUser = user
                    self?.isAuthenticated = true
                    self?.saveUserToDefaults(user)
                }
            )
            .store(in: &cancellables)
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: "current_user")
    }
    
    func setCurrentUser(_ user: User) {
        currentUser = user
        isAuthenticated = true
        saveUserToDefaults(user)
    }
    
    func updateProfile(name: String, selectedLanguages: [Language], learningGoals: [LearningGoal]) {
        guard var user = currentUser else { return }
        
        user.name = name
        user.selectedLanguages = selectedLanguages
        user.learningGoals = learningGoals
        
        isLoading = true
        
        userService.updateProfile(user: user)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] updatedUser in
                    self?.currentUser = updatedUser
                    self?.saveUserToDefaults(updatedUser)
                }
            )
            .store(in: &cancellables)
    }
    
    func updateProgress(lessonsCompleted: Int, timeSpent: TimeInterval, points: Int) {
        guard var user = currentUser else { return }
        
        user.progress.totalLessonsCompleted += lessonsCompleted
        user.progress.totalTimeSpent += timeSpent
        user.progress.totalPoints += points
        user.progress.experiencePoints += points
        
        // Level up logic
        let newLevel = (user.progress.experiencePoints / 1000) + 1
        if newLevel > user.progress.level {
            user.progress.level = newLevel
        }
        
        currentUser = user
        saveUserToDefaults(user)
    }
    
    private func loadCurrentUser() {
        if let userData = UserDefaults.standard.data(forKey: "current_user"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
            isAuthenticated = true
        }
    }
    
    private func saveUserToDefaults(_ user: User) {
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: "current_user")
        }
    }
}

