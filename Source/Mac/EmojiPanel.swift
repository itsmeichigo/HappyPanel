//
//  EmojiPanel.swift
//  Peachy
//
//  Created by Huong Do on 9/7/20.
//

import SwiftUI
import Shared

struct EmojiPanel: View {
    @EnvironmentObject var sharedState: SharedState
    
    var emojiStore: EmojiStore
    var selectionHandler: (Emoji)->Void
    
    @State private var categoryUpdatedByOffset = false
    @ObservedObject private var settings = HappySettings.shared
    
    init(emojiStore: EmojiStore, selectionHandler: @escaping (Emoji)->Void) {
        self.emojiStore = emojiStore
        self.selectionHandler = selectionHandler
    }
    
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
                if settings.showingKaomojis {
                    self.kaomojiSections
                } else {
                    self.emojiSections
                }
                
                if sharedState.isSearching || !sharedState.keyword.isEmpty {
                    self.emojiResults
                }
            }
            
            if !sharedState.isSearching, sharedState.keyword.isEmpty,
               !settings.showingKaomojis {
                self.sectionPicker
            }
        }
        .background(Color.background)
        .cornerRadius(8)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var recentSection: some View {
        EmojiSection(
            title: SectionType.recent.rawValue,
            items: EmojiStore.fetchRecentList(),
            contentKeyPath: \.self) { emoji in
            guard let item = emojiStore.allEmojis.first(where: { $0.string == emoji }) else { return }
            self.selectionHandler(item)
        }
    }
    
    private var kaomojiSections: some View {
        List {
            if !EmojiStore.fetchRecentList().isEmpty {
                recentSection
            }
            
            ForEach(KaomojiTags.allCases.map { $0.rawValue }, id: \.self) { tag in
                EmojiSection(
                    title: tag.capitalized,
                    items: emojiStore.kaomojisByTag[tag]!,
                    contentKeyPath: \.string) {
                    self.selectionHandler($0)
                }
            }
        }
    }
    
    private var emojiSections: some View {
        ScrollViewReader { proxy in
            GeometryReader { geometry in
                List {
                    Group {
                        if !EmojiStore.fetchRecentList().isEmpty {
                            let category = SectionType.recent.rawValue
                            recentSection
                                .id(category)
                                .observeOffset(
                                    for: category,
                                    geometryProxy: geometry,
                                    sharedState: sharedState,
                                    updateHandler: {
                                        categoryUpdatedByOffset = true
                                    }
                                )
                        }
                        
                        ForEach(SectionType.defaultCategories.map { $0.rawValue }, id: \.self) { category in
                            EmojiSection(
                                title: category,
                                items: emojiStore.emojisByCategory[category]!,
                                contentKeyPath: \.string) {
                                self.selectionHandler($0)
                            }
                            .observeOffset(
                                for: category,
                                geometryProxy: geometry,
                                sharedState: sharedState,
                                updateHandler: {
                                    categoryUpdatedByOffset = true
                                }
                            )
                        }
                    }
                    .onChange(of: sharedState.currentCategory) { target in
                        guard !categoryUpdatedByOffset else {
                            return
                        }
                        proxy.scrollTo(target, anchor: .top)
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
                    Text("No \(settings.showingKaomojis ? "kaomoji" : "emoji") found for \"\(sharedState.keyword)\"")
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
                        contentKeyPath: \.string) {
                        self.selectionHandler($0)
                    }
                }
            }
        }
    }
    
    private var sectionPicker: some View {
        SectionIndexPicker(sections: displayedCategories) { categoryUpdatedByOffset = false }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .environmentObject(sharedState)
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
