//
//  UserService.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import Foundation
import Combine

class UserService {
    private let baseURL = "https://api.eduwise.com" // Replace with actual API URL
    
    func signUp(email: String, name: String, password: String) -> AnyPublisher<User, Error> {
        // Mock implementation - replace with actual API call
        return Future<User, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let user = User(email: email, name: name)
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        // Mock implementation - replace with actual API call
        return Future<User, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let user = User(email: email, name: "John Doe")
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateProfile(user: User) -> AnyPublisher<User, Error> {
        // Mock implementation - replace with actual API call
        return Future<User, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getUserProfile(userId: UUID) -> AnyPublisher<User, Error> {
        // Mock implementation - replace with actual API call
        return Future<User, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let user = User(email: "user@example.com", name: "John Doe")
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }
}
