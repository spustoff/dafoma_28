//
//  MainTabView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var userViewModel = UserViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            CoursesView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                    Text("Courses")
                }
                .tag(1)
            
            CommunityView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "person.3.fill" : "person.3")
                    Text("Community")
                }
                .tag(2)
            
            UserProgressView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "chart.line.uptrend.xyaxis" : "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.crop.circle.fill" : "person.crop.circle")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.accentOrange)
        .environmentObject(userViewModel)
    }
}

#Preview {
    MainTabView()
}
