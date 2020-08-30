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
            self.indicator
            
            ZStack {
                Color.white
                
                VStack(spacing: 0) {
                    SearchBar()
                        .padding(16)
                        .environmentObject(sharedState)
                    
                    self.separator
                    
                    ZStack {
                        self.emojiSections
                            .padding(.top, 16)
                        
                        if sharedState.isSearching {
                            self.emojiResults
                        }
                    }
                }
            }
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
                ForEach(emojiStore.allCategories, id: \.self) { category in
                    EmojiSection(
                        title: category,
                        items: emojiStore.emojisByCategory[category]!
                    )
                    .environmentObject(sharedState)
                }
                .onChange(of: sharedState.currentCategory) { target in
                    proxy.scrollTo(target, anchor: .top)
                }
            }
        }
    }
    
    private var emojiResults: some View {
        Group {
            if sharedState.keyword.isEmpty {
                EmptyView()
            } else if emojiStore.filteredEmojis(with: sharedState.keyword).isEmpty {
                ZStack {
                    Color.white
                    
                    VStack {
                        Text("No emoji results found for \"\(sharedState.keyword)\"")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.top, 32)
                    
                }
                .padding(.horizontal, 16)
            } else {
                EmojiResultList(items: emojiStore.filteredEmojis(with: sharedState.keyword))
                    .padding(.horizontal, 16)
                    .environmentObject(sharedState)
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
