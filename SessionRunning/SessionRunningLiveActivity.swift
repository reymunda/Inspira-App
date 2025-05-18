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
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
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
