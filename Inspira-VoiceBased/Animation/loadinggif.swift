//
//  loading.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 18/05/25.
//
import SwiftUI
import SDWebImageSwiftUI

struct LoadingGIF : View {
    var body: some View{
        VStack(spacing: -70){
            AnimatedImage(name: "loading.gif")
                .frame(width: 250, height: 250)
            Text("Polishing your notes!")
                .foregroundColor(Color("grey"))
        }
    }
}

#Preview{
    LoadingGIF()
}
