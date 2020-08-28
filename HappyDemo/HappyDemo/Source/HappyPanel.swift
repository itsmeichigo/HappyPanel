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
    static let midHeight: CGFloat = 350
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
    @State private var newOffsetY: CGFloat = Constants.halfOffset
        
    private let columns: [GridItem] =
             Array(repeating: .init(.flexible()), count: 6)
    private var emojiFinder = EmojiFinder()
    private var completionHandler: (() -> Void) {
        {
            UIApplication.shared.endEditing()
            offsetY = Constants.halfOffset
            newOffsetY = offsetY
            isOpen = false
            keyword = ""
        }
    }

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
                    
                    VStack {
                        SearchBar(keyword: $keyword, focusHandler: {
                            self.offsetY = Constants.fullOffset
                        })
                        
                        ZStack {
                            self.emojiGrid
                            
                            if !keyword.isEmpty {
                                self.emojiResult
                            }
                        }
                        
                    }
                    .padding(16)
                }
                .cornerRadius(Constants.radius)
            }
            .edgesIgnoringSafeArea(.bottom)
            .offset(y: isOpen ? offsetY : Constants.hiddenOffset)
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().onChanged { gesture in
                    UIApplication.shared.endEditing()
                    self.offsetY = max(gesture.translation.height + self.newOffsetY, Constants.fullOffset)
                }.onEnded { gesture in
                    self.offsetY = max(gesture.translation.height + self.newOffsetY, Constants.fullOffset)
                    
                    // magnet
                    // if scrolling down
                    if gesture.translation.height > 0 {
                        if self.offsetY >= Constants.halfOffset {
                            self.offsetY = Constants.halfOffset
                            self.isOpen = false
                        } else {
                            self.offsetY = Constants.fullOffset
                        }
                    } else {
                        self.offsetY = Constants.fullOffset
                    }
                    
                    self.newOffsetY = self.offsetY
                }
            )
        }
    }
    
    private var indicator: some View {
        Color.gray
            .frame(width: Constants.indicatorWidth,
                   height: Constants.indicatorHeight)
            .clipShape(Capsule())
    }
    
    private var emojiGrid: some View {
        ScrollView {
            if !emojiFinder.recentEmojis.isEmpty {
                EmojiGrid(
                    selection: $selectedEmoji,
                    title: "Recent",
                    items: emojiFinder.recentEmojis,
                    completionHandler: completionHandler
                )
            }
            
            ForEach(emojiFinder.allCategories, id: \.self) { category in
                EmojiGrid(
                    selection: $selectedEmoji,
                    title: category,
                    items: emojiFinder.emojisByCategory[category]!,
                    completionHandler: completionHandler
                )
            }
        }
    }
    
    private var emojiResult: some View {
        Group {
            if emojiFinder.filteredEmojis(with: keyword).isEmpty {
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
                    items: emojiFinder.filteredEmojis(with: keyword),
                    completionHandler: completionHandler
                )
            }
        }
        
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
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
