//
//  MainContent.swift
//  HappyDemo
//
//  Created by Huong Do on 8/30/20.
//

import SwiftUI

struct MainContent: View {
    @Binding var selectedEmoji: Emoji?
    @Binding var currentCategory: String
    @Binding var isEditing: Bool
    
    @State var keyword: String = ""
    var emojiStore = EmojiStore.shared
    
    var body: some View {
        VStack {
            self.indicator
            
            ZStack {
                Color.white
                
                VStack(spacing: 0) {
                    SearchBar(keyword: $keyword, isEditing: $isEditing)
                        .padding(16)
                    
                    self.separator
                    
                    ZStack {
                        self.emojiSections
                            .padding(.top, 16)
                        
                        if isEditing {
                            self.emojiResults
                        }
                    }
                }
            }
            .cornerRadius(8)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onChange(of: selectedEmoji) { value in
            if value != nil {
                keyword = ""
                isEditing = false
            }
        }
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
                ForEach(emojiStore.allCategories, id: \.self) { category in
                    EmojiSection(
                        selection: $selectedEmoji,
                        title: category,
                        items: emojiStore.emojisByCategory[category]!
                    )
                }
                .onChange(of: currentCategory) { target in
                    proxy.scrollTo(target, anchor: .top)
                }
            }
        }
    }
    
    private var emojiResults: some View {
        Group {
            if keyword.isEmpty {
                EmptyView()
            } else if emojiStore.filteredEmojis(with: keyword).isEmpty {
                ZStack {
                    Color.white
                    
                    VStack {
                        Text("No emoji results found for \"\(keyword)\"")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    
                }
                .padding(.horizontal, 16)
            } else {
                EmojiResultList(
                    selection: $selectedEmoji,
                    items: emojiStore.filteredEmojis(with: keyword)
                )
                .padding(.horizontal, 16)
            }
        }
    }
}

struct MainContent_Previews: PreviewProvider {
    static var previews: some View {
        MainContent(selectedEmoji: .constant(nil),
                    currentCategory: .constant(Constants.firstSectionTitle),
                    isEditing: .constant(false))
    }
}
