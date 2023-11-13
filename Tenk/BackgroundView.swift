//
//  BackgroundView.swift
//  Tenk
//
//  Created by Charel Felten on 11/11/2023.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            RandomCirclesView()
                .foregroundColor(Color.blue)
                .frame(width: 200)
                .blur(radius: 30)
            Rectangle()
                .foregroundColor(.white)
                .background(.regularMaterial)
             .opacity(0.75)
        }.ignoresSafeArea()
    }
}

struct RandomCirclesView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<10, id: \.self) { _ in
                    Circle()
                        .foregroundColor(.random)
                    .frame(width: CGFloat.random(in: 50...200))
                    .position(x: CGFloat.random(in: 0...geometry.size.width), y: CGFloat.random(in: 0...geometry.size.height))
                }
            }
        }
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0.5...1),
            green: .random(in: 0...0),
            blue: .random(in: 0.5...1)
        )
    }
}

#Preview {
    BackgroundView()
}
