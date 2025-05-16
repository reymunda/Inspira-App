import SwiftUI

struct EndMeetButton: View {
    @Binding var navigate: Bool
    @State private var offset: CGFloat = 0
    @State private var confirmed = false

    let buttonHeight: CGFloat = 60

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if confirmed {
                    RoundedRectangle(cornerRadius: buttonHeight / 2)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color("blue"), Color("neon")]),
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        ))
                        .frame(maxWidth: .infinity, minHeight: buttonHeight)
                        .overlay(
                            Text("Yay Finished!")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        )
                } else {
                    RoundedRectangle(cornerRadius: buttonHeight / 2)
                        .fill(.ultraThinMaterial)
                        .frame(maxWidth: .infinity, minHeight: buttonHeight)
                        .overlay(
                            Text("Swipe to Finish")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        )
                }

                HStack {
                    Circle()
                        .fill(confirmed ?
                              AnyShapeStyle(Color.white)
                              :
                              AnyShapeStyle(
                                  LinearGradient(
                                      gradient: Gradient(colors: [
                                          Color("grey2").opacity(1.0),
                                          Color("grey2").opacity(0.0)
                                      ]),
                                      startPoint: .top,
                                      endPoint: .bottom
                                  ))
)
                        .frame(width: buttonHeight - 10, height: buttonHeight - 10)
                        .overlay(
                            Image(systemName: confirmed ? "checkmark" : "chevron.right")
                                .foregroundColor(confirmed ? .green : .white)
                                .bold()
                                .scaleEffect(1.4)
                        )
                        .offset(x: offset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if !confirmed {
                                        offset = max(0, min(gesture.translation.width, geo.size.width - buttonHeight))
                                    }
                                }
                                .onEnded { _ in
                                    if offset > geo.size.width * 0.6 {
                                        confirmed = true
                                        offset = geo.size.width - buttonHeight

                                        // TRIGGER PINDAH HALAMAN
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            navigate = true
                                        }

                                    } else {
                                        offset = 0
                                    }
                                }
                        )
                        .animation(.easeInOut, value: confirmed)
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: buttonHeight)
                .padding(.horizontal, 5)
            }
        }
        .frame(height: buttonHeight)
    }
}



