//
//  SessionData.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 14/05/25.
//

import Foundation
import Combine

struct MeetingSection: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var session: String
    var time: String
    var note: String
}

class MeetingData: ObservableObject {
    @Published var sections: [MeetingSection] = [
        MeetingSection(title: "Brainstorming", session: "Session 1", time: "05:00", note: "No notes yet"),
        MeetingSection(title: "Share the Results to Stakeholder", session: "Session 2", time: "12:00", note: "No notes yet"),
        MeetingSection(title: "Next Big Thing", session: "Session 3", time: "03:00", note: "No notes yet")
    ]
    @Published var selectedIndex: Int? = 0
    @Published var audioURL: URL?
}

