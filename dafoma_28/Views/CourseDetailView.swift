//
//  CourseDetailView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct CourseDetailView: View {
    let course: Course
    @StateObject private var courseViewModel = CourseViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showLessonDetail = false
    @State private var selectedLesson: Lesson?
    @State private var isEnrolled = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    headerSection
                    
                    // Course Info
                    courseInfoSection
                    
                    // Description
                    descriptionSection
                    
                    // Lessons
                    lessonsSection
                    
                    // Enroll Button
                    if !isEnrolled {
                        enrollButtonSection
                    }
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
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.textSecondary)
                }
            )
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showLessonDetail) {
            if let lesson = selectedLesson {
                LessonDetailView(lesson: lesson, course: course)
            }
        }
        .onAppear {
            checkEnrollmentStatus()
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(course.language.flag)
                    .font(.system(size: 40))
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.subheadline)
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", course.rating))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                    }
                    
                    Text("\(course.enrolledCount) students")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Text(course.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            HStack {
                Text(course.financialSkill.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.accentOrange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentOrange.opacity(0.1))
                    .cornerRadius(12)
                
                Text(course.difficulty.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(difficultyColor(course.difficulty))
                    .cornerRadius(12)
                
                Spacer()
            }
        }
        .padding(.top, 20)
    }
    
    private var courseInfoSection: some View {
        HStack(spacing: 24) {
            InfoItem(
                icon: "clock",
                title: "Duration",
                value: formatDuration(course.estimatedDuration)
            )
            
            InfoItem(
                icon: "book",
                title: "Lessons",
                value: "\(course.lessons.count)"
            )
            
            InfoItem(
                icon: "chart.line.uptrend.xyaxis",
                title: "Level",
                value: course.difficulty.displayName
            )
        }
        .neomorphismCard()
        .padding(.vertical, 16)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About This Course")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(course.description)
                .font(.body)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
    }
    
    private var lessonsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Lessons")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(course.lessons.sorted(by: { $0.order < $1.order })) { lesson in
                    LessonRow(
                        lesson: lesson,
                        isEnrolled: isEnrolled
                    ) {
                        if isEnrolled {
                            selectedLesson = lesson
                            showLessonDetail = true
                        }
                    }
                }
            }
        }
    }
    
    private var enrollButtonSection: some View {
        Button(action: enrollInCourse) {
            HStack {
                if courseViewModel.isLoading {
                                                        SwiftUI.ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                } else {
                    Text("Enroll in Course")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.textOnAccent)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentOrange)
            .cornerRadius(15)
        }
        .buttonStyle(NeomorphismButtonStyle())
        .disabled(courseViewModel.isLoading)
    }
    
    private func difficultyColor(_ difficulty: DifficultyLevel) -> Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        case .expert: return .purple
        }
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func checkEnrollmentStatus() {
        // Check if user is enrolled in this course
        isEnrolled = courseViewModel.userCourses.contains { $0.id == course.id }
    }
    
    private func enrollInCourse() {
        guard let userId = userViewModel.currentUser?.id else { return }
        courseViewModel.enrollInCourse(course, userId: userId)
        isEnrolled = true
    }
}

struct InfoItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentOrange)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct LessonRow: View {
    let lesson: Lesson
    let isEnrolled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Lesson Number
                Text("\(lesson.order)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(lesson.isCompleted ? .white : .accentOrange)
                    .frame(width: 32, height: 32)
                    .background(lesson.isCompleted ? Color.accentOrange : Color.accentOrange.opacity(0.1))
                    .clipShape(Circle())
                
                // Lesson Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(lesson.type.displayName)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                        
                        if lesson.duration > 0 {
                            Text(formatLessonDuration(lesson.duration))
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
                Spacer()
                
                // Status Icon
                if lesson.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else if isEnrolled {
                    Image(systemName: "play.circle")
                        .foregroundColor(.accentOrange)
                } else {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .neomorphismCard()
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnrolled)
    }
    
    private func formatLessonDuration(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        return "\(minutes) min"
    }
}

#Preview {
    CourseDetailView(course: Course(
        title: "French Banking Essentials",
        description: "Learn essential French vocabulary and phrases for banking and financial services.",
        language: .french,
        financialSkill: .banking,
        difficulty: .beginner
    ))
    .environmentObject(UserViewModel())
}
