//
//  SinglePulse.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 13/05/25.
//

import SwiftUI

struct MultiplePulse : View {
    var body : some View{
        ZStack{
            ForEach(1 ..< 5, id: \.self) { index in
                SinglePulse()
                    .frame(width: CGFloat(index * 150), height: CGFloat(index * 150))
            }
        }.frame(width: 250, height: 250)
    }
}

#Preview{
  MultiplePulse()
}
