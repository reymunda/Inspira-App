//
//  Recording.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 13/05/25.
//
import SwiftUI
import AVFoundation
import SwiftUISpeechToText


struct Recording: View {
    @State private var navigate = false
    @State private var isRecording = false
    @StateObject var speechRecognizer = SpeechRecognizer(localeIdentifier: "id-ID")
    
    var transcript: String?
    var lastWordsForDisplay: String {
            let words = speechRecognizer.transcript.split(separator: " ")
            let lastWords = words.suffix(20)
            return lastWords.joined(separator: " ")
        }
    var body: some View {
        NavigationStack {
            ZStack {
                Color("neon-surface")
                    .ignoresSafeArea()
                
                ZStack {
                    CustomPicker()
                        .offset(y: 140)
                        .padding(.horizontal,20)
                    Circle()
                        .scaleEffect(0.5)
                        .foregroundColor(Color("primary"))
                        .blur(radius: 100)
                        .offset(x: -150, y: -200)
                    Circle()
                        .scaleEffect(0.5)
                        .foregroundColor(Color("primary"))
                        .blur(radius: 100)
                        .offset(x: 150, y: 50)
                    Circle()
                        .scaleEffect(0.5)
                        .foregroundColor(Color("primary"))
                        .blur(radius: 75)
                        .offset(x: 0, y: 400)
                }
                VStack {
                    RecordingMic()
                    
                    Text(speechRecognizer.transcript.isEmpty ? "Say something..." : lastWordsForDisplay)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.top, 24)
                        .lineLimit(3)
                        .opacity(0.5)

                    
                    Spacer()
                    
                    EndMeetButton(navigate: $navigate)
                    
                    NavigationLink(destination: MeetingResult(), isActive: $navigate) {
                        EmptyView()
                    }
                }
                .padding(.top, 42)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            }
        }
        .onAppear {
            speechRecognizer.transcribe()
        }
        .onChange(of: speechRecognizer.transcript) { newTranscript in
            print("Kamu bilang: \(newTranscript)")
        }
        .navigationBarHidden(true)
            .animation(nil)
        }
    }




struct RecordingMic : View {
    var body : some View{
        Button(action : {
            
        }){
            ZStack {
                Image("circle-record")
                    .resizable()
                    .frame(width: 250, height: 250)

                Image(systemName: "waveform")
                    .resizable()
                    .frame(width: 130, height: 130)
                    .foregroundColor(.white)
            }.background(MultiplePulse())

        }
    }
}

#Preview{
    Recording()
}
