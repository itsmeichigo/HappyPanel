//
//  ContentView.swift
//  HappyDemo
//
//  Created by Huong Do on 8/28/20.
//

import SwiftUI
import Shared

struct ContentView: View {
    @State var selectedEmoji: Emoji?
    @State var isShowingEmojiPanel = false
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 40) {
                Text("How do you feel today?")
                    .font(.largeTitle)
                
                selectedEmoji.map {
                    Text($0.string)
                        .font(Font.system(size: 40))
                }
                
                Button(action: {
                    self.isShowingEmojiPanel.toggle()
                }) {
                    Text("Choose reaction")
                }
            }
            .offset(y: -150)
            
            HappyPanel(isOpen: $isShowingEmojiPanel,
                       selectedEmoji: $selectedEmoji)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
