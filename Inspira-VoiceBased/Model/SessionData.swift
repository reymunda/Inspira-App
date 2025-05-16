//
//  SessionData.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 14/05/25.
//

import Foundation

class SessionData: ObservableObject {
    @Published var id = UUID()
    @Published var title: String
    @Published var session: String
    @Published var time: String

    init(title: String, session: String, time: String) {
        self.title = title
        self.session = session
        self.time = time
    }
}

