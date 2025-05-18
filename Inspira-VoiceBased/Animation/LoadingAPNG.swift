//
//  LoadingAPNG.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 18/05/25.
//

import SwiftUI
import UIKit

struct LoadingSVG : View {
    var body: some View{
        VStack(spacing: -70){
            SVGAnimated()
                .frame(width: 250, height: 250)
            Text("Polishing your notes!")
                .foregroundColor(Color("grey"))
        }
    }
}

struct SVGAnimated: View {
    @State private var currentIndex = 0
    @State private var opacity = 1.0

    private let images = ["1", "2", "3", "4", "5", "6"]
    private let animationDuration = 0.25
    private let displayDuration = 0.25

    var body: some View {
        Image(images[currentIndex])
            .resizable()
            .scaledToFit()
            .opacity(opacity)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: animationDuration + displayDuration, repeats: true) { _ in
                    // Fade out
                    withAnimation(.spring(duration: animationDuration)) {
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                        currentIndex = (currentIndex + 1) % images.count
                        withAnimation(.spring(duration: animationDuration)) {
                            opacity = 1
                        }
                    }
                }
            }
    }
}



#Preview{
    LoadingSVG()
}
