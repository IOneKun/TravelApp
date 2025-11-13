import SwiftUI
import Combine

struct StoryFullScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var stories: [Story]
    @State var selectedIndex: Int
    
    @State private var progressValues: [CGFloat] = []
    @State private var timer: AnyCancellable?
    private let storyDuration: TimeInterval = 3.0
    
    var body: some View {
        ZStack {
            Image(stories[selectedIndex].imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.8)]),
                startPoint: .center,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                
                HStack(spacing: 6) {
                    ForEach(stories.indices, id: \.self) { i in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.5))
                                .frame(height: 6)
                            Capsule()
                                .fill(Color("Blue_Universal"))
                                .frame(width: progressWidth(for: i), height: 6)
                        }
                    }
                }
                .padding(.top, 35)
                .padding(.horizontal, 16)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Text Text Text Text Text Text Text Text Text Text Text Text Text Text")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    Text("Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(3)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            }
            
            HStack(spacing: 0) {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { previousStory() }
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { nextStory() }
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                        .frame(width: 333)
                    Button(action: dismissView) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("White_Universal"))
                            .padding(3)
                            .frame(width: 30, height: 30)
                            .background(Color("BLACK"))
                            .clipShape(Circle())
                    }
                    .padding(.top, 50)
                }
                Spacer()
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 {
                        nextStory()
                    } else if value.translation.width > 50 {
                        previousStory()
                    }
                }
        )
        .onAppear {
            setupProgress()
            startTimer()
            markViewed()
        }
        .onDisappear {
            timer?.cancel()
        }
    }
    
    private func setupProgress() {
        if progressValues.isEmpty {
            progressValues = Array(repeating: 0, count: stories.count)
        }
    }
    
    private func markViewed() {
        stories[selectedIndex].isViewed = true
    }
    
    private func progressWidth(for index: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width - 32 - CGFloat(stories.count - 1) * 6
        return screenWidth / CGFloat(stories.count) * (progressValues[safe: index] ?? 0)
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 0.03, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation(.linear(duration: 0.03)) {
                    progressValues[selectedIndex] += 0.03 / storyDuration
                    if progressValues[selectedIndex] >= 1 {
                        nextStory()
                    }
                }
            }
    }
    
    private func nextStory() {
        timer?.cancel()
        if selectedIndex < stories.count - 1 {
            
            progressValues[selectedIndex] = 1
        
            selectedIndex += 1
            markViewed()
        
            if progressValues[selectedIndex] >= 1 {
                progressValues[selectedIndex] = 0
            }
            
            startTimer()
        } else {
            dismissView()
        }
    }

    private func previousStory() {
        timer?.cancel()
        if selectedIndex > 0 {
            progressValues[selectedIndex] = 0
            
            selectedIndex -= 1
            
            progressValues[selectedIndex] = 0
            
            startTimer()
        } else {
            dismissView()
        }
    }

    
    private func dismissView() {
        timer?.cancel()
        dismiss()
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

