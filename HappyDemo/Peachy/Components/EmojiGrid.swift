//
//  EmojiGrid.swift
//  Peachy
//
//  Created by Huong Do on 9/7/20.
//

import SwiftUI

struct EmojiGrid<T: Hashable>: View {
    var title: String
    var items: [T]
    var contentKeyPath: KeyPath<T, String>
    var completionHandler: (T) -> Void
    
    private var itemGroups: [[T]] {
       getItemGroups(from: items)
    }
    
    private func getItemGroups<T>(from items: [T]) -> [[T]] {
        var groups: [[T]] = []
        var itemsLeft: [T] = items
        
        while !itemsLeft.isEmpty {
            let prefix = Array(itemsLeft.prefix(6))
            groups.append(prefix)
            itemsLeft.removeSubrange(0..<prefix.count)
        }
        
        return groups
    }
    
    var body: some View {
        Section(header: SectionHeader(title: title)) {
            VStack(alignment: .leading) {
                ForEach(itemGroups, id: \.self) { row in
                    HStack {
                        ForEach(row, id: contentKeyPath) { item in
                            Button(action: {
                                completionHandler(item)
                            }) {
                                Text(item[keyPath: contentKeyPath])
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(4)
                        }
                        .padding(4)
                    }
                }
            }
        }
    }
}

struct EmojiGrid_Previews: PreviewProvider {
    static var previews: some View {
        let store = EmojiStore()
        let testItems = Array(store.allEmojis.prefix(12))
        EmojiGrid(title: "Test",
                  items: testItems,
                  contentKeyPath: \.emoji,
                  completionHandler: { _ in })
    }
}
