//
//  ProgressView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct UserProgressView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var courseViewModel = CourseViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    headerSection
                    
                    // Overall Progress
                    overallProgressSection
                    
                    // Learning Goals
                    learningGoalsSection
                    
                    // Course Progress
                    courseProgressSection
                    
                    // Achievements
                    achievementsSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.primaryWhite, Color.neomorphLight]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationBarHidden(true)
        }
        .onAppear {
            if let userId = userViewModel.currentUser?.id {
                courseViewModel.loadUserCourses(userId: userId)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("Progress")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.top, 60)
    }
    
    private var overallProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overall Progress")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 16) {
                // Level Progress
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Level \(userViewModel.currentUser?.progress.level ?? 1)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                        
                        Text("\(userViewModel.currentUser?.progress.experiencePoints ?? 0) XP")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    CircularProgressView(
                        progress: Double((userViewModel.currentUser?.progress.experiencePoints ?? 0) % 1000) / 1000.0,
                        lineWidth: 8,
                        color: .accentOrange
                    )
                    .frame(width: 60, height: 60)
                }
                .padding()
                .neomorphismCard()
                
                // Stats Grid
                HStack(spacing: 16) {
                    ProgressStatCard(
                        title: "Lessons",
                        value: "\(userViewModel.currentUser?.progress.totalLessonsCompleted ?? 0)",
                        icon: "book.fill",
                        color: .primaryBlue
                    )
                    
                    ProgressStatCard(
                        title: "Streak",
                        value: "\(userViewModel.currentUser?.progress.currentStreak ?? 0)",
                        icon: "flame.fill",
                        color: .accentOrange
                    )
                    
                    ProgressStatCard(
                        title: "Points",
                        value: "\(userViewModel.currentUser?.progress.totalPoints ?? 0)",
                        icon: "star.fill",
                        color: .yellow
                    )
                }
            }
        }
    }
    
    private var learningGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Learning Goals")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            if let goals = userViewModel.currentUser?.learningGoals, !goals.isEmpty {
                VStack(spacing: 12) {
                    ForEach(goals) { goal in
                        GoalProgressCard(goal: goal)
                    }
                }
            } else {
                Text("No learning goals set")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .neomorphismInset()
            }
        }
    }
    
    private var courseProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Course Progress")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            if !courseViewModel.userCourses.isEmpty {
                VStack(spacing: 12) {
                    ForEach(courseViewModel.userCourses) { course in
                        CourseProgressCard(course: course)
                    }
                }
            } else {
                Text("No courses enrolled")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .neomorphismInset()
            }
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            if let badges = userViewModel.currentUser?.progress.badges, !badges.isEmpty {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(badges) { badge in
                        BadgeCard(badge: badge)
                    }
                }
            } else {
                Text("No achievements yet")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .neomorphismInset()
            }
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    let lineWidth: CGFloat
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
        }
    }
}

struct ProgressStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .neomorphismCard()
    }
}

struct GoalProgressCard: View {
    let goal: LearningGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    Text(goal.description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Text(goal.targetLanguage.flag)
                    .font(.title2)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Progress")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text("\(Int(goal.progress * 100))%")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentOrange)
                }
                
                SwiftUI.ProgressView(value: goal.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .accentOrange))
            }
            
            HStack {
                Text("Target: \(formatDate(goal.targetDate))")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                if goal.isCompleted {
                    Text("Completed")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .neomorphismCard()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct CourseProgressCard: View {
    let course: Course
    
    private var completedLessons: Int {
        course.lessons.filter { $0.isCompleted }.count
    }
    
    private var progress: Double {
        guard !course.lessons.isEmpty else { return 0 }
        return Double(completedLessons) / Double(course.lessons.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(course.language.flag)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(course.financialSkill.displayName)
                        .font(.caption)
                        .foregroundColor(.accentOrange)
                }
                
                Spacer()
                
                CircularProgressView(
                    progress: progress,
                    lineWidth: 4,
                    color: .accentOrange
                )
                .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(completedLessons)/\(course.lessons.count) lessons")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))% complete")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentOrange)
                }
                
                SwiftUI.ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .accentOrange))
            }
        }
        .padding()
        .neomorphismCard()
    }
}

struct BadgeCard: View {
    let badge: Badge
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: badge.iconName)
                .font(.title)
                .foregroundColor(.accentOrange)
            
            Text(badge.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(formatDate(badge.earnedDate))
                .font(.caption2)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .neomorphismCard()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    UserProgressView()
        .environmentObject(UserViewModel())
}
