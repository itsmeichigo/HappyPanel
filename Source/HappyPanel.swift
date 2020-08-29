//
//  HappyPanel.swift
//  HappyPanel
//
//  Created by Huong Do on 8/25/20.
//  Copyright © 2020 ichigo. All rights reserved.
//

import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    
    static let screenHeight = UIScreen.main.bounds.size.height
    static let maxHeight: CGFloat = screenHeight - 24
    static let midHeight: CGFloat = 400
    static let minHeight: CGFloat = 0
    
    static let halfOffset: CGFloat = maxHeight - midHeight
    static let fullOffset: CGFloat = 24
    static let hiddenOffset: CGFloat = screenHeight
}

struct HappyPanel: View {
    
    @Binding var selectedEmoji: Emoji?
    @Binding var isOpen: Bool
    
    @State private var keyword: String = ""
    @State private var offsetY: CGFloat = Constants.halfOffset
    @State private var lastOffsetY: CGFloat = Constants.halfOffset
    @State private var isDraggingDown: Bool = false
    @State private var currentCategory: String = "Smileys & Emotion"
        
    private let columns: [GridItem] =
             Array(repeating: .init(.flexible()), count: 6)
    private var emojiStore = EmojiStore()

    init(isOpen: Binding<Bool>,
         selectedEmoji: Binding<Emoji?>) {
        self._isOpen = isOpen
        self._selectedEmoji = selectedEmoji
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
                .opacity(isOpen ? 1 : 0)
                .animation(.easeIn)
            
            VStack {
                self.indicator
                
                ZStack {
                    Color.white
                    
                    VStack(spacing: 0) {
                        SearchBar(keyword: $keyword, focusHandler: {
                            self.offsetY = Constants.fullOffset
                        })
                        .padding(16)
                        
                        Color.gray
                            .opacity(0.2)
                            .frame(height: 1)
                            .padding(.bottom, 16)
                        
                        ZStack {
                            self.emojiSections
                            
                            if !keyword.isEmpty {
                                self.emojiResults
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                }
                .cornerRadius(Constants.radius)
            }
            .edgesIgnoringSafeArea(.bottom)
            .offset(y: isOpen ? offsetY : Constants.hiddenOffset)
            .animation(.interactiveSpring())
            .gesture(panelDragGesture)
            
            if isOpen, !isDraggingDown, keyword.isEmpty {
                self.sectionPicker
            }
        }
    }
    
    private var indicator: some View {
        Color.gray
            .frame(width: Constants.indicatorWidth,
                   height: Constants.indicatorHeight)
            .clipShape(Capsule())
    }
    
    private var emojiSections: some View {
        ScrollViewReader { proxy in
            List {
                if !emojiStore.recentEmojis.isEmpty {
                    EmojiSection(
                        selection: $selectedEmoji,
                        title: "Recent",
                        items: emojiStore.recentEmojis,
                        completionHandler: resetViews
                    )
                }
                
                ForEach(emojiStore.allCategories, id: \.self) { category in
                    EmojiSection(
                        selection: $selectedEmoji,
                        title: category,
                        items: emojiStore.emojisByCategory[category]!,
                        completionHandler: resetViews
                    )
                }
                .onChange(of: currentCategory) { target in
//                    withAnimation {
//                        proxy.scrollTo(target, anchor: .top)
//                    }
                }
            }
        }
    }
    
    private var sectionPicker: some View {
        VStack {
            Spacer()
            
            SectionIndexPicker(selectedSection: $currentCategory,
                               sections: emojiStore.allCategories)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
    }
    
    private var emojiResults: some View {
        Group {
            if emojiStore.filteredEmojis(with: keyword).isEmpty {
                ZStack {
                    Color.white
                    
                    VStack {
                        Text("No emoji results found for \"\(keyword)\"")
                        Spacer()
                    }
                    
                }
            } else {
                EmojiResultList(
                    selection: $selectedEmoji,
                    items: emojiStore.filteredEmojis(with: keyword),
                    completionHandler: resetViews
                )
            }
        }
    }
    
    private var panelDragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                UIApplication.shared.endEditing()
                self.isDraggingDown = gesture.translation.height > 0
                self.offsetY = max(gesture.translation.height + self.lastOffsetY, Constants.fullOffset)
            }
            .onEnded { gesture in
                self.offsetY = max(gesture.translation.height + self.lastOffsetY, Constants.fullOffset)
                
                // magnet
                if self.isDraggingDown {
                    if self.offsetY >= Constants.halfOffset {
                        self.offsetY = Constants.halfOffset
                        self.isOpen = false
                        self.resetViews()
                    } else {
                        self.offsetY = Constants.fullOffset
                        self.isDraggingDown = false
                    }
                } else {
                    self.offsetY = Constants.fullOffset
                    self.isDraggingDown = false
                }
                
                self.lastOffsetY = self.offsetY
            }
    }
    
    private func resetViews() {
        UIApplication.shared.endEditing()
        offsetY = Constants.halfOffset
        lastOffsetY = offsetY
        isDraggingDown = false
        isOpen = false
        keyword = ""
    }
}

struct HappyPanel_Previews: PreviewProvider {
    static var previews: some View {
        HappyPanel(isOpen: .constant(true),
                   selectedEmoji: .constant(nil))
    }
}

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        windows.forEach { $0.endEditing(false) }
    }
}
