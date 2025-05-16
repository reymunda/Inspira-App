
import SwiftUI
import AudioToolbox

struct CustomPicker: View {
    @State var selectedIndex: Int? = 0
    @State var items: [MeetingSection] = [
        MeetingSection(title: "Brain Dump", session: "Session 1", time: "05:00"),
        MeetingSection(title: "Share the Results to Stakeholder", session: "Session 2", time: "12:00"),
        MeetingSection(title: "Brainstorming", session: "Session 3", time: "03:00"),
        MeetingSection(title: "Next Big Thing", session: "Session 4", time: "15:00")
    ]
    
    var soundId: SystemSoundID = 1127
    var itemHeight: CGFloat = 58.0
    var menuHeightMultiplier: CGFloat = 5
    
    var body: some View {
        //        let itemsCountAbove = Double(Int((menuHeightMultiplier - 1)/2))
        //        let degreesMultiplier: Double = -40.0 / itemsCountAbove
        //        let scaleMultiplier: CGFloat = 0.1 / itemsCountAbove
        
        ZStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 24) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        let indexDiff = Double(index - (selectedIndex ?? 0))
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.body.bold())
                                    .foregroundColor(Color("black"))
                                    .padding(.vertical, 4)
                                
                            }
                            Spacer()
                            Text(item.time)
                                .bold()
                                .foregroundColor(index == selectedIndex ? Color(.blue) : Color("black"))
                            
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .stroke(
                                    selectedIndex == index
                                        ? AnyShapeStyle(LinearGradient(
                                            gradient: Gradient(colors: [Color("blue"), Color("primary")]),
                                            startPoint: .trailing,
                                            endPoint: .leading
                                        ))
                                        : AnyShapeStyle(Color.clear),
                                        lineWidth: selectedIndex == index ? 4 : 0
                                    )

                            )

                        .id(index)
                        .frame(height: itemHeight)
                        .scrollTransition { content, phase in
                                   content
                                       .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                       .blur(radius: phase .isIdentity ? 0 : 1.5)
                               }
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, 4)
            }
            .contentMargins(.vertical, 320 / 2 - 58 / 2)
            .scrollPosition(id: $selectedIndex, anchor: .center)
            .frame(height: 320)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .onChange(of: selectedIndex, initial: false) {
                AudioServicesPlaySystemSound(soundId)
            }
            Image("session-dissapear")
                .resizable()
                .scaledToFit()
                .offset(y: -120)
            Image("session-dissapear")
                .resizable()
                .scaledToFit()
                .offset(y: -120)
                .rotationEffect(.degrees(180))
        }
            .background(Color("neon-surface"))
    }
}



#Preview {
    CustomPicker()
}
