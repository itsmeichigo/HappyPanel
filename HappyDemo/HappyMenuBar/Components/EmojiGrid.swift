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
            let prefix = Array(itemsLeft.prefix(9))
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
                        ForEach(row, id: self.contentKeyPath) { item in
                            Button(action: {
                                self.completionHandler(item)
                            }) {
                                Text(item[keyPath: self.contentKeyPath])
                                    .font(.headline)
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
        EmojiGrid(title: "Test",
                  items: Array(EmojiStore().allEmojis.prefix(12)),
                  contentKeyPath: \.emoji,
                  completionHandler: { _ in })
    }
}
