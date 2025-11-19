import SwiftUI

struct StoriesView: View {
    @State private var stories: [Story] = [
        Story(imageName: "story1", isViewed: false),
        Story(imageName: "story2", isViewed: false),
        Story(imageName: "story3", isViewed: false),
        Story(imageName: "story4", isViewed: false)
    ]
    @State private var selectedStory: Story? = nil

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(stories) { story in
                    Image(story.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 92, height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(story.isViewed ? Color.clear : Color("Blue_Universal"), lineWidth: 4)
                        )
                        .opacity(story.isViewed ? 0.5 : 1)

                        .onTapGesture {
                            selectedStory = story
                        }
                }
            }
            .padding(.horizontal, 16)
        }
        .fullScreenCover(item: $selectedStory) { story in
            if let index = stories.firstIndex(where: { $0.id == story.id }) {
                StoryFullScreenView(stories: $stories, selectedIndex: index)
            }
        }
    }
}

