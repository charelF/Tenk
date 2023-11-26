//
//  BackgroundView.swift
//  Tenk
//
//  Created by Charel Felten on 11/11/2023.
//

import SwiftUI

struct BackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            RandomCirclesView()
                .frame(width: 200)
                .blur(radius: 80)
            Rectangle()
                .foregroundStyle(colorScheme == .light ? Color.white : Color.black)
                .background(.regularMaterial)
             .opacity(0.60)
        }.ignoresSafeArea()
    }
}

struct RandomCirclesView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<15, id: \.self) { _ in
                    Circle()
                        .foregroundColor(.random)
                    .frame(width: CGFloat.random(in: 50...200))
                    .position(x: CGFloat.random(in: -100...geometry.size.width+100), y: CGFloat.random(in: -100...geometry.size.height+100))
                }
            }
        }
    }
}

extension Color {
    static var random: Color {
        if Int.random(in: 0...1) == 1 {
            return Color(
                red: .random(in: 0.5...1),
                green: .random(in: 0...0),
                blue: .random(in: 0.5...1)
            )
        } else {
            return Color(
                red: .random(in: 0.5...1),
                green: .random(in: 0.5...1),
                blue: .random(in: 0...0)
            )
        }
    }
}

#Preview {
    BackgroundView()
}
