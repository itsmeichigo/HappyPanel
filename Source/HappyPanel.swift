//
//  HappyPanel.swift
//  HappyPanel
//
//  Created by Huong Do on 8/25/20.
//  Copyright © 2020 ichigo. All rights reserved.
//

import SwiftUI

struct HappyPanel: View {
    
    @Binding var isOpen: Bool
    @Binding var selectedEmoji: Emoji?
    
    @State var calculatedOffsetY: CGFloat = Constants.halfOffset
    @State var lastOffsetY: CGFloat = Constants.halfOffset
    @State var isDraggingDown: Bool = false
    @State var currentCategory: String = Constants.firstSectionTitle
    @State var isSearching: Bool = false

    var offsetY: CGFloat {
        guard isOpen else { return Constants.hiddenOffset}
        return !isSearching ? calculatedOffsetY : Constants.fullOffset
    }
    
    var body: some View {
        ZStack {
            self.dimmedBackground
            
            MainContent(selectedEmoji: $selectedEmoji,
                        currentCategory: $currentCategory,
                        isEditing: $isSearching)
                .offset(y: offsetY)
                .animation(.interactiveSpring())
                .gesture(panelDragGesture)
                .onChange(of: offsetY) { value in
                    if value == Constants.hiddenOffset {
                        resetViews()
                    }
                }
                .onChange(of: selectedEmoji) { value in
                    if value != nil {
                        resetViews()
                    }
                }
            
            if isOpen, !isDraggingDown, !isSearching {
                self.sectionPicker
            }
        }
    }
    
    private var dimmedBackground: some View {
        Color.black.opacity(0.7)
            .edgesIgnoringSafeArea(.all)
            .opacity(isOpen ? 1 : 0)
            .animation(.easeIn)
    }
    
    private var sectionPicker: some View {
        VStack {
            Spacer()
            
            SectionIndexPicker(selectedSection: $currentCategory,
                               sections: EmojiStore.shared.allCategories)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
    }
    
    private var panelDragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                UIApplication.shared.endEditing()
                isDraggingDown = gesture.translation.height > 0
                calculatedOffsetY = max(gesture.translation.height + lastOffsetY, Constants.fullOffset)
            }
            .onEnded { gesture in
                calculatedOffsetY = max(gesture.translation.height + lastOffsetY, Constants.fullOffset)
                
                // magnet
                if isDraggingDown {
                    if calculatedOffsetY >= Constants.halfOffset {
                        calculatedOffsetY = Constants.halfOffset
                        isOpen = false
                    } else {
                        calculatedOffsetY = Constants.fullOffset
                        isDraggingDown = false
                    }
                } else {
                    calculatedOffsetY = Constants.fullOffset
                    isDraggingDown = false
                }
                
                lastOffsetY = calculatedOffsetY
            }
    }
    
    private func resetViews() {
        UIApplication.shared.endEditing()
        isOpen = false
        calculatedOffsetY = Constants.halfOffset
        lastOffsetY = calculatedOffsetY
        isDraggingDown = false
    }
}

struct HappyPanel_Previews: PreviewProvider {
    static var previews: some View {
        HappyPanel(isOpen: .constant(true),
                   selectedEmoji: .constant(nil))
    }
}
