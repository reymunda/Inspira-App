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
        }
        .onChange(of: speechRecognizer.transcript) { newTranscript in
            if let index = meetingData.selectedIndex, meetingData.sections.indices.contains(index) {
                
                if lastIndex != index {
                    lastIndex = index
                    speechRecognizer.stopTranscribing()
                    
                    // Hindari capture suara saat transcriber belum mulai
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if lastIndex == index { // pastikan user belum ganti index lagi
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
            print("Audio session is active")
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
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
                print("Recording started ") // debug log
            } catch {
                print("Failed to start recording: \(error.localizedDescription)")
            }
    }

    func stopRecording() {
        print("Memanggil stopRecording()")
        audioRecorder?.stop()
        if let audioURL = audioURL {
            print("URL audio yang disimpan:", audioURL)
        } else {
            print("audioURL masih nil")
        }
        meetingData.audioURL = audioURL
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
