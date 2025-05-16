//
//  Divider.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 12/05/25.
//

import SwiftUI

struct Divider : View {
    var body: some View{
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .white.opacity(0), location: 0.0),
                .init(color: .white.opacity(0.6), location: 0.05),
                .init(color: Color("primary"), location: 0.2),
                .init(color: Color( "primary"), location: 0.5),
                .init(color: Color( "blue"), location: 0.8),
                .init(color: .white.opacity(0.6), location: 0.95),
                .init(color: .white.opacity(0), location: 1.0),
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(height: 1)
        .clipShape(Capsule())
    }
}
