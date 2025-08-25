//
//  HomeView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var courseViewModel = CourseViewModel()
    @StateObject private var communityViewModel = CommunityViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var selectedCourse: Course?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Quick Stats
                    quickStatsSection
                    
                    // Continue Learning
                    if !courseViewModel.userCourses.isEmpty {
                        continueLearningSectionView
                    }
                    
                    // Popular Courses
                    popularCoursesSection
                    
                    // Active Challenges
                    activeChallengesSection
                    
                    // Daily Goal
                    dailyGoalSection
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
                communityViewModel.loadUserChallenges(userId: userId)
            }
        }
        .sheet(item: $selectedCourse) { course in
            CourseDetailView(course: course)
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello, \(userViewModel.currentUser?.name ?? "Learner")!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text("Ready to learn today?")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Button(action: {
                // Handle notifications
            }) {
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundColor(.textSecondary)
                    .neomorphismCard(cornerRadius: 20, shadowRadius: 4)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.top, 60)
    }
    
    private var quickStatsSection: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Streak",
                value: "\(userViewModel.currentUser?.progress.currentStreak ?? 0)",
                icon: "flame.fill",
                color: .accentOrange
            )
            
            StatCard(
                title: "Level",
                value: "\(userViewModel.currentUser?.progress.level ?? 1)",
                icon: "star.fill",
                color: .primaryBlue
            )
            
            StatCard(
                title: "Points",
                value: "\(userViewModel.currentUser?.progress.totalPoints ?? 0)",
                icon: "trophy.fill",
                color: .accentOrange
            )
        }
    }
    
    private var continueLearningSectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Continue Learning")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button(action: {
                    // Navigate to courses
                }) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.accentOrange)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(courseViewModel.userCourses) { course in
                        ContinueCourseCard(course: course) {
                            selectedCourse = course
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var popularCoursesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Popular Courses")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button(action: {
                    // Navigate to courses
                }) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.accentOrange)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(courseViewModel.popularCourses) { course in
                        CourseCard(course: course) {
                            selectedCourse = course
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var activeChallengesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Active Challenges")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button(action: {
                    // Navigate to community
                }) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.accentOrange)
                }
            }
            
            if communityViewModel.activeChallenges.isEmpty {
                Text("No active challenges")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .neomorphismInset()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(communityViewModel.activeChallenges.prefix(3)) { challenge in
                            ChallengeCard(challenge: challenge) {
                                // Handle challenge tap
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
    }
    
    private var dailyGoalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Goal")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            DailyGoalCard(
                goal: "Complete 2 lessons",
                progress: 0.6,
                completed: 1,
                total: 2
            )
        }
    }
}

struct StatCard: View {
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
                .font(.title3)
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

struct ContinueCourseCard: View {
    let course: Course
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(course.language.flag)
                        .font(.title2)
                    
                    Spacer()
                    
                    Image(systemName: course.financialSkill.icon)
                        .font(.subheadline)
                        .foregroundColor(.accentOrange)
                }
                
                Text(course.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                
                SwiftUI.ProgressView(value: 0.3) // Mock progress
                    .progressViewStyle(LinearProgressViewStyle(tint: .accentOrange))
                
                Text("30% Complete")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding()
            .frame(width: 200)
            .neomorphismCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CourseCard: View {
    let course: Course
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(course.language.flag)
                        .font(.title2)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", course.rating))
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Text("\(course.enrolledCount) students")
                            .font(.caption2)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Text(course.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Text(course.financialSkill.displayName)
                    .font(.caption)
                    .foregroundColor(.accentOrange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.accentOrange.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding()
            .frame(width: 200)
            .neomorphismCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ChallengeCard: View {
    let challenge: Challenge
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: challenge.type.icon)
                        .font(.title2)
                        .foregroundColor(.accentOrange)
                    
                    Spacer()
                    
                    Text(challenge.language.flag)
                        .font(.title2)
                }
                
                Text(challenge.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Text("\(challenge.participants.count) participants")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                Text("Ends in 3 days")
                    .font(.caption)
                    .foregroundColor(.accentOrange)
            }
            .padding()
            .frame(width: 180)
            .neomorphismCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DailyGoalCard: View {
    let goal: String
    let progress: Double
    let completed: Int
    let total: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(goal)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(completed)/\(total)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentOrange)
            }
            
            SwiftUI.ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .accentOrange))
            
            Text("\(Int(progress * 100))% Complete")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding()
        .neomorphismCard()
    }
}

#Preview {
    HomeView()
        .environmentObject(UserViewModel())
}
