//
//  LoadingView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 03/11/2023.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating: Bool = false

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(AngularGradient(gradient: .init(colors: [.blue, .green]), center: .center), style: StrokeStyle(lineWidth: 5, lineCap: .round))
            .frame(width: 50, height: 50)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear() {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    LoadingView()
}
