//
//  Recording.swift
//  Inspira-VoiceBased
//
//  Created by Reymunda Alfathur on 13/05/25.
//
import SwiftUI

struct Recording: View {
    @State private var navigate = false

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
                    
                    Text("Say something...")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.top, 24)
                    
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
        }.navigationBarHidden(true)
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
