//
//  CommunityView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct CommunityView: View {
    @StateObject private var communityViewModel = CommunityViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var selectedTab = 0
    @State private var showCreatePost = false
    @State private var showChallengeDetail = false
    @State private var selectedChallenge: Challenge?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Tab Selector
                tabSelectorSection
                
                // Content
                TabView(selection: $selectedTab) {
                    // Challenges Tab
                    challengesTabView
                        .tag(0)
                    
                    // Posts Tab
                    postsTabView
                        .tag(1)
                    
                    // Leaderboard Tab
                    leaderboardTabView
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
        .sheet(isPresented: $showCreatePost) {
            CreatePostView()
        }
        .sheet(isPresented: $showChallengeDetail) {
            if let challenge = selectedChallenge {
                ChallengeDetailView(challenge: challenge)
            }
        }
        .onAppear {
            // Load all community data when view appears
            communityViewModel.loadChallenges()
            communityViewModel.loadCommunityPosts()
            
            if let userId = userViewModel.currentUser?.id {
                communityViewModel.loadUserChallenges(userId: userId)
            }
        }
        .onChange(of: selectedTab) { newTab in
            // Load leaderboard data when leaderboard tab is selected
            if newTab == 2 && !communityViewModel.challenges.isEmpty {
                communityViewModel.loadLeaderboard(for: communityViewModel.challenges.first!.id)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("Community")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            if selectedTab == 1 {
                Button(action: {
                    showCreatePost = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.textSecondary)
                        .neomorphismCard(cornerRadius: 20, shadowRadius: 4)
                        .frame(width: 40, height: 40)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .padding(.bottom, 20)
    }
    
    private var tabSelectorSection: some View {
        HStack(spacing: 0) {
            TabButton(title: "Challenges", isSelected: selectedTab == 0) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = 0
                }
            }
            
            TabButton(title: "Posts", isSelected: selectedTab == 1) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = 1
                }
            }
            
            TabButton(title: "Leaderboard", isSelected: selectedTab == 2) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = 2
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    private var challengesTabView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if communityViewModel.challenges.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "trophy.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.textSecondary)
                        
                        Text("No Challenges Available")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        Text("Check back later for new language learning challenges!")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                    .padding()
                    .neomorphismCard()
                } else {
                    ForEach(communityViewModel.challenges) { challenge in
                        ChallengeListCard(challenge: challenge) {
                            selectedChallenge = challenge
                            showChallengeDetail = true
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var postsTabView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if communityViewModel.communityPosts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bubble.left.and.bubble.right.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.textSecondary)
                        
                        Text("No Posts Yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        Text("Be the first to share your learning journey with the community!")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            showCreatePost = true
                        }) {
                            Text("Create Post")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.textOnAccent)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.accentOrange)
                                .cornerRadius(20)
                        }
                        .buttonStyle(NeomorphismButtonStyle())
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                    .padding()
                    .neomorphismCard()
                } else {
                    ForEach(communityViewModel.communityPosts) { post in
                        PostCard(post: post) {
                            // Handle post tap
                        } likeAction: {
                            if let userId = userViewModel.currentUser?.id {
                                communityViewModel.likePost(post, userId: userId)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var leaderboardTabView: some View {
        ScrollView {
            VStack(spacing: 16) {
                if communityViewModel.leaderboard.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.textSecondary)
                        
                        Text("No Leaderboard Data")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        Text("Complete challenges and lessons to appear on the leaderboard!")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                    .padding()
                    .neomorphismCard()
                } else {
                    ForEach(communityViewModel.leaderboard) { entry in
                        LeaderboardRow(entry: entry)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .textOnAccent : .textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color.accentOrange : Color.clear)
                .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ChallengeListCard: View {
    let challenge: Challenge
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: challenge.type.icon)
                        .font(.title2)
                        .foregroundColor(.accentOrange)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(challenge.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.leading)
                        
                        Text(challenge.description)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Text(challenge.language.flag)
                        .font(.title)
                }
                
                HStack {
                    Text(challenge.financialSkill.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.accentOrange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentOrange.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text(challenge.difficulty.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(difficultyColor(challenge.difficulty))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Text("\(challenge.participants.count) participants")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("Ends \(formatDate(challenge.endDate))")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    if challenge.isActive {
                        Text("Active")
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
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct PostCard: View {
    let post: CommunityPost
    let action: () -> Void
    let likeAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Circle()
                    .fill(Color.accentOrange.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(post.authorName.prefix(1)))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.accentOrange)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.authorName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    Text(formatPostDate(post.createdAt))
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: post.type.icon)
                    .font(.subheadline)
                    .foregroundColor(.accentOrange)
            }
            
            // Content
            Text(post.content)
                .font(.body)
                .foregroundColor(.textPrimary)
                .lineSpacing(4)
            
            // Tags
            if let language = post.language, let topic = post.financialTopic {
                HStack {
                    Text(language.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.accentOrange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentOrange.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text(topic.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primaryBlue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.primaryBlue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Spacer()
                }
            }
            
            // Actions
            HStack(spacing: 24) {
                Button(action: likeAction) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("\(post.likes.count)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Button(action: action) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.left")
                            .foregroundColor(.textSecondary)
                        Text("\(post.comments.count)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .neomorphismCard()
    }
    
    private func formatPostDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            Text("\(entry.rank)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(rankColor(entry.rank))
                .frame(width: 30)
            
            // User Info
            HStack {
                Circle()
                    .fill(Color.accentOrange.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(entry.userName.prefix(1)))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.accentOrange)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.userName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    Text("\(entry.completedTasks) tasks completed")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Text("\(entry.score)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.accentOrange)
            }
        }
        .padding()
        .neomorphismCard()
    }
    
    private func rankColor(_ rank: Int) -> Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return Color.orange
        default: return .textSecondary
        }
    }
}

struct CreatePostView: View {
    @State private var content = ""
    @State private var selectedType: PostType = .discussion
    @State private var selectedLanguage: Language?
    @State private var selectedTopic: FinancialSkill?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Post Type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Post Type")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(PostType.allCases, id: \.self) { type in
                                    Button(action: {
                                        selectedType = type
                                    }) {
                                        HStack {
                                            Image(systemName: type.icon)
                                            Text(type.displayName)
                                        }
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(selectedType == type ? .textOnAccent : .textPrimary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedType == type ? Color.accentOrange : Color.neomorphLight)
                                        .cornerRadius(12)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        TextField("What's on your mind?", text: $content, axis: .vertical)
                            .textFieldStyle(NeomorphismTextFieldStyle())
                            .lineLimit(5...10)
                    }
                    
                    // Optional Tags
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Tags (Optional)")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        // Language Tag
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Language")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(Language.allCases.prefix(6), id: \.self) { language in
                                        Button(action: {
                                            selectedLanguage = selectedLanguage == language ? nil : language
                                        }) {
                                            HStack {
                                                Text(language.flag)
                                                Text(language.displayName)
                                            }
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(selectedLanguage == language ? Color.accentOrange.opacity(0.2) : Color.neomorphLight)
                                            .cornerRadius(8)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                        
                        // Topic Tag
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Financial Topic")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(FinancialSkill.allCases.prefix(6), id: \.self) { skill in
                                        Button(action: {
                                            selectedTopic = selectedTopic == skill ? nil : skill
                                        }) {
                                            Text(skill.displayName)
                                                .font(.caption)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(selectedTopic == skill ? Color.primaryBlue.opacity(0.2) : Color.neomorphLight)
                                                .cornerRadius(8)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Color.neomorphLight.ignoresSafeArea())
            .navigationTitle("Create Post")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Post") {
                    createPost()
                }
                .disabled(content.isEmpty)
            )
        }
    }
    
    private func createPost() {
        // Create and submit post
        presentationMode.wrappedValue.dismiss()
    }
}

struct ChallengeDetailView: View {
    let challenge: Challenge
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Challenge details would go here
                    Text("Challenge Detail View")
                        .font(.title)
                        .foregroundColor(.textPrimary)
                }
                .padding(20)
            }
            .background(Color.neomorphLight.ignoresSafeArea())
            .navigationTitle(challenge.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    CommunityView()
        .environmentObject(UserViewModel())
}

