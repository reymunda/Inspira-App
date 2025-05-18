//
//  SessionRunningLiveActivity.swift
//  SessionRunning
//
//  Created by Reymunda Alfathur on 18/05/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SessionRunningAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SessionRunningLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SessionRunningAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom

                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 8) {
                        HStack(alignment: .top, spacing: 12) {
                            // Vertical timeline + icon
                            VStack(spacing: 0) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color("primary"), Color("neon")]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 36, height: 36)

                                    Image(systemName: "waveform")
                                        .symbolEffect(.pulse, options: .repeating)
                                        .font(.system(size: 24))
                                        .frame(width: 24, height: 24)
                                }

                                Rectangle()
                                    .fill(Color("white").opacity(0.6))
                                    .frame(width: 1.5, height: 13)

                                Circle()
                                    .fill(Color("white").opacity(0.6))
                                    .frame(width: 12, height: 13)

                                Rectangle()
                                    .fill(Color("white").opacity(0.6))
                                    .frame(width: 1.5, height: 12)

                                Circle()
                                    .fill(Color("white").opacity(0.6))
                                    .frame(width: 12, height: 12)
                            }

                            // Middle content
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Share the Results to Stakeholder")
                                    .bold()
                                    .font(.callout)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(nil)

                                Text("Brainstorming")
                                    .font(.footnote)
                                    .foregroundColor(Color("white").opacity(0.6))

                                Text("Next Big Thing")
                                    .font(.footnote)
                                    .foregroundColor(Color("white").opacity(0.6))
                            }

                            Spacer()

                            // Right side times
                            VStack(alignment: .trailing, spacing: 20) {
                                HStack(spacing: 4) {
                                    Image(systemName: "stopwatch")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(Color("primary"))

                                    Text("12:00")
                                        .bold()
                                        .font(.body)
                                        .foregroundColor(Color("primary"))
                                }

                                VStack (alignment: .trailing, spacing: 8){
                                    Text("05:00")
                                        .font(.footnote)
                                        .foregroundColor(Color("white").opacity(0.6))
                                    
                                Text("03:00")
                                    .font(.footnote)
                                    .foregroundColor(Color("white").opacity(0.6))
                            }
                            }
                            .padding(0)
                            .padding(.top, 8)
                        }
                        
//                        // Buttons
//                        HStack(spacing: 8) {
//                            Button(action: { /* Previous */ }) {
//                                Text("Previous")
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(Color("primary"))
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                    .background(Color("buttonBackground"))
//                                    .cornerRadius(24)
//                            }
//
//                            Button(action: { /* Next */ }) {
//                                Text("Next")
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(Color("primary"))
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                    .background(Color("buttonBackground"))
//                                    .cornerRadius(24)
//                            }
//                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                    .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 1, alignment: .center)
                }
                
            }
            
            compactLeading: {
                HStack(spacing: 6){
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("primary"), Color("neon")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 22, height: 22)
                        
                        
                        Image(systemName: "waveform")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                    }
                    Text("Session 2")
                        .bold()
                        .font(.caption)
                }
            } compactTrailing: {
                HStack(spacing: 4){
                    Image(systemName: "stopwatch")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("primary"))
                    Text("12:00")
                        .bold()
                        .font(.caption)
                        .foregroundColor(Color("primary"))
                }
                

            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SessionRunningAttributes {
    fileprivate static var preview: SessionRunningAttributes {
        SessionRunningAttributes(name: "World")
    }
}

extension SessionRunningAttributes.ContentState {
    fileprivate static var smiley: SessionRunningAttributes.ContentState {
        SessionRunningAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SessionRunningAttributes.ContentState {
         SessionRunningAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SessionRunningAttributes.preview) {
   SessionRunningLiveActivity()
} contentStates: {
    SessionRunningAttributes.ContentState.smiley
    SessionRunningAttributes.ContentState.starEyes
}
