//
//  loading.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 11/05/25.
//
import SwiftUI
import Lottie

struct Loading : View {
    var body: some View{
        VStack(spacing: -40){
            LottieView(animation: .named("loading.json"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop) ))
            Text("Polishing your notes!")
                .foregroundColor(Color("grey"))
        }
    }
}

#Preview{
    Loading()
}
