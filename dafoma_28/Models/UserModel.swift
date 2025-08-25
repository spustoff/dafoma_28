//
//  UserModel.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var email: String
    var name: String
    var profileImageURL: String?
    var selectedLanguages: [Language]
    var learningGoals: [LearningGoal]
    var progress: UserProgress
    var joinedChallenges: [UUID] // Challenge IDs
    var completedCourses: [UUID] // Course IDs
    var createdAt: Date
    var lastActiveAt: Date
    
    init(email: String, name: String) {
        self.id = UUID()
        self.email = email
        self.name = name
        self.selectedLanguages = []
        self.learningGoals = []
        self.progress = UserProgress()
        self.joinedChallenges = []
        self.completedCourses = []
        self.createdAt = Date()
        self.lastActiveAt = Date()
    }
}

struct UserProgress: Codable {
    var totalLessonsCompleted: Int = 0
    var totalTimeSpent: TimeInterval = 0 // in seconds
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var totalPoints: Int = 0
    var level: Int = 1
    var experiencePoints: Int = 0
    var badges: [Badge] = []
}

struct LearningGoal: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var targetLanguage: Language
    var targetSkill: FinancialSkill
    var targetDate: Date
    var isCompleted: Bool = false
    var progress: Double = 0.0 // 0.0 to 1.0
    
    init(title: String, description: String, targetLanguage: Language, targetSkill: FinancialSkill, targetDate: Date) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.targetLanguage = targetLanguage
        self.targetSkill = targetSkill
        self.targetDate = targetDate
    }
}

struct Badge: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var iconName: String
    var earnedDate: Date
    var category: BadgeCategory
    
    enum BadgeCategory: String, CaseIterable, Codable {
        case streak = "streak"
        case completion = "completion"
        case community = "community"
        case financial = "financial"
        case language = "language"
    }
}
