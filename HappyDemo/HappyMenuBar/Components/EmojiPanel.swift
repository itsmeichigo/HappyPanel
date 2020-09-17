//
//  EmojiPanel.swift
//  Peachy
//
//  Created by Huong Do on 9/7/20.
//

import SwiftUI

struct EmojiPanel: View {
    @EnvironmentObject var sharedState: SharedState
    
    var emojiStore: EmojiStore
    var selectionHandler: (Emoji)->Void
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar()
                .environmentObject(sharedState)
            
            ZStack {
                self.emojiSections
                
                if sharedState.isSearching || !sharedState.keyword.isEmpty {
                    self.emojiResults
                }
            }
        }
        .background(Color.background)
        .cornerRadius(8)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var emojiSections: some View {
        List {
            Group {
                if !EmojiStore.fetchRecentList().isEmpty {
                    EmojiGrid(
                        title: SectionType.recent.rawValue,
                        items: EmojiStore.fetchRecentList(),
                        contentKeyPath: \.self) { emoji in
                            guard let item = self.emojiStore.allEmojis.first(where: { $0.emoji == emoji }) else { return }
                        self.sharedState.selectedEmoji = item
                        self.selectionHandler(item)
                    }
                    .id(SectionType.recent.rawValue)
                }
                
                ForEach(SectionType.defaultCategories.map { $0.rawValue }, id: \.self) { category in
                    EmojiGrid(
                        title: category,
                        items: self.emojiStore.emojisByCategory[category]!,
                        contentKeyPath: \.emoji) {
                        self.sharedState.selectedEmoji = $0
                        self.selectionHandler($0)
                    }
                }
            }
        }
    }
    
    private var emojiResults: some View {
        Group {
            if sharedState.keyword.isEmpty {
                EmptyView()
            } else if emojiStore.filteredEmojis(with: sharedState.keyword).isEmpty {
                
                VStack {
                    Text("No emoji results found for \"\(sharedState.keyword)\"")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.top, 32)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.background)
                
            } else {
                List {
                    EmojiGrid(
                        title: "Search Results",
                        items: emojiStore.filteredEmojis(with: sharedState.keyword),
                        contentKeyPath: \.emoji) {
                        self.sharedState.selectedEmoji = $0
                        self.selectionHandler($0)
                    }
                }
            }
        }
    }
}

struct EmojiPanel_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPanel(emojiStore: EmojiStore.shared,
                   selectionHandler: { _ in })
            .environmentObject(SharedState())
    }
}
