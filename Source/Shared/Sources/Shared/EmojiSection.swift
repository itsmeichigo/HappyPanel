//
//  EmojiSection.swift
//  HappyPanel
//
//  Created by Huong Do on 8/28/20.
//

import SwiftUI

public struct EmojiSection<T: Hashable>: View {
    private var title: String
    private var items: [T]
    private var contentKeyPath: KeyPath<T, String>
    private var completionHandler: (T) -> Void
    
    private var columns: [GridItem] {
        Array(repeating: .init(.flexible()), count: columnCount)
    }
    
    private var columnCount: Int {
        UserDefaults.showingKaomojis ? 3 : 6
    }
    
    public init(title: String, items: [T], contentKeyPath: KeyPath<T, String>, completionHandler: @escaping (T) -> Void) {
        self.title = title
        self.items = items
        self.contentKeyPath = contentKeyPath
        self.completionHandler = completionHandler
    }

    public var body: some View {
        Section(header: SectionHeader(title: title)) {
            LazyVGrid(columns: columns) {
                ForEach(items, id: contentKeyPath) { item in
                    Button(action: {
                        completionHandler(item)
                    }) {
                        if UserDefaults.showingKaomojis {
                            kaomojiItem(content: item[keyPath: contentKeyPath])
                        } else {
                            emojiItem(content: item[keyPath: contentKeyPath])
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(4)
                }
            }
        }
    }
    
    private func emojiItem(content: String) -> some View {
        Text(content)
            .font(.largeTitle)
    }
    
    private func kaomojiItem(content: String) -> some View {
        Text(content)
            .padding(8)
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.background)
            )
    }
}

struct EmojiSection_Previews: PreviewProvider {
    static var previews: some View {
        let store = EmojiStore()
        let testItems = Array(store.allEmojis.prefix(12))
        EmojiSection(title: "Test",
                     items: testItems,
                     contentKeyPath: \.string,
                     completionHandler: { _ in })
    }
}
