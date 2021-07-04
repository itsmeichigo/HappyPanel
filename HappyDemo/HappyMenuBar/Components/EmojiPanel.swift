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
            HStack(spacing: 2) {
                SearchBar()
                    .environmentObject(sharedState)
                
                MainMenu()
            }
            .font(.title3)
            .foregroundColor(Color(NSColor.textColor))
            .padding(.trailing, 8)
            
            ZStack {
                self.emojiSections
                
                if sharedState.isSearching || !sharedState.keyword.isEmpty {
                    self.emojiResults
                }
            }
            
            if !sharedState.isSearching, sharedState.keyword.isEmpty {
                self.sectionPicker
            }
        }
        .background(Color.background)
        .cornerRadius(8)
        .edgesIgnoringSafeArea(.bottom)
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
                            self.selectionHandler(item)
                        }
                        .id(SectionType.recent.rawValue)
                    }
                    
                    ForEach(SectionType.defaultCategories.map { $0.rawValue }, id: \.self) { category in
                        EmojiSection(
                            title: category,
                            items: emojiStore.emojisByCategory[category]!,
                            contentKeyPath: \.emoji) {
                            self.selectionHandler($0)
                        }
                    }
                }
                .onChange(of: sharedState.currentCategory) { target in
                    proxy.scrollTo(target, anchor: .top)
                }
                
                Color.background
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
                .background(Color.background)
                
            } else {
                List {
                    EmojiSection(
                        title: "Search Results",
                        items: emojiStore.filteredEmojis(with: sharedState.keyword),
                        contentKeyPath: \.emoji) {
                        self.selectionHandler($0)
                    }
                }
            }
        }
    }
    
    private var sectionPicker: some View {
        SectionIndexPicker(sections: displayedCategories)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .environmentObject(sharedState)
            .background(Blur())
    }
    
    private var displayedCategories: [String] {
        if EmojiStore.fetchRecentList().isEmpty {
            return SectionType.defaultCategories.map { $0.rawValue }
        }
        return SectionType.allCases.map { $0.rawValue }
    }
}

struct EmojiPanel_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPanel(emojiStore: EmojiStore.shared,
                   selectionHandler: { _ in })
            .environmentObject(SharedState())
    }
}
