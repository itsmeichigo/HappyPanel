//
//  EmojiSection.swift
//  HappyPanel
//
//  Created by Huong Do on 8/28/20.
//

import SwiftUI

struct EmojiSection<T: Hashable>: View {
    var title: String
    var items: [[T]]
    var contentKeyPath: KeyPath<T, String>
    var completionHandler: (T) -> Void
    
    private let columns: [GridItem] =
             Array(repeating: .init(.flexible()), count: 6)
    
    var body: some View {
        Section(header: HeaderView(title: title)) {
            VStack(alignment: .leading) {
                ForEach(items, id: \.self) { row in
                    HStack {
                        ForEach(row, id: contentKeyPath) { item in
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
    }
}

struct HeaderView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(.gray)
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(FillAll(color: .white))
    }
}

// Hack to override default list section header background color 🤬
struct FillAll: View {
    let color: Color

    var body: some View {
        GeometryReader { proxy in
            self.color.frame(
                width: proxy.size.width * 3,
                height: proxy.size.height * 3
            )
        }
        .offset(x: -20, y: -20)
    }
}

struct EmojiSection_Previews: PreviewProvider {
    static var previews: some View {
        let store = EmojiStore()
        let testItems = [
            Array(store.allEmojis.prefix(7)),
            Array(store.allEmojis.suffix(5)),
        ]
        EmojiSection(title: "Test",
                     items: testItems,
                     contentKeyPath: \.emoji,
                     completionHandler: { _ in })
    }
}
