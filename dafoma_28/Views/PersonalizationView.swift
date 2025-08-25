//
//  PersonalizationView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct PersonalizationView: View {
    @StateObject private var userViewModel = UserViewModel()
    @State private var selectedLanguages: Set<Language> = []
    @State private var selectedSkills: Set<FinancialSkill> = []
    @State private var learningGoal = ""
    @State private var targetDate = Date().addingTimeInterval(86400 * 90) // 3 months from now
    @State private var currentStep = 0
    @State private var showMainApp = false
    
    let steps = ["Languages", "Skills", "Goals"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.primaryWhite, Color.neomorphLight]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Progress Header
                    VStack(spacing: 20) {
                        Text("Personalize Your Experience")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                        
                        // Progress Bar
                        HStack(spacing: 8) {
                            ForEach(0..<steps.count, id: \.self) { index in
                                VStack(spacing: 8) {
                                    Circle()
                                        .fill(index <= currentStep ? Color.accentOrange : Color.gray.opacity(0.3))
                                        .frame(width: 12, height: 12)
                                    
                                    Text(steps[index])
                                        .font(.caption)
                                        .foregroundColor(index <= currentStep ? .textPrimary : .textSecondary)
                                }
                                
                                if index < steps.count - 1 {
                                    Rectangle()
                                        .fill(index < currentStep ? Color.accentOrange : Color.gray.opacity(0.3))
                                        .frame(height: 2)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 30)
                    
                    // Content
                    TabView(selection: $currentStep) {
                        // Step 1: Language Selection
                        LanguageSelectionView(selectedLanguages: $selectedLanguages)
                            .tag(0)
                        
                        // Step 2: Skills Selection
                        SkillsSelectionView(selectedSkills: $selectedSkills)
                            .tag(1)
                        
                        // Step 3: Goals Setup
                        GoalsSetupView(learningGoal: $learningGoal, targetDate: $targetDate)
                            .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
                    
                    // Bottom Navigation
                    VStack(spacing: 16) {
                        Button(action: nextStep) {
                            Text(currentStep == steps.count - 1 ? "Complete Setup" : "Continue")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.textOnAccent)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(canProceed ? Color.accentOrange : Color.gray)
                                .cornerRadius(15)
                        }
                        .buttonStyle(NeomorphismButtonStyle())
                        .disabled(!canProceed)
                        .padding(.horizontal, 40)
                        
                        if currentStep > 0 {
                            Button(action: {
                                withAnimation {
                                    currentStep -= 1
                                }
                            }) {
                                Text("Previous")
                                    .font(.subheadline)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            MainTabView()
        }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 0: return !selectedLanguages.isEmpty
        case 1: return !selectedSkills.isEmpty
        case 2: return !learningGoal.isEmpty
        default: return false
        }
    }
    
    private func nextStep() {
        if currentStep < steps.count - 1 {
            withAnimation {
                currentStep += 1
            }
        } else {
            completeSetup()
        }
    }
    
    private func completeSetup() {
        // Create learning goals
        let goals = selectedSkills.map { skill in
            LearningGoal(
                title: "Master \(skill.displayName)",
                description: learningGoal,
                targetLanguage: selectedLanguages.first ?? .english,
                targetSkill: skill,
                targetDate: targetDate
            )
        }
        
        userViewModel.updateProfile(
            name: userViewModel.currentUser?.name ?? "",
            selectedLanguages: Array(selectedLanguages),
            learningGoals: goals
        )
        
        showMainApp = true
    }
}

struct LanguageSelectionView: View {
    @Binding var selectedLanguages: Set<Language>
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Which languages would you like to learn?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Text("Select one or more languages to get started")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Language.allCases, id: \.self) { language in
                        LanguageCard(
                            language: language,
                            isSelected: selectedLanguages.contains(language)
                        ) {
                            if selectedLanguages.contains(language) {
                                selectedLanguages.remove(language)
                            } else {
                                selectedLanguages.insert(language)
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding(.vertical, 20)
        }
    }
}

struct SkillsSelectionView: View {
    @Binding var selectedSkills: Set<FinancialSkill>
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("What financial skills interest you?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Text("Choose the areas you'd like to focus on")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(FinancialSkill.allCases, id: \.self) { skill in
                        SkillCard(
                            skill: skill,
                            isSelected: selectedSkills.contains(skill)
                        ) {
                            if selectedSkills.contains(skill) {
                                selectedSkills.remove(skill)
                            } else {
                                selectedSkills.insert(skill)
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding(.vertical, 20)
        }
    }
}

struct GoalsSetupView: View {
    @Binding var learningGoal: String
    @Binding var targetDate: Date
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Set Your Learning Goal")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What do you want to achieve?")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.textPrimary)
                        
                        TextField("e.g., Become fluent in French finance", text: $learningGoal)
                            .textFieldStyle(NeomorphismTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Target Date")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.textPrimary)
                        
                        DatePicker("", selection: $targetDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .neomorphismInset(cornerRadius: 12, shadowRadius: 3)
                            .padding()
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding(.vertical, 20)
        }
    }
}

struct LanguageCard: View {
    let language: Language
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(language.flag)
                    .font(.system(size: 30))
                
                Text(language.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? Color.accentOrange.opacity(0.1) : Color.neomorphLight)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentOrange : Color.clear, lineWidth: 2)
            )
            .neomorphismCard(cornerRadius: 12, shadowRadius: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SkillCard: View {
    let skill: FinancialSkill
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: skill.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .accentOrange : .textSecondary)
                
                Text(skill.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? Color.accentOrange.opacity(0.1) : Color.neomorphLight)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentOrange : Color.clear, lineWidth: 2)
            )
            .neomorphismCard(cornerRadius: 12, shadowRadius: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PersonalizationView()
}
