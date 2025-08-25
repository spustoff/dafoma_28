//
//  ColorScheme.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

extension Color {
    // Primary background colors
    static let primaryBlue = Color(hex: "003265")
    static let primaryWhite = Color(hex: "ffffff")
    
    // Accent color for elements and buttons
    static let accentOrange = Color(hex: "f65505")
    
    // Neomorphism colors
    static let neomorphLight = Color.white
    static let neomorphDark = Color(red: 0.85, green: 0.85, blue: 0.87)
    static let neomorphShadowLight = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let neomorphShadowDark = Color(red: 0.75, green: 0.75, blue: 0.78)
    
    // Text colors
    static let textPrimary = Color.primaryBlue
    static let textSecondary = Color.gray
    static let textOnAccent = Color.white
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
