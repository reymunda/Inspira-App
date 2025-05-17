import SwiftUI

struct MeetingSession: View {
    @EnvironmentObject var meetingData: MeetingData
    
    @State private var draggedItem: MeetingSection?
    @State private var editingItem: MeetingSection? // Edit session
    @State private var addingItem: MeetingSection? // Add new session
    @State private var editTitle: String = ""
    @State private var addTitle: String = ""
    @State private var editTime: String = ""
    @State private var selectedMinute: Int = 0
    @State private var selectedSecond: Int = 0
    @State private var isRecording = false
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium  // Bisa memilih style lain seperti .short atau .long
        formatter.timeStyle = .none
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack {
            // Header
            ZStack {
                Image("accent")
                    .blur(radius: 200)
                    .offset(x: -15, y: 200)
                    .opacity(0.75)
                Image("platonic")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.1)
                    .offset(x: 150, y: 150)
                    .opacity(0.35)
                
                VStack(alignment: .leading, spacing: 16) {
                    Spacer()
                    Text("Let’s Sync on What Cooked This Meeting!")
                        .font(.title2)
                        .bold()
                        .lineSpacing(8)
                        .padding(.top)
                        .foregroundColor(Color("black"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Color("grey"))
                        Text(getFormattedDate())
                            .foregroundColor(.gray)
                    }
                    .padding(8)
                    .background()
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .frame(height: 250)
                .padding(.top, 24)
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 250)
            .background(Color("surface"))
            .clipped()
            
            // Subtitle
            HStack {
                Text("What you wanna discuss?")
                    .foregroundColor(Color("grey"))
                Spacer()
                Button(action: {
                    addingItem = MeetingSection(title: "", session: "", time: "00:00", note: "No notes yet") // Trigger Add New Session sheet
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add Section")
                    }
                    .foregroundColor(Color("primary"))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)

            // Custom Drag & Drop List with Swipe
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(meetingData.sections) { section in
                        SwipeableCardView(
                            section: section,
                            onDelete: {
                                withAnimation {
                                    meetingData.sections.removeAll { $0.id == section.id }
                                }
                            },
                            onEdit: {
                                editingItem = section // Edit button now triggers the edit session
                                editTitle = section.title
                                let components = section.time.split(separator: ":")
                                if components.count == 2,
                                   let minutes = Int(components[0]),
                                   let seconds = Int(components[1]) {
                                    selectedMinute = minutes
                                    selectedSecond = seconds
                                }
                            }
                        )
                        .onDrag {
                            self.draggedItem = section
                            return NSItemProvider(object: section.title as NSString)
                        }
                        .onDrop(of: [.text], delegate: DropViewDelegate(item: section, sections: $meetingData.sections, draggedItem: $draggedItem))

                    }
                }
                .padding(.horizontal, 20)
            }
            
            // Start Meeting Button
            Button(action: {
                isRecording.toggle()
            }) {
                Text("Start Meeting")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("primary"))
                    .foregroundColor(.white)
                    .cornerRadius(24)
                    .padding(.horizontal)
            }
            .padding(.bottom)
            .padding()
        }
        .ignoresSafeArea()

        // Add New Session Sheet
        .sheet(item: $addingItem) { _ in
            VStack(alignment: .leading, spacing: 20) {
                Text("Add New Session")
                    .font(.headline)
                    .foregroundColor(Color("black"))
                    .padding(.top)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Subtopic")
                        .font(.subheadline)
                        .foregroundColor(Color("grey"))
                    TextField("e.g: Brainstorming app ideas", text: $addTitle)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Duration")
                        .font(.subheadline)
                        .foregroundColor(Color("grey"))

                    HStack(spacing: 0) {
                        Picker("Minutes", selection: $selectedMinute) {
                            ForEach(0..<60, id: \.self) {
                                Text("\($0) min")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity)

                        Picker("Seconds", selection: $selectedSecond) {
                            ForEach(0..<60, id: \.self) {
                                Text("\($0) sec")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 100)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }

                Button(action: {
                    let newSession = MeetingSection(
                        title: addTitle,
                        session: "Session \(meetingData.sections.count + 1)", // auto-generate session number
                        time: String(format: "%02d:%02d", selectedMinute, selectedSecond), note: "No notes yet"
                    )
                    meetingData.sections.append(newSession) // Add the new session to the list
                    addingItem = nil // Dismiss the sheet
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("primary"))
                        .foregroundColor(.white)
                        .cornerRadius(24)
                }
                .padding(.top, 6)
                
                Button("Cancel") {
                    addingItem = nil // Dismiss the sheet
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("primary"))
            }
            .padding(24)
            .presentationDetents([.height(430)])
            .presentationDragIndicator(.visible)
        }
        
        // Edit Session Sheet
        .sheet(item: $editingItem) { _ in
            VStack(alignment: .leading, spacing: 20) {
                Text("Edit Session")
                    .font(.headline)
                    .foregroundColor(Color("black"))
                    .padding(.top)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Subtopic")
                        .font(.subheadline)
                        .foregroundColor(Color("grey"))
                    TextField("e.g: Brainstorming app ideas", text: $editTitle)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Duration")
                        .font(.subheadline)
                        .foregroundColor(Color("grey"))

                    HStack(spacing: 0) {
                        Picker("Minutes", selection: $selectedMinute) {
                            ForEach(0..<60, id: \.self) {
                                Text("\($0) min")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity)

                        Picker("Seconds", selection: $selectedSecond) {
                            ForEach(0..<60, id: \.self) {
                                Text("\($0) sec")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 100)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }

                Button(action: {
                    if let editedSection = editingItem {
                        // Update the existing section
                        if let index = meetingData.sections.firstIndex(where: { $0.id == editedSection.id }) {
                            meetingData.sections[index].title = editTitle
                            meetingData.sections[index].time = String(format: "%02d:%02d", selectedMinute, selectedSecond)
                        }
                    }
                    editingItem = nil // Dismiss the sheet
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("primary"))
                        .foregroundColor(.white)
                        .cornerRadius(24)
                }
                .padding(.top, 6)
                
                Button("Cancel") {
                    editingItem = nil // Dismiss the sheet
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("primary"))
            }
            .padding(24)
            .presentationDetents([.height(430)])
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $isRecording) {
            Recording()
        }
    }
}



struct DropViewDelegate: DropDelegate {
    let item: MeetingSection
    @Binding var sections: [MeetingSection]
    @Binding var draggedItem: MeetingSection?

    func performDrop(info: DropInfo) -> Bool {
        self.draggedItem = nil
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem else { return }
        if draggedItem == item { return }

        if let fromIndex = sections.firstIndex(of: draggedItem),
           let toIndex = sections.firstIndex(of: item) {
            withAnimation {
                sections.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
            }
        }
    }
}
struct SwipeableCardView: View {
    let section: MeetingSection
    var onDelete: () -> Void
    var onEdit: () -> Void
    
    @State private var offsetX: CGFloat = 0
    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        ZStack {
            HStack {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                Spacer()
                Button(action: onDelete) {
                    HStack {
                        Image(systemName: "trash")
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)

            HStack {
                VStack(alignment: .leading) {
                    Text(section.title)
                        .font(.body.bold())
                        .foregroundColor(Color("black"))
                    Text("\(section.session) ・ \(section.time)")
                        .font(.caption)
                        .foregroundColor(Color("grey"))
                }
                Spacer()
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(Color("grey"))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color.white).stroke(LinearGradient(
                    gradient: Gradient(colors: [Color("blue"), Color("primary")]),
                    startPoint: .trailing,
                    endPoint: .leading
                ), lineWidth: 1))
            .offset(x: offsetX + dragOffset.width)
            .gesture(
                DragGesture()
                    .updating($dragOffset, body: { value, state, _ in
                        state = value.translation
                    })
                    .onEnded { value in
                        withAnimation {
                            if value.translation.width < -80 {
                                offsetX = -80 // Show Delete
                            } else if value.translation.width > 80 {
                                offsetX = 80 // Show Edit
                            } else {
                                offsetX = 0
                            }
                        }
                    }
            )
        }
    }
}

#Preview{
    MeetingSession()
        .environmentObject(MeetingData())

}
