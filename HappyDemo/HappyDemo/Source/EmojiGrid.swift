//
//  EmojiGrid.swift
//  HappyPanel
//
//  Created by Huong Do on 8/28/20.
//

import SwiftUI

struct EmojiGrid: View {
    @Binding var selection: Emoji?
    var title: String
    var items: [Emoji]
    var completionHandler: (() -> Void)
    
    private let columns: [GridItem] =
             Array(repeating: .init(.flexible()), count: 6)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .foregroundColor(.gray)
            
            LazyVGrid(columns: columns) {
                ForEach(items, id: \.emoji) { item in
                    Button(action: {
                        self.selection = item
                        self.completionHandler()
                    }) {
                        Text(item.emoji)
                            .font(.largeTitle)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(.vertical, 16)
    }
}

struct EmojiGrid_Previews: PreviewProvider {
    static var previews: some View {
        EmojiGrid(selection: .constant(nil),
                  title: "Test",
                  items: Array(EmojiFinder().allEmojis.prefix(18)),
                  completionHandler: {})
    }
}
