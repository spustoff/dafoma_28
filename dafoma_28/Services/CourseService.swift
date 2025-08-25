//
//  CourseService.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import Foundation
import Combine

class CourseService {
    private let baseURL = "https://api.eduwise.com" // Replace with actual API URL
    
    func getAllCourses() -> AnyPublisher<[Course], Error> {
        // Mock implementation - replace with actual API call
        return Future<[Course], Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let courses = self.createMockCourses()
                promise(.success(courses))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getUserCourses(userId: UUID) -> AnyPublisher<[Course], Error> {
        // Mock implementation - replace with actual API call
        return Future<[Course], Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let courses = Array(self.createMockCourses().prefix(2))
                promise(.success(courses))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func enrollInCourse(courseId: UUID, userId: UUID) -> AnyPublisher<Bool, Error> {
        // Mock implementation - replace with actual API call
        return Future<Bool, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                promise(.success(true))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateLessonProgress(lessonId: UUID, userId: UUID, isCompleted: Bool) -> AnyPublisher<Bool, Error> {
        // Mock implementation - replace with actual API call
        return Future<Bool, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                promise(.success(true))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func createMockCourses() -> [Course] {
        var courses: [Course] = []
        
        // French Banking Course
        var frenchBanking = Course(
            title: "French Banking Essentials",
            description: "Learn essential French vocabulary and phrases for banking and financial services.",
            language: .french,
            financialSkill: .banking,
            difficulty: .beginner
        )
        frenchBanking.isPopular = true
        frenchBanking.rating = 4.8
        frenchBanking.enrolledCount = 1250
        frenchBanking.estimatedDuration = 3600 // 1 hour
        
        // Add lessons
        frenchBanking.lessons = [
            Lesson(title: "Basic Banking Terms", content: "Learn fundamental banking vocabulary in French.", type: .vocabulary, order: 1),
            Lesson(title: "Opening a Bank Account", content: "Practice conversations for opening a bank account.", type: .conversation, order: 2),
            Lesson(title: "Banking Documents", content: "Understanding French banking documents and forms.", type: .reading, order: 3)
        ]
        
        // Spanish Investment Course
        var spanishInvesting = Course(
            title: "Spanish Investment Fundamentals",
            description: "Master investment terminology and concepts in Spanish.",
            language: .spanish,
            financialSkill: .investing,
            difficulty: .intermediate
        )
        spanishInvesting.isPopular = true
        spanishInvesting.rating = 4.6
        spanishInvesting.enrolledCount = 890
        spanishInvesting.estimatedDuration = 5400 // 1.5 hours
        
        spanishInvesting.lessons = [
            Lesson(title: "Investment Vocabulary", content: "Essential investment terms in Spanish.", type: .vocabulary, order: 1),
            Lesson(title: "Stock Market Basics", content: "Understanding the stock market in Spanish-speaking countries.", type: .financialCase, order: 2),
            Lesson(title: "Portfolio Management", content: "Learn to discuss portfolio strategies in Spanish.", type: .conversation, order: 3)
        ]
        
        // German Budgeting Course
        var germanBudgeting = Course(
            title: "German Personal Finance",
            description: "Learn personal finance and budgeting concepts in German.",
            language: .german,
            financialSkill: .budgeting,
            difficulty: .beginner
        )
        germanBudgeting.rating = 4.7
        germanBudgeting.enrolledCount = 650
        germanBudgeting.estimatedDuration = 2700 // 45 minutes
        
        germanBudgeting.lessons = [
            Lesson(title: "Budgeting Basics", content: "Learn budgeting vocabulary in German.", type: .vocabulary, order: 1),
            Lesson(title: "Monthly Budget Planning", content: "Create a monthly budget using German financial terms.", type: .financialCase, order: 2)
        ]
        
        // English Cryptocurrency Course
        var englishCrypto = Course(
            title: "Cryptocurrency in English",
            description: "Advanced cryptocurrency and blockchain terminology in English.",
            language: .english,
            financialSkill: .cryptocurrency,
            difficulty: .advanced
        )
        englishCrypto.rating = 4.5
        englishCrypto.enrolledCount = 420
        englishCrypto.estimatedDuration = 7200 // 2 hours
        
        englishCrypto.lessons = [
            Lesson(title: "Blockchain Fundamentals", content: "Understanding blockchain technology terminology.", type: .vocabulary, order: 1),
            Lesson(title: "Trading Strategies", content: "Learn advanced trading vocabulary and strategies.", type: .financialCase, order: 2),
            Lesson(title: "DeFi Protocols", content: "Decentralized Finance terminology and concepts.", type: .reading, order: 3)
        ]
        
        courses = [frenchBanking, spanishInvesting, germanBudgeting, englishCrypto]
        
        return courses
    }
}
