//
//  OnboardingView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showSignUp = false
    
    let onboardingPages = [
        OnboardingPage(
            title: "Learn Languages with Finance",
            description: "Master new languages through real-world financial scenarios and practical applications.",
            imageName: "chart.line.uptrend.xyaxis",
            color: Color.accentOrange
        ),
        OnboardingPage(
            title: "Interactive Challenges",
            description: "Join community challenges, compete with others, and track your progress on leaderboards.",
            imageName: "trophy.fill",
            color: Color.primaryBlue
        ),
        OnboardingPage(
            title: "Personalized Learning",
            description: "Create custom learning paths that combine language skills with financial literacy.",
            imageName: "person.crop.circle.badge.checkmark",
            color: Color.accentOrange
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.primaryBlue, Color.primaryWhite]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Page indicator
                    HStack(spacing: 8) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.accentOrange : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.top, 50)
                    
                    // Content
                    TabView(selection: $currentPage) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            OnboardingPageView(page: onboardingPages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.5), value: currentPage)
                    
                    // Bottom buttons
                    VStack(spacing: 16) {
                        if currentPage == onboardingPages.count - 1 {
                            Button(action: {
                                showSignUp = true
                            }) {
                                Text("Get Started")
                                    .font(.headline)
                                    .foregroundColor(.textOnAccent)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentOrange)
                                    .cornerRadius(15)
                            }
                            .buttonStyle(NeomorphismButtonStyle())
                            .padding(.horizontal, 40)
                        } else {
                            Button(action: {
                                withAnimation {
                                    currentPage += 1
                                }
                            }) {
                                Text("Next")
                                    .font(.headline)
                                    .foregroundColor(.textOnAccent)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentOrange)
                                    .cornerRadius(15)
                            }
                            .buttonStyle(NeomorphismButtonStyle())
                            .padding(.horizontal, 40)
                        }
                        
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
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
        .fullScreenCover(isPresented: $showSignUp) {
            SignUpView()
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(page.color)
                .neomorphismCard(cornerRadius: 40, shadowRadius: 12)
                .frame(width: 120, height: 120)
            
            // Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}

#Preview {
    OnboardingView()
}
