//
//  LessonDetailView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct LessonDetailView: View {
    let lesson: Lesson
    let course: Course
    @StateObject private var courseViewModel = CourseViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var currentExerciseIndex = 0
    @State private var selectedAnswer = ""
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var score = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Progress Bar
                progressBarSection
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Lesson Content
                        lessonContentSection
                        
                        // Exercises
                        if !lesson.exercises.isEmpty {
                            exerciseSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
                
                // Bottom Action
                bottomActionSection
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
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(course.language.flag)
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text(lesson.type.displayName)
                        .font(.subheadline)
                        .foregroundColor(.accentOrange)
                }
                
                Spacer()
                
                if lesson.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var progressBarSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Lesson \(lesson.order)")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                if !lesson.exercises.isEmpty {
                    Text("\(currentExerciseIndex + 1)/\(lesson.exercises.count)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            SwiftUI.ProgressView(value: progressValue)
                .progressViewStyle(LinearProgressViewStyle(tint: .accentOrange))
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var lessonContentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Lesson Content")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(lesson.content)
                .font(.body)
                .foregroundColor(.textPrimary)
                .lineSpacing(6)
                .padding()
                .neomorphismCard()
            
            // Financial Scenario
            if let scenario = lesson.financialScenario {
                financialScenarioSection(scenario)
            }
        }
    }
    
    private var exerciseSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Exercise")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            if currentExerciseIndex < lesson.exercises.count {
                let exercise = lesson.exercises[currentExerciseIndex]
                exerciseCard(exercise)
            }
        }
    }
    
    private var bottomActionSection: some View {
        VStack(spacing: 16) {
            if showResult {
                resultSection
            }
            
            Button(action: handleBottomAction) {
                Text(bottomActionTitle)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textOnAccent)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(bottomActionColor)
                    .cornerRadius(15)
            }
            .buttonStyle(NeomorphismButtonStyle())
            .disabled(!canProceed)
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
        }
    }
    
    private func financialScenarioSection(_ scenario: FinancialScenario) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Financial Scenario")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(scenario.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentOrange)
                
                Text(scenario.description)
                    .font(.body)
                    .foregroundColor(.textPrimary)
                
                Text(scenario.context)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .italic()
                
                if !scenario.vocabulary.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Key Terms:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        ForEach(scenario.vocabulary) { term in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(term.term)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.accentOrange)
                                    
                                    Text("→")
                                        .foregroundColor(.textSecondary)
                                    
                                    Text(term.translation)
                                        .font(.subheadline)
                                        .foregroundColor(.textPrimary)
                                }
                                
                                Text(term.definition)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                                
                                if !term.example.isEmpty {
                                    Text("Example: \(term.example)")
                                        .font(.caption)
                                        .foregroundColor(.textSecondary)
                                        .italic()
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .padding()
            .neomorphismCard()
        }
    }
    
    private func exerciseCard(_ exercise: Exercise) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(exercise.question)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.textPrimary)
            
            switch exercise.type {
            case .multipleChoice:
                multipleChoiceOptions(exercise)
            case .fillInBlank:
                fillInBlankField(exercise)
            case .translation:
                translationField(exercise)
            default:
                Text("Exercise type not implemented")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding()
        .neomorphismCard()
    }
    
    private func multipleChoiceOptions(_ exercise: Exercise) -> some View {
        VStack(spacing: 12) {
            ForEach(exercise.options, id: \.self) { option in
                Button(action: {
                    selectedAnswer = option
                }) {
                    HStack {
                        Text(option)
                            .font(.subheadline)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        if selectedAnswer == option {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentOrange)
                        } else {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .padding()
                    .background(selectedAnswer == option ? Color.accentOrange.opacity(0.1) : Color.neomorphLight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedAnswer == option ? Color.accentOrange : Color.clear, lineWidth: 2)
                    )
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func fillInBlankField(_ exercise: Exercise) -> some View {
        TextField("Type your answer here...", text: $selectedAnswer)
            .textFieldStyle(NeomorphismTextFieldStyle())
    }
    
    private func translationField(_ exercise: Exercise) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Translate to \(course.language.displayName):")
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            TextField("Enter translation...", text: $selectedAnswer)
                .textFieldStyle(NeomorphismTextFieldStyle())
        }
    }
    
    private var resultSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(isCorrect ? .green : .red)
                
                Text(isCorrect ? "Correct!" : "Incorrect")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(isCorrect ? .green : .red)
                
                Spacer()
            }
            
            if !isCorrect && currentExerciseIndex < lesson.exercises.count {
                let exercise = lesson.exercises[currentExerciseIndex]
                VStack(alignment: .leading, spacing: 8) {
                    Text("Correct answer:")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text(exercise.correctAnswer)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    if !exercise.explanation.isEmpty {
                        Text(exercise.explanation)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
        .padding()
        .neomorphismInset()
        .padding(.horizontal, 20)
    }
    
    private var progressValue: Double {
        if lesson.exercises.isEmpty {
            return 1.0
        }
        return Double(currentExerciseIndex + 1) / Double(lesson.exercises.count)
    }
    
    private var canProceed: Bool {
        if lesson.exercises.isEmpty {
            return true
        }
        
        if showResult {
            return true
        }
        
        return !selectedAnswer.isEmpty
    }
    
    private var bottomActionTitle: String {
        if lesson.exercises.isEmpty {
            return "Complete Lesson"
        }
        
        if showResult {
            if currentExerciseIndex < lesson.exercises.count - 1 {
                return "Next Exercise"
            } else {
                return "Complete Lesson"
            }
        }
        
        return "Check Answer"
    }
    
    private var bottomActionColor: Color {
        if showResult && isCorrect {
            return .green
        } else if showResult && !isCorrect {
            return .red
        }
        return canProceed ? .accentOrange : .gray
    }
    
    private func handleBottomAction() {
        if lesson.exercises.isEmpty {
            completeLesson()
            return
        }
        
        if showResult {
            if currentExerciseIndex < lesson.exercises.count - 1 {
                // Next exercise
                currentExerciseIndex += 1
                selectedAnswer = ""
                showResult = false
            } else {
                // Complete lesson
                completeLesson()
            }
        } else {
            // Check answer
            checkAnswer()
        }
    }
    
    private func checkAnswer() {
        let exercise = lesson.exercises[currentExerciseIndex]
        isCorrect = selectedAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ==
                   exercise.correctAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isCorrect {
            score += exercise.points
        }
        
        showResult = true
    }
    
    private func completeLesson() {
        guard let userId = userViewModel.currentUser?.id else { return }
        
        // Update lesson completion
        courseViewModel.completeLesson(lesson, in: course, userId: userId)
        
        // Update user progress
        let timeSpent = lesson.duration > 0 ? lesson.duration : 300 // Default 5 minutes
        userViewModel.updateProgress(
            lessonsCompleted: 1,
            timeSpent: timeSpent,
            points: score
        )
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    LessonDetailView(
        lesson: Lesson(
            title: "Basic Banking Terms",
            content: "Learn fundamental banking vocabulary in French.",
            type: .vocabulary,
            order: 1
        ),
        course: Course(
            title: "French Banking Essentials",
            description: "Learn essential French vocabulary and phrases for banking and financial services.",
            language: .french,
            financialSkill: .banking,
            difficulty: .beginner
        )
    )
    .environmentObject(UserViewModel())
}
