import SwiftUI
import AVFoundation

struct MeetingResult: View {
    @State private var selectedTab = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var audioProgress: Double = 0.0
    @State private var isPlaying = false
    @State private var audioDuration: Double = 112.0
    @State private var player: AVAudioPlayer?
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium  // Bisa memilih style lain seperti .short atau .long
        formatter.timeStyle = .none
        return formatter.string(from: Date())
    }
    var body: some View {
        ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Dynamic Header
                        headerView
                        // Segmented control
                        
                        segmentedControl
                            .padding(.vertical, 0)
                            .padding(.horizontal, 20)

                        
                        // Content
                        if selectedTab == 0 {
                            summaryView
                                .padding(.horizontal, 20)

                        } else {
                            transcriptView
                                .padding(.horizontal, 20)
                        }
                        
                        Spacer().frame(height: 120) // Spacer for fixed audio player
                    }
                }
            
    
            // Fixed Audio Player with glassmorphism
            Image("dissolve")
              
            audioPlayerView
                .padding(.horizontal,20)
                .padding(.bottom, 36)
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        .onAppear {
            setupAudio()
        }
        .ignoresSafeArea()
    }

    var headerView: some View {
        // Header
        ZStack(alignment: .leading){
            Image("accent")
                .blur(radius: 200)
                .offset(x: -15, y: 200)
                .opacity(0.75)
//                .border(Color.blue, width: 2)
            Image("platonic")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.1)
                .offset(x: -10, y: 150)
                .opacity(0.35)
//                .border(Color.blue, width: 2)
            
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
//            .border(Color.blue, width: 2)
            
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        .frame(height: 250)
        .background(Color("surface"))
        .clipped()
//        .border(Color.blue, width: 2)
        
    }

    var segmentedControl: some View {
        HStack {
            Picker("", selection: $selectedTab) {
                Text("Summary").tag(0)
                Text("Transcript").tag(1)
            }
            .pickerStyle(.segmented)
        }
    }

    var summaryView: some View {
            VStack(alignment: .leading, spacing: 24) {
                summarySection(title: "Brain Dump", bullets: [
                    "Pengguna butuh pengiriman lebih cepat dan akurat.",
                    "Simplifikasi pengalaman pengguna agar nggak bingung pilih opsi.",
                    "Fitur untuk mengatur ulang waktu pengiriman sesuai kebutuhan pengguna."
                ])

                Divider()

                summarySection(title: "Share the Results to Stakeholders", bullets: [
                    "Stakeholder ingin aplikasi yang mempercepat pengiriman dan meminimalkan kesalahan.",
                    "Pengguna lebih suka sistem pembayaran yang cepat dan banyak opsi.",
                    "Fitur personalisasi berdasarkan kebiasaan pengguna."
                ])
                
            }
            .padding(.top,8)
            .padding(.bottom,60)
        }


    var transcriptView: some View {
        VStack(alignment: .leading, spacing: 24) {
            transcriptSection(title: "Brain Dump", description:
                "Oke, jadi pertama kita perlu fokus ke pengiriman yang lebih cepat dan lebih akurat. Banyak yang bilang mereka kadang gak ngerti dengan pilihan yang ada di aplikasi, jadi kita harus bisa menyederhanakan itu. Misalnya, buat fitur yang bisa ngatur ulang waktu pengiriman, biar pengguna bisa pilih kapan mereka mau terima barangnya."
            )
            
            Divider()
            
            transcriptSection(title: "Share the Results to Stakeholders", description: "Setelah ide-ide itu keluar, kita perlu berbagi hasilnya ke stakeholder biar mereka tahu arah yang kita ambil. Mereka lebih peduli sama pengiriman yang lebih cepat dan pastiin nggak ada kesalahan. Selain itu, mereka juga bilang sistem pembayaran harus lebih mudah dan banyak pilihan supaya lebih fleksibel.Tapi, menurut mereka, yang paling menarik itu fitur yang personalisasi. Misalnya, kalau kita bisa kasih rekomendasi berdasarkan kebiasaan pengguna, itu bakal lebih menarik.")

            Divider()
            
            transcriptSection(title: "Brainstorming", description: "Untuk pelacakan, kita harus lebih detail. Pengguna butuh estimasi waktu yang lebih akurat. Jadi kalau misalnya ada delay, mereka bisa tau lebih pasti kapan barang sampai")
        }
        .padding(.top,8)
        .padding(.bottom,60)
    }

    func summarySection(title: String, bullets: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color("black"))

            ForEach(bullets, id: \.self) { bullet in
                HStack(alignment: .top, spacing: 8) {
                    Text("•").font(.body)
                    Text(bullet).font(.callout)
                        .foregroundColor(Color("black"))
                }
            }
        }
    }
    
    func transcriptSection(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color("black"))
            Text(description)
                .font(.callout)
                .foregroundColor(Color("black"))
                }
            }
        
    

    var audioPlayerView: some View {
        ZStack {
            // Glassmorphic background
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .background(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("white"), Color("surface")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)


            VStack(spacing: 12) {
                // Top labels
                HStack {
                    Text("Recording Result")
                        .font(.caption)
                        .foregroundColor(Color("black"))

                    Spacer()

                    Text("Duration 1:52 min")
                        .font(.caption)
                        .foregroundColor(Color("black"))
                }

                // Progress bar
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 4)

                    Capsule()
                        .fill(Color("blue"))
                        .frame(width: CGFloat(audioProgress) * UIScreen.main.bounds.width * 0.7, height: 4)
                }

                // Time & Controls
                HStack {
                    Text(timeString(from: player?.currentTime ?? 0))
                        .font(.caption)
                        .foregroundColor(Color("black"))

                    Spacer()

                    HStack(spacing: 28) {
                        Button(action: {
                            player?.currentTime = max((player?.currentTime ?? 0) - 10, 0)
                        }) {
                            Image(systemName: "backward.fill")
                                .foregroundColor(Color("black"))
                                .scaleEffect(1.2)
                        }

                        Button(action: togglePlayback) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color("blue"), Color("neon")]),
                                                startPoint: .topTrailing,
                                                endPoint: .bottomLeading
                                            )
                                        )
                                )
                        }

                        Button(action: {
                            player?.currentTime = min((player?.currentTime ?? 0) + 10, audioDuration)
                        }) {
                            Image(systemName: "forward.fill")
                                .foregroundColor(Color("black"))
                                .scaleEffect(1.2)
                        }
                    }

                    Spacer()

                    Text(timeString(from: audioDuration))
                        .font(.caption)
                        .foregroundColor(Color("black"))
                }
            }
            .padding()
        }
        .frame(height: 120)
        
    }


    func togglePlayback() {
        guard let player = player else { return }

        if isPlaying {
            player.pause()
        } else {
            player.play()
            startProgressUpdate()
        }
        isPlaying.toggle()
    }

    func startProgressUpdate() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if let player = player {
                audioProgress = player.currentTime / audioDuration
                if player.currentTime >= audioDuration {
                    isPlaying = false
                    timer.invalidate()
                }
            } else {
                timer.invalidate()
            }
        }
    }

    func setupAudio() {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "mp3") else { return }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            audioDuration = player?.duration ?? 112
        } catch {
            print("Failed to load audio")
        }
    }

    func timeString(from seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    MeetingResult()
}
