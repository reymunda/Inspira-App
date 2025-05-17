
import SwiftUI
import AudioToolbox

struct CustomPicker: View {
    @EnvironmentObject var items: MeetingData
    
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
                    ForEach(Array(items.sections.enumerated()), id: \.element.id) { index, item in
                        let indexDiff = Double(index - (items.selectedIndex ?? 0))
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
                                .foregroundColor(index == items.selectedIndex ? Color(.blue) : Color("black"))
                            
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .stroke(
                                    items.selectedIndex == index
                                        ? AnyShapeStyle(LinearGradient(
                                            gradient: Gradient(colors: [Color("blue"), Color("primary")]),
                                            startPoint: .trailing,
                                            endPoint: .leading
                                        ))
                                        : AnyShapeStyle(Color.clear),
                                    lineWidth: items.selectedIndex == index ? 4 : 0
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
            .scrollPosition(id: $items.selectedIndex, anchor: .center)
            .frame(height: 320)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .onChange(of: items.selectedIndex, initial: false) {
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
        .environmentObject(MeetingData())
}
