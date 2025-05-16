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
        VStack{
            LottieView(animation: .named("loading.json"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop) ))
        }
    }
}

#Preview{
    Loading()
}
