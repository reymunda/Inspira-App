//
//  ContentView.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 11/05/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var meetingData = MeetingData()
    
    var body: some View {
        MeetingSession()
            .environmentObject(meetingData)
    }
}

#Preview {
    ContentView()
}
