//
//  CourseModel.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import Foundation

struct Course: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var language: Language
    var financialSkill: FinancialSkill
    var difficulty: DifficultyLevel
    var estimatedDuration: TimeInterval // in seconds
    var lessons: [Lesson]
    var thumbnailURL: String?
    var isPopular: Bool = false
    var rating: Double = 0.0
    var enrolledCount: Int = 0
    var createdAt: Date
    var updatedAt: Date
    
    init(title: String, description: String, language: Language, financialSkill: FinancialSkill, difficulty: DifficultyLevel) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.language = language
        self.financialSkill = financialSkill
        self.difficulty = difficulty
        self.estimatedDuration = 0
        self.lessons = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

struct Lesson: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var type: LessonType
    var financialScenario: FinancialScenario?
    var exercises: [Exercise]
    var duration: TimeInterval // in seconds
    var order: Int
    var isCompleted: Bool = false
    var completedAt: Date?
    
    init(title: String, content: String, type: LessonType, order: Int) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.type = type
        self.exercises = []
        self.duration = 0
        self.order = order
    }
}

struct Exercise: Identifiable, Codable {
    let id: UUID
    var question: String
    var type: ExerciseType
    var options: [String] // For multiple choice
    var correctAnswer: String
    var explanation: String
    var points: Int = 10
    var isCompleted: Bool = false
    
    init(question: String, type: ExerciseType, correctAnswer: String, explanation: String) {
        self.id = UUID()
        self.question = question
        self.type = type
        self.options = []
        self.correctAnswer = correctAnswer
        self.explanation = explanation
    }
}

struct FinancialScenario: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var context: String // Real-world financial context
    var vocabulary: [FinancialTerm]
    var caseStudy: String?
    
    init(title: String, description: String, context: String) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.context = context
        self.vocabulary = []
    }
}

struct FinancialTerm: Identifiable, Codable {
    let id: UUID
    var term: String
    var translation: String
    var definition: String
    var example: String
    var language: Language
    
    init(term: String, translation: String, definition: String, example: String, language: Language) {
        self.id = UUID()
        self.term = term
        self.translation = translation
        self.definition = definition
        self.example = example
        self.language = language
    }
}

enum Language: String, CaseIterable, Codable {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case italian = "it"
    case portuguese = "pt"
    case russian = "ru"
    case chinese = "zh"
    case japanese = "ja"
    case korean = "ko"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .italian: return "Italiano"
        case .portuguese: return "Português"
        case .russian: return "Русский"
        case .chinese: return "中文"
        case .japanese: return "日本語"
        case .korean: return "한국어"
        }
    }
    
    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .spanish: return "🇪🇸"
        case .french: return "🇫🇷"
        case .german: return "🇩🇪"
        case .italian: return "🇮🇹"
        case .portuguese: return "🇵🇹"
        case .russian: return "🇷🇺"
        case .chinese: return "🇨🇳"
        case .japanese: return "🇯🇵"
        case .korean: return "🇰🇷"
        }
    }
}

enum FinancialSkill: String, CaseIterable, Codable {
    case budgeting = "budgeting"
    case investing = "investing"
    case banking = "banking"
    case insurance = "insurance"
    case taxes = "taxes"
    case retirement = "retirement"
    case realEstate = "real_estate"
    case cryptocurrency = "cryptocurrency"
    case businessFinance = "business_finance"
    case personalFinance = "personal_finance"
    
    var displayName: String {
        switch self {
        case .budgeting: return "Budgeting"
        case .investing: return "Investing"
        case .banking: return "Banking"
        case .insurance: return "Insurance"
        case .taxes: return "Taxes"
        case .retirement: return "Retirement Planning"
        case .realEstate: return "Real Estate"
        case .cryptocurrency: return "Cryptocurrency"
        case .businessFinance: return "Business Finance"
        case .personalFinance: return "Personal Finance"
        }
    }
    
    var icon: String {
        switch self {
        case .budgeting: return "chart.pie.fill"
        case .investing: return "chart.line.uptrend.xyaxis"
        case .banking: return "building.columns.fill"
        case .insurance: return "shield.fill"
        case .taxes: return "doc.text.fill"
        case .retirement: return "clock.fill"
        case .realEstate: return "house.fill"
        case .cryptocurrency: return "bitcoinsign.circle.fill"
        case .businessFinance: return "briefcase.fill"
        case .personalFinance: return "person.crop.circle.fill"
        }
    }
}

enum DifficultyLevel: String, CaseIterable, Codable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    case expert = "expert"
    
    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        case .expert: return "Expert"
        }
    }
    
    var color: String {
        switch self {
        case .beginner: return "green"
        case .intermediate: return "yellow"
        case .advanced: return "orange"
        case .expert: return "red"
        }
    }
}

enum LessonType: String, CaseIterable, Codable {
    case vocabulary = "vocabulary"
    case grammar = "grammar"
    case conversation = "conversation"
    case reading = "reading"
    case listening = "listening"
    case financialCase = "financial_case"
    case quiz = "quiz"
    
    var displayName: String {
        switch self {
        case .vocabulary: return "Vocabulary"
        case .grammar: return "Grammar"
        case .conversation: return "Conversation"
        case .reading: return "Reading"
        case .listening: return "Listening"
        case .financialCase: return "Financial Case Study"
        case .quiz: return "Quiz"
        }
    }
}

enum ExerciseType: String, CaseIterable, Codable {
    case multipleChoice = "multiple_choice"
    case fillInBlank = "fill_in_blank"
    case translation = "translation"
    case matching = "matching"
    case dragAndDrop = "drag_and_drop"
    case speaking = "speaking"
    case listening = "listening"
}
