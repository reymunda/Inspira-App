//
//  SinglePulse.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 13/05/25.
//

import SwiftUI

struct SinglePulse : View {
    @State var isAnimating: Bool = false
    var body : some View{
        ZStack{
            Circle()
                .stroke(.black, lineWidth: 2)
                .fill(.white)
                .scaleEffect(isAnimating ? 1 : 0)
                .opacity(isAnimating ? 0 : 0.25)
                .animation(.linear(duration: 1).repeatForever(autoreverses: false).speed(2/3), value: isAnimating)
        }
        .onAppear{
            isAnimating.toggle()
        }
    }
}

#Preview{
  SinglePulse()
}
