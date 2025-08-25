//
//  CoursesView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct CoursesView: View {
    @StateObject private var courseViewModel = CourseViewModel()
    @State private var selectedLanguage: Language?
    @State private var selectedSkill: FinancialSkill?
    @State private var selectedDifficulty: DifficultyLevel?
    @State private var showFilters = false
    @State private var selectedCourse: Course?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Search and Filters
                searchAndFiltersSection
                
                // Course List
                courseListSection
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
        .sheet(isPresented: $showFilters) {
            FiltersView(
                selectedLanguage: $selectedLanguage,
                selectedSkill: $selectedSkill,
                selectedDifficulty: $selectedDifficulty
            ) {
                courseViewModel.filterCourses(
                    by: selectedLanguage,
                    skill: selectedSkill,
                    difficulty: selectedDifficulty
                )
            }
        }
        .sheet(item: $selectedCourse) { course in
            CourseDetailView(course: course)
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("Courses")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .padding(.bottom, 20)
    }
    
    private var searchAndFiltersSection: some View {
        HStack(spacing: 12) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                
                TextField("Search courses...", text: $courseViewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .neomorphismInset()
            
            // Filter Button
            Button(action: {
                showFilters = true
            }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundColor(.textSecondary)
                    .neomorphismCard(cornerRadius: 12, shadowRadius: 4)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    private var courseListSection: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(courseViewModel.searchResults.isEmpty ? courseViewModel.courses : courseViewModel.searchResults) { course in
                    CourseListCard(course: course) {
                        selectedCourse = course
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

struct CourseListCard: View {
    let course: Course
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    // Language Flag
                    Text(course.language.flag)
                        .font(.title)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(course.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.leading)
                        
                        Text(course.description)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                
                // Course Info
                HStack {
                    // Financial Skill Tag
                    Text(course.financialSkill.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.accentOrange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentOrange.opacity(0.1))
                        .cornerRadius(8)
                    
                    // Difficulty Tag
                    Text(course.difficulty.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(difficultyColor(course.difficulty))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    // Rating and Students
                    VStack(alignment: .trailing, spacing: 2) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", course.rating))
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.textPrimary)
                        }
                        
                        Text("\(course.enrolledCount) students")
                            .font(.caption2)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                // Duration
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text(formatDuration(course.estimatedDuration))
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text("\(course.lessons.count) lessons")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding()
            .neomorphismCard()
        }
        .buttonStyle(PlainButtonStyle())
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
}

struct FiltersView: View {
    @Binding var selectedLanguage: Language?
    @Binding var selectedSkill: FinancialSkill?
    @Binding var selectedDifficulty: DifficultyLevel?
    let applyFilters: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Language Filter
                    filterSection(
                        title: "Language",
                        items: Language.allCases,
                        selectedItem: selectedLanguage,
                        onSelect: { selectedLanguage = $0 }
                    ) { language in
                        HStack {
                            Text(language.flag)
                            Text(language.displayName)
                                .foregroundColor(.textPrimary)
                        }
                    }
                    
                    // Financial Skill Filter
                    filterSection(
                        title: "Financial Skill",
                        items: FinancialSkill.allCases,
                        selectedItem: selectedSkill,
                        onSelect: { selectedSkill = $0 }
                    ) { skill in
                        HStack {
                            Image(systemName: skill.icon)
                                .foregroundColor(.accentOrange)
                            Text(skill.displayName)
                                .foregroundColor(.textPrimary)
                        }
                    }
                    
                    // Difficulty Filter
                    filterSection(
                        title: "Difficulty",
                        items: DifficultyLevel.allCases,
                        selectedItem: selectedDifficulty,
                        onSelect: { selectedDifficulty = $0 }
                    ) { difficulty in
                        Text(difficulty.displayName)
                            .foregroundColor(.textPrimary)
                    }
                }
                .padding(20)
            }
            .background(Color.neomorphLight.ignoresSafeArea())
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Clear") {
                    selectedLanguage = nil
                    selectedSkill = nil
                    selectedDifficulty = nil
                },
                trailing: Button("Apply") {
                    applyFilters()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func filterSection<T: Hashable>(
        title: String,
        items: [T],
        selectedItem: T?,
        onSelect: @escaping (T?) -> Void,
        @ViewBuilder content: @escaping (T) -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        if selectedItem == item {
                            onSelect(nil)
                        } else {
                            onSelect(item)
                        }
                    }) {
                        content(item)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedItem == item ? Color.accentOrange.opacity(0.1) : Color.neomorphLight)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedItem == item ? Color.accentOrange : Color.clear, lineWidth: 2)
                            )
                            .neomorphismCard(cornerRadius: 12, shadowRadius: 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

#Preview {
    CoursesView()
}
