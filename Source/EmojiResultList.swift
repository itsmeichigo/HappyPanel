//
//  EmojiResultList.swift
//  HappyPanel
//
//  Created by Huong Do on 8/28/20.
//

import SwiftUI

struct EmojiResultList: View {
    @EnvironmentObject var sharedState: SharedState
    
    var items: [Emoji]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(items, id: \.emoji) { item in
                    Button(action: {
                        self.sharedState.selectedEmoji = item
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
        EmojiResultList(items: Array(EmojiStore().allEmojis.prefix(5)))
            .environmentObject(SharedState())
    }
}
