//
//  EmojiSection.swift
//  HappyPanel
//
//  Created by Huong Do on 8/28/20.
//

import SwiftUI

struct EmojiSection<T: Hashable>: View {
    var title: String
    var items: [T]
    var contentKeyPath: KeyPath<T, String>
    var completionHandler: (T) -> Void
    
    private let columns: [GridItem] =
             Array(repeating: .init(.flexible()), count: 6)
    
    var body: some View {
        Section(header: SectionHeader(title: title)) {
            LazyVGrid(columns: columns) {
                ForEach(items, id: contentKeyPath) { item in
                    Button(action: {
                        completionHandler(item)
                    }) {
                        Text(item[keyPath: contentKeyPath])
                            .font(.largeTitle)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(4)
                }
            }
        }
    }
}

struct EmojiSection_Previews: PreviewProvider {
    static var previews: some View {
        let store = EmojiStore()
        let testItems = Array(store.allEmojis.prefix(12))
        EmojiSection(title: "Test",
                     items: testItems,
                     contentKeyPath: \.emoji,
                     completionHandler: { _ in })
    }
}
