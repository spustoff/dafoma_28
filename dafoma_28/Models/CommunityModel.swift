//
//  CommunityModel.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import Foundation

struct Challenge: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var type: ChallengeType
    var language: Language
    var financialSkill: FinancialSkill
    var difficulty: DifficultyLevel
    var startDate: Date
    var endDate: Date
    var maxParticipants: Int?
    var participants: [UUID] // User IDs
    var leaderboard: [LeaderboardEntry]
    var rewards: [Reward]
    var isActive: Bool
    var createdBy: UUID // User ID
    var createdAt: Date
    
    init(title: String, description: String, type: ChallengeType, language: Language, financialSkill: FinancialSkill, difficulty: DifficultyLevel, startDate: Date, endDate: Date, createdBy: UUID) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.type = type
        self.language = language
        self.financialSkill = financialSkill
        self.difficulty = difficulty
        self.startDate = startDate
        self.endDate = endDate
        self.participants = []
        self.leaderboard = []
        self.rewards = []
        self.isActive = Date() >= startDate && Date() <= endDate
        self.createdBy = createdBy
        self.createdAt = Date()
    }
}

struct LeaderboardEntry: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var userName: String
    var score: Int
    var rank: Int
    var completedTasks: Int
    var timeSpent: TimeInterval
    var lastUpdated: Date
    
    init(userId: UUID, userName: String, score: Int) {
        self.id = UUID()
        self.userId = userId
        self.userName = userName
        self.score = score
        self.rank = 0
        self.completedTasks = 0
        self.timeSpent = 0
        self.lastUpdated = Date()
    }
}

struct Reward: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var type: RewardType
    var value: Int // Points, badges, etc.
    var iconName: String
    var requirement: String // What needs to be achieved
    var isUnlocked: Bool = false
    
    init(title: String, description: String, type: RewardType, value: Int, iconName: String, requirement: String) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.type = type
        self.value = value
        self.iconName = iconName
        self.requirement = requirement
    }
}

struct CommunityPost: Identifiable, Codable {
    let id: UUID
    var authorId: UUID
    var authorName: String
    var content: String
    var type: PostType
    var language: Language?
    var financialTopic: FinancialSkill?
    var attachments: [PostAttachment]
    var likes: [UUID] // User IDs who liked
    var comments: [Comment]
    var isReported: Bool = false
    var createdAt: Date
    var updatedAt: Date
    
    init(authorId: UUID, authorName: String, content: String, type: PostType) {
        self.id = UUID()
        self.authorId = authorId
        self.authorName = authorName
        self.content = content
        self.type = type
        self.attachments = []
        self.likes = []
        self.comments = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

struct Comment: Identifiable, Codable {
    let id: UUID
    var authorId: UUID
    var authorName: String
    var content: String
    var likes: [UUID] // User IDs who liked
    var replies: [Comment]
    var createdAt: Date
    
    init(authorId: UUID, authorName: String, content: String) {
        self.id = UUID()
        self.authorId = authorId
        self.authorName = authorName
        self.content = content
        self.likes = []
        self.replies = []
        self.createdAt = Date()
    }
}

struct PostAttachment: Identifiable, Codable {
    let id: UUID
    var type: AttachmentType
    var url: String
    var fileName: String?
    var fileSize: Int? // in bytes
    
    init(type: AttachmentType, url: String, fileName: String? = nil) {
        self.id = UUID()
        self.type = type
        self.url = url
        self.fileName = fileName
    }
}

enum ChallengeType: String, CaseIterable, Codable {
    case translation = "translation"
    case quiz = "quiz"
    case financialReport = "financial_report"
    case vocabulary = "vocabulary"
    case conversation = "conversation"
    case budgetingTask = "budgeting_task"
    case investmentSimulation = "investment_simulation"
    
    var displayName: String {
        switch self {
        case .translation: return "Translation Challenge"
        case .quiz: return "Financial Quiz"
        case .financialReport: return "Financial Report Analysis"
        case .vocabulary: return "Vocabulary Building"
        case .conversation: return "Conversation Practice"
        case .budgetingTask: return "Budgeting Task"
        case .investmentSimulation: return "Investment Simulation"
        }
    }
    
    var icon: String {
        switch self {
        case .translation: return "textformat.abc"
        case .quiz: return "questionmark.circle.fill"
        case .financialReport: return "doc.text.magnifyingglass"
        case .vocabulary: return "book.fill"
        case .conversation: return "bubble.left.and.bubble.right.fill"
        case .budgetingTask: return "chart.pie.fill"
        case .investmentSimulation: return "chart.line.uptrend.xyaxis"
        }
    }
}

enum RewardType: String, CaseIterable, Codable {
    case points = "points"
    case badge = "badge"
    case certificate = "certificate"
    case unlockContent = "unlock_content"
    
    var displayName: String {
        switch self {
        case .points: return "Points"
        case .badge: return "Badge"
        case .certificate: return "Certificate"
        case .unlockContent: return "Unlock Content"
        }
    }
}

enum PostType: String, CaseIterable, Codable {
    case question = "question"
    case tip = "tip"
    case achievement = "achievement"
    case discussion = "discussion"
    case translation = "translation"
    case financialNews = "financial_news"
    
    var displayName: String {
        switch self {
        case .question: return "Question"
        case .tip: return "Learning Tip"
        case .achievement: return "Achievement"
        case .discussion: return "Discussion"
        case .translation: return "Translation Help"
        case .financialNews: return "Financial News"
        }
    }
    
    var icon: String {
        switch self {
        case .question: return "questionmark.circle"
        case .tip: return "lightbulb.fill"
        case .achievement: return "trophy.fill"
        case .discussion: return "bubble.left.and.bubble.right"
        case .translation: return "textformat.abc"
        case .financialNews: return "newspaper.fill"
        }
    }
}

enum AttachmentType: String, CaseIterable, Codable {
    case image = "image"
    case document = "document"
    case audio = "audio"
    case video = "video"
    case link = "link"
}
