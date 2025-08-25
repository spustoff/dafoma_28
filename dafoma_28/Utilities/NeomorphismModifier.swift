//
//  NeomorphismModifier.swift
//  EduWise Most
//
//  Created by Вячеслав on 8/25/25.
//

import SwiftUI

struct NeomorphismButtonStyle: ButtonStyle {
    var isPressed: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.neomorphLight)
                    .shadow(
                        color: configuration.isPressed ? Color.neomorphShadowLight : Color.neomorphShadowDark,
                        radius: configuration.isPressed ? 2 : 8,
                        x: configuration.isPressed ? 1 : -4,
                        y: configuration.isPressed ? 1 : -4
                    )
                    .shadow(
                        color: configuration.isPressed ? Color.neomorphShadowDark : Color.neomorphShadowLight,
                        radius: configuration.isPressed ? 2 : 8,
                        x: configuration.isPressed ? -1 : 4,
                        y: configuration.isPressed ? -1 : 4
                    )
            )
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct NeomorphismCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    var shadowRadius: CGFloat = 8
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.neomorphLight)
                    .shadow(
                        color: Color.neomorphShadowDark,
                        radius: shadowRadius,
                        x: -shadowRadius/2,
                        y: -shadowRadius/2
                    )
                    .shadow(
                        color: Color.neomorphShadowLight,
                        radius: shadowRadius,
                        x: shadowRadius/2,
                        y: shadowRadius/2
                    )
            )
    }
}

struct NeomorphismInsetModifier: ViewModifier {
    var cornerRadius: CGFloat = 15
    var shadowRadius: CGFloat = 4
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.neomorphLight)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.neomorphShadowLight, Color.neomorphShadowDark]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                            .shadow(
                                color: Color.neomorphShadowDark,
                                radius: shadowRadius,
                                x: shadowRadius/2,
                                y: shadowRadius/2
                            )
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    )
            )
    }
}

extension View {
    func neomorphismCard(cornerRadius: CGFloat = 20, shadowRadius: CGFloat = 8) -> some View {
        self.modifier(NeomorphismCardModifier(cornerRadius: cornerRadius, shadowRadius: shadowRadius))
    }
    
    func neomorphismInset(cornerRadius: CGFloat = 15, shadowRadius: CGFloat = 4) -> some View {
        self.modifier(NeomorphismInsetModifier(cornerRadius: cornerRadius, shadowRadius: shadowRadius))
    }
}
