//
//  EmojiResultList.swift
//  HappyPanel
//
//  Created by Huong Do on 8/28/20.
//

import SwiftUI

struct EmojiResultList: View {
    @Binding var selection: Emoji?
    var items: [Emoji]
    var completionHandler: (() -> Void)
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(items, id: \.emoji) { item in
                    Button(action: {
                        self.selection = item
                        self.completionHandler()
                    }) {
                        HStack {
                            Text(item.emoji)
                                .font(.largeTitle)
                            
                            Text(item.description)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .background(Color.white)
        .gesture(DragGesture().onChanged { _ in
            UIApplication.shared.endEditing()
        })
    }
}

struct EmojiResultList_Previews: PreviewProvider {
    static var previews: some View {
        EmojiResultList(selection: .constant(nil),
                        items: Array(EmojiStore().allEmojis.prefix(5)),
                        completionHandler: {})
    }
}
