//
//  ContentView.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        OnboardingView()
    }
}

#Preview {
    ContentView()
        .environmentObject(UserViewModel())
}
