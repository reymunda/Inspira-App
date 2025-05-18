//
//  Recording.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 13/05/25.
//
import SwiftUI
import AVFoundation
import SwiftUISpeechToText
import ActivityKit
import SessionRunningExtension

struct Recording: View {
    @State var currentActivity: Activity<SessionRunningAttributes>? = nil

    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioURL: URL?
    @EnvironmentObject var meetingData: MeetingData
    @State private var navigate = false
    @State private var lastIndex: Int? = nil
    @StateObject var speechRecognizer = SpeechRecognizer(localeIdentifier: "id-ID")
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
                        .truncationMode(.head)
                        .opacity(0.5)


                    
                    Spacer()
                    
                    EndMeetButton(navigate: $navigate)
                    
                    NavigationLink(destination: MeetingResult(), isActive: $navigate) {
                        EmptyView()
                    }
                    .onChange(of: navigate) {
                        stopRecording()
                        speechRecognizer.stopTranscribing()
                        endLiveActivity()
                        
                    }

                }
                .padding(.top, 42)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            }
        }
        .task {
            speechRecognizer.transcribe()
            startRecording()
            startLiveActivity()

        }
        .onChange(of: speechRecognizer.transcript) { newTranscript in
            
            if let index = meetingData.selectedIndex, meetingData.sections.indices.contains(index) {
                
                if lastIndex != index {
                    lastIndex = index
                    speechRecognizer.stopTranscribing()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if lastIndex == index {
                            speechRecognizer.transcribe()
                        }
                    }
                    return
                }


                meetingData.sections[index].note = newTranscript
                print("\(meetingData.sections[index].title): \(meetingData.sections[index])")
            }
        }
        .navigationBarHidden(true)
        .animation(nil)
        }
    func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)
        } catch {
        }
    }
    func startRecording() {
        setupAudioSession()
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = documents.appendingPathComponent("meetingAudio.m4a")
        audioURL = filename
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder?.record()
            } catch {

            }
    }

    func stopRecording() {
        audioRecorder?.stop()
        meetingData.audioURL = audioURL
    }
    func startLiveActivity() {
        
        let attr = SessionRunningAttributes(name: "Reymunda")
        let state = SessionRunningAttributes.ContentState(emoji: "🔥")

        do {
            let activity = try Activity<SessionRunningAttributes>.request(
                attributes: attr,
                content: .init(state: state, staleDate: Date.now.addingTimeInterval(300)),
                pushType: nil
            )
            currentActivity = activity
            print("Live Activity started: \(activity.id)")
        } catch {
            print("Failed to start Live Activity: \(error.localizedDescription)")
        }
    }
    
    func endLiveActivity() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            Task {
                await currentActivity?.end(nil, dismissalPolicy: .immediate)
            }
        }
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
        .environmentObject(MeetingData())

}
