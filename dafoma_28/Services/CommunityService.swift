//
//  CommunityService.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import Foundation
import Combine

class CommunityService {
    private let baseURL = "https://api.eduwise.com" // Replace with actual API URL
    
    func getAllChallenges() -> AnyPublisher<[Challenge], Error> {
        // Mock implementation - replace with actual API call
        return Future<[Challenge], Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let challenges = self.createMockChallenges()
                promise(.success(challenges))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getUserChallenges(userId: UUID) -> AnyPublisher<[Challenge], Error> {
        // Mock implementation - replace with actual API call
        return Future<[Challenge], Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let challenges = Array(self.createMockChallenges().prefix(1))
                promise(.success(challenges))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func joinChallenge(challengeId: UUID, userId: UUID) -> AnyPublisher<Bool, Error> {
        // Mock implementation - replace with actual API call
        return Future<Bool, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                promise(.success(true))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getLeaderboard(challengeId: UUID) -> AnyPublisher<[LeaderboardEntry], Error> {
        // Mock implementation - replace with actual API call
        return Future<[LeaderboardEntry], Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let leaderboard = self.createMockLeaderboard()
                promise(.success(leaderboard))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getCommunityPosts() -> AnyPublisher<[CommunityPost], Error> {
        // Mock implementation - replace with actual API call
        return Future<[CommunityPost], Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                let posts = self.createMockPosts()
                promise(.success(posts))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func createPost(_ post: CommunityPost) -> AnyPublisher<CommunityPost, Error> {
        // Mock implementation - replace with actual API call
        return Future<CommunityPost, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                promise(.success(post))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func toggleLike(postId: UUID, userId: UUID) -> AnyPublisher<Bool, Error> {
        // Mock implementation - replace with actual API call
        return Future<Bool, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                promise(.success(true))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addComment(postId: UUID, comment: Comment) -> AnyPublisher<Comment, Error> {
        // Mock implementation - replace with actual API call
        return Future<Comment, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                promise(.success(comment))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateChallengeScore(challengeId: UUID, userId: UUID, score: Int) -> AnyPublisher<Bool, Error> {
        // Mock implementation - replace with actual API call
        return Future<Bool, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                promise(.success(true))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func createMockChallenges() -> [Challenge] {
        let userId = UUID()
        
        let challenge1 = Challenge(
            title: "French Banking Translation",
            description: "Translate banking documents from English to French",
            type: .translation,
            language: .french,
            financialSkill: .banking,
            difficulty: .intermediate,
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
            createdBy: userId
        )
        
        let challenge2 = Challenge(
            title: "Spanish Investment Quiz",
            description: "Test your knowledge of investment terms in Spanish",
            type: .quiz,
            language: .spanish,
            financialSkill: .investing,
            difficulty: .beginner,
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
            createdBy: userId
        )
        
        let challenge3 = Challenge(
            title: "German Budget Planning",
            description: "Create a comprehensive budget plan using German financial terminology",
            type: .budgetingTask,
            language: .german,
            financialSkill: .budgeting,
            difficulty: .intermediate,
            startDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
            createdBy: userId
        )
        
        return [challenge1, challenge2, challenge3]
    }
    
    private func createMockLeaderboard() -> [LeaderboardEntry] {
        return [
            LeaderboardEntry(userId: UUID(), userName: "Maria Garcia", score: 950),
            LeaderboardEntry(userId: UUID(), userName: "Jean Dupont", score: 890),
            LeaderboardEntry(userId: UUID(), userName: "Hans Mueller", score: 820),
            LeaderboardEntry(userId: UUID(), userName: "Anna Rossi", score: 780),
            LeaderboardEntry(userId: UUID(), userName: "John Smith", score: 750)
        ]
    }
    
    private func createMockPosts() -> [CommunityPost] {
        let userId1 = UUID()
        let userId2 = UUID()
        let userId3 = UUID()
        
        var post1 = CommunityPost(
            authorId: userId1,
            authorName: "Sarah Johnson",
            content: "Just completed the French Banking course! The vocabulary exercises were really helpful. Does anyone have tips for remembering all the technical terms?",
            type: .achievement
        )
        post1.language = .french
        post1.financialTopic = .banking
        post1.likes = [userId2, userId3]
        
        var post2 = CommunityPost(
            authorId: userId2,
            authorName: "Carlos Rodriguez",
            content: "Can someone help me understand the difference between 'inversión' and 'ahorro' in Spanish financial contexts?",
            type: .question
        )
        post2.language = .spanish
        post2.financialTopic = .investing
        
        var post3 = CommunityPost(
            authorId: userId3,
            authorName: "Emma Thompson",
            content: "Pro tip: When learning German financial vocabulary, try to associate each term with a real-world scenario. It makes memorization much easier!",
            type: .tip
        )
        post3.language = .german
        post3.financialTopic = .personalFinance
        post3.likes = [userId1]
        
        return [post1, post2, post3]
    }
}

