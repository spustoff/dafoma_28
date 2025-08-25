//
//  ProfileView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showEditProfile = false
    @State private var showSettings = false
    @State private var showDeleteConfirmation = false
    @State private var navigateToOnboarding = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    headerSection
                    
                    // Profile Info
                    profileInfoSection
                    
                    // Quick Stats
                    quickStatsSection
                    
                    // Languages & Skills
                    languagesAndSkillsSection
                    
                    // Menu Items
                    menuItemsSection
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
        .sheet(isPresented: $showEditProfile) {
            EditProfileView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .alert("Delete Account", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                performAccountDeletion()
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.")
        }
        .fullScreenCover(isPresented: $navigateToOnboarding) {
            OnboardingView()
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button(action: {
                showSettings = true
            }) {
                Image(systemName: "gearshape")
                    .font(.title2)
                    .foregroundColor(.textSecondary)
                    .neomorphismCard(cornerRadius: 20, shadowRadius: 4)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.top, 60)
    }
    
    private var profileInfoSection: some View {
        VStack(spacing: 20) {
            // Profile Picture and Basic Info
            HStack(spacing: 16) {
                // Profile Picture
                Circle()
                    .fill(Color.accentOrange.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Text(String(userViewModel.currentUser?.name.prefix(1) ?? "U"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.accentOrange)
                    )
                    .neomorphismCard(cornerRadius: 40, shadowRadius: 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(userViewModel.currentUser?.name ?? "User")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text(userViewModel.currentUser?.email ?? "user@example.com")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    HStack {
                        Text("Level \(userViewModel.currentUser?.progress.level ?? 1)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.accentOrange)
                        
                        Text("•")
                            .foregroundColor(.textSecondary)
                        
                        Text("Member since \(formatJoinDate())")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
            }
            
            // Edit Profile Button
            Button(action: {
                showEditProfile = true
            }) {
                Text("Edit Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentOrange)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentOrange.opacity(0.1))
                    .cornerRadius(12)
            }
            .buttonStyle(NeomorphismButtonStyle())
        }
        .padding()
        .neomorphismCard()
    }
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Stats")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: 16) {
                ProfileStatCard(
                    title: "Courses",
                    value: "\(userViewModel.currentUser?.completedCourses.count ?? 0)",
                    icon: "book.fill",
                    color: .primaryBlue
                )
                
                ProfileStatCard(
                    title: "Streak",
                    value: "\(userViewModel.currentUser?.progress.currentStreak ?? 0)",
                    icon: "flame.fill",
                    color: .accentOrange
                )
                
                ProfileStatCard(
                    title: "Badges",
                    value: "\(userViewModel.currentUser?.progress.badges.count ?? 0)",
                    icon: "trophy.fill",
                    color: .yellow
                )
            }
        }
    }
    
    private var languagesAndSkillsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Languages & Skills")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 16) {
                // Languages
                if let languages = userViewModel.currentUser?.selectedLanguages, !languages.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Learning Languages")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.textSecondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(languages, id: \.self) { language in
                                    HStack {
                                        Text(language.flag)
                                        Text(language.displayName)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.accentOrange.opacity(0.1))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                }
                
                // Learning Goals
                if let goals = userViewModel.currentUser?.learningGoals, !goals.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Learning Goals")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.textSecondary)
                        
                        VStack(spacing: 8) {
                            ForEach(goals.prefix(3)) { goal in
                                HStack {
                                    Text(goal.title)
                                        .font(.caption)
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text("\(Int(goal.progress * 100))%")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.accentOrange)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.neomorphLight)
                                .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .padding()
            .neomorphismCard()
        }
    }
    
    private var menuItemsSection: some View {
        VStack(spacing: 12) {
            MenuItemRow(
                icon: "chart.line.uptrend.xyaxis",
                title: "Learning Analytics",
                subtitle: "View detailed progress reports"
            ) {
                // Handle analytics tap
            }
            
            MenuItemRow(
                icon: "person.3.fill",
                title: "Invite Friends",
                subtitle: "Share EduWise with friends"
            ) {
                // Handle invite tap
            }
            
            MenuItemRow(
                icon: "questionmark.circle",
                title: "Help & Support",
                subtitle: "Get help and contact support"
            ) {
                // Handle help tap
            }
            
            MenuItemRow(
                icon: "star.fill",
                title: "Rate App",
                subtitle: "Rate EduWise on the App Store"
            ) {
                // Handle rate tap
            }
            
            MenuItemRow(
                icon: "rectangle.portrait.and.arrow.right",
                title: "Sign Out",
                subtitle: "Sign out of your account",
                isDestructive: true
            ) {
                userViewModel.signOut()
            }
            
            MenuItemRow(
                icon: "trash.fill",
                title: "Delete Account",
                subtitle: "Permanently delete your account and all data",
                isDestructive: true
            ) {
                deleteAccount()
            }
        }
    }
    
    private func formatJoinDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: userViewModel.currentUser?.createdAt ?? Date())
    }
    
    private func deleteAccount() {
        showDeleteConfirmation = true
    }
    
    private func performAccountDeletion() {
        // Clear user data
        userViewModel.signOut()
        
        // Navigate to onboarding
        navigateToOnboarding = true
    }
}

struct ProfileStatCard: View {
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

struct MenuItemRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isDestructive ? .red : .accentOrange)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(isDestructive ? .red : .textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding()
            .neomorphismCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EditProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var name: String = ""
    @State private var selectedLanguages: Set<Language> = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Profile Picture
                    VStack(spacing: 16) {
                        Circle()
                            .fill(Color.accentOrange.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(String(name.prefix(1)))
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.accentOrange)
                            )
                            .neomorphismCard(cornerRadius: 50, shadowRadius: 8)
                        
                        Button(action: {
                            // Handle photo change
                        }) {
                            Text("Change Photo")
                                .font(.subheadline)
                                .foregroundColor(.accentOrange)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.textPrimary)
                        
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(NeomorphismTextFieldStyle())
                    }
                    
                    // Languages Selection
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Learning Languages")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.textPrimary)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(Language.allCases, id: \.self) { language in
                                Button(action: {
                                    if selectedLanguages.contains(language) {
                                        selectedLanguages.remove(language)
                                    } else {
                                        selectedLanguages.insert(language)
                                    }
                                }) {
                                    HStack {
                                        Text(language.flag)
                                        Text(language.displayName)
                                            .font(.caption)
                                            .foregroundColor(.textPrimary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedLanguages.contains(language) ? Color.accentOrange.opacity(0.1) : Color.neomorphLight)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedLanguages.contains(language) ? Color.accentOrange : Color.clear, lineWidth: 2)
                                    )
                                    .neomorphismCard(cornerRadius: 12, shadowRadius: 4)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Color.neomorphLight.ignoresSafeArea())
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveProfile()
                }
            )
        }
        .onAppear {
            loadCurrentProfile()
        }
    }
    
    private func loadCurrentProfile() {
        name = userViewModel.currentUser?.name ?? ""
        selectedLanguages = Set(userViewModel.currentUser?.selectedLanguages ?? [])
    }
    
    private func saveProfile() {
        userViewModel.updateProfile(
            name: name,
            selectedLanguages: Array(selectedLanguages),
            learningGoals: userViewModel.currentUser?.learningGoals ?? []
        )
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    SettingsSection(title: "Notifications") {
                        SettingsToggleRow(title: "Push Notifications", isOn: .constant(true))
                        SettingsToggleRow(title: "Email Updates", isOn: .constant(false))
                        SettingsToggleRow(title: "Learning Reminders", isOn: .constant(true))
                    }
                    
                    SettingsSection(title: "Learning") {
                        SettingsRow(title: "Daily Goal", value: "30 minutes")
                        SettingsRow(title: "Difficulty Level", value: "Intermediate")
                        SettingsToggleRow(title: "Offline Mode", isOn: .constant(false))
                    }
                    
                    SettingsSection(title: "About") {
                        SettingsRow(title: "Version", value: "1.0.0")
                        SettingsActionRow(title: "Privacy Policy")
                        SettingsActionRow(title: "Terms of Service")
                    }
                }
                .padding(20)
            }
            .background(Color.neomorphLight.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 16)
            
            VStack(spacing: 0) {
                content
            }
            .neomorphismCard()
        }
    }
}

struct SettingsRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .padding()
    }
}

struct SettingsToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .accentOrange))
        }
        .padding()
    }
}

struct SettingsActionRow: View {
    let title: String
    
    var body: some View {
        Button(action: {
            // Handle action
        }) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserViewModel())
}
