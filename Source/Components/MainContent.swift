//
//  MainContent.swift
//  HappyDemo
//
//  Created by Huong Do on 8/30/20.
//

import SwiftUI

struct MainContent: View {
    @EnvironmentObject var sharedState: SharedState
    
    var emojiStore = EmojiStore.shared
    
    var body: some View {
        VStack {
            
            #if os(iOS)
            self.indicator
            #endif
            
            VStack(spacing: 0) {
                SearchBar()
                    .padding(16)
                    .environmentObject(sharedState)
                
                self.separator
                
                ZStack {
                    self.emojiSections
                    
                    if sharedState.isSearching || !sharedState.keyword.isEmpty {
                        self.emojiResults
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var indicator: some View {
        Color.gray
            .frame(width: 60, height: 6)
            .clipShape(Capsule())
    }
    
    private var separator: some View {
        Color.gray
            .opacity(0.2)
            .frame(height: 1)
    }
    
    private var emojiSections: some View {
        ScrollViewReader { proxy in
            List {
                Group {
                    if !EmojiStore.fetchRecentList().isEmpty {
                        EmojiSection(
                            title: SectionType.recent.rawValue,
                            items: EmojiStore.fetchRecentList(),
                            contentKeyPath: \.self) { emoji in
                            guard let item = emojiStore.allEmojis.first(where: { $0.emoji == emoji }) else { return }
                            self.sharedState.selectedEmoji = item
                        }
                        .id(SectionType.recent.rawValue)
                    }
                    
                    ForEach(SectionType.allCategories, id: \.self) { category in
                        EmojiSection(
                            title: category,
                            items: emojiStore.emojisByCategory[category]!,
                            contentKeyPath: \.emoji) {
                            self.sharedState.selectedEmoji = $0
                        }
                    }
                }
                .onChange(of: sharedState.currentCategory) { target in
                    proxy.scrollTo(target, anchor: .top)
                }
                
                Color(UIColor.systemBackground)
                    .frame(height: 24)
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
                .background(Color(UIColor.systemBackground))
                
            } else {
                List {
                    EmojiSection(
                        title: "Search Results",
                        items: emojiStore.filteredEmojis(with: sharedState.keyword),
                        contentKeyPath: \.emoji) {
                        self.sharedState.selectedEmoji = $0
                    }
                    .background(Color(UIColor.systemBackground))
                }
            }
        }
    }
}

struct MainContent_Previews: PreviewProvider {
    static var previews: some View {
        MainContent()
            .environmentObject(SharedState())
    }
}
