//
//  Untitled.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 14/05/25.
//

import SwiftUI

struct SessionCard : View{
    var body : some View{
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Session Title")
                        .font(.body.bold())
                        .foregroundColor(Color("black"))
                        .padding(.vertical, 4)
                }
                Spacer()
                Text("04:00")
                    .bold()
                    .foregroundColor(Color("primary"))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color.white).stroke(LinearGradient(
                    gradient: Gradient(colors: [Color("blue"), Color("primary")]),
                    startPoint: .trailing,
                    endPoint: .leading
                ), lineWidth: 1))
        }
    }
}

#Preview{
    SessionCard()
}


