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
    
    @State private var categoryUpdatedByOffset = false
    
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
            GeometryReader { geometry in
                List {
                    Group {
                        if !EmojiStore.fetchRecentList().isEmpty {
                            let category = SectionType.recent.rawValue
                            EmojiSection(
                                title: SectionType.recent.rawValue,
                                items: EmojiStore.fetchRecentList(),
                                contentKeyPath: \.self) { emoji in
                                guard let item = emojiStore.allEmojis.first(where: { $0.emoji == emoji }) else { return }
                                self.selectionHandler(item)
                            }
                            .id(category)
                            .transformAnchorPreference(key: OffsetKey.self, value: .bounds) {
                                $0.append(OffsetViewFrame(id: category, frame: geometry[$1]))
                            }
                            .onPreferenceChange(OffsetKey.self) {
                                guard sharedState.currentCategory != category else {
                                    return
                                }
                                if let item = $0.filter({ $0.id == category }).last,
                                   item.frame.origin.y <= 0,
                                   abs(item.frame.origin.y) < abs(item.frame.size.height) {
                                    categoryUpdatedByOffset = true
                                    sharedState.currentCategory = category
                                }
                            }
                        }
                        
                        ForEach(SectionType.defaultCategories.map { $0.rawValue }, id: \.self) { category in
                            EmojiSection(
                                title: category,
                                items: emojiStore.emojisByCategory[category]!,
                                contentKeyPath: \.emoji) {
                                self.selectionHandler($0)
                            }
                            .transformAnchorPreference(key: OffsetKey.self, value: .bounds) {
                                $0.append(OffsetViewFrame(id: category, frame: geometry[$1]))
                            }
                            .onPreferenceChange(OffsetKey.self) {
                                guard sharedState.currentCategory != category else {
                                    return
                                }
                                if let item = $0.filter({ $0.id == category }).last,
                                   item.frame.origin.y <= 0,
                                   abs(item.frame.origin.y) < abs(item.frame.size.height) {
                                    categoryUpdatedByOffset = true
                                    sharedState.currentCategory = category
                                }
                            }
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

struct OffsetViewFrame: Equatable {
    let id: String
    let frame: CGRect

    static func == (lhs: OffsetViewFrame, rhs: OffsetViewFrame) -> Bool {
        lhs.id == rhs.id && lhs.frame == rhs.frame
    }
}

struct OffsetKey: PreferenceKey {
    typealias Value = [OffsetViewFrame] // The list of view frame changes in a View tree.

    static var defaultValue: [OffsetViewFrame] = []

    /// When traversing the view tree, Swift UI will use this function to collect all view frame changes.
    static func reduce(value: inout [OffsetViewFrame], nextValue: () -> [OffsetViewFrame]) {
        value.append(contentsOf: nextValue())
    }
}
