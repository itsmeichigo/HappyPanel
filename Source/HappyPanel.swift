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
    
    @ObservedObject var sharedState = SharedState()
    
    var offsetY: CGFloat {
        guard isOpen else { return Constants.hiddenOffset }
        if sharedState.isSearching {
            DispatchQueue.main.async {
                self.calculatedOffsetY = Constants.fullOffset
                self.lastOffsetY = Constants.fullOffset
            }
            
            return lastOffsetY
        }
        
        return calculatedOffsetY
    }
    
    var body: some View {
        ZStack {
            self.dimmedBackground
                .onTapGesture {
                    resetViews()
                }
            
            MainContent()
                .offset(y: offsetY)
                .animation(.spring())
                .gesture(panelDragGesture)
                .onChange(of: sharedState.selectedEmoji) { value in
                    if let value = value {
                        selectedEmoji = value
                        EmojiStore.saveRecentEmoji(value)
                        resetViews()
                    }
                }
                .environmentObject(sharedState)
            
            if isOpen, !isDraggingDown, !sharedState.isSearching, sharedState.keyword.isEmpty {
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
    
    private var displayedCategories: [String] {
        if EmojiStore.fetchRecentList().isEmpty {
            return SectionType.allCategories
        }
        return SectionType.allCases.map { $0.rawValue }
    }
    
    private var sectionPicker: some View {
        VStack {
            Spacer()
            
            SectionIndexPicker(sections: displayedCategories)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .environmentObject(sharedState)
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
                if isDraggingDown,
                   calculatedOffsetY >= Constants.halfOffset {
                    calculatedOffsetY = Constants.hiddenOffset
                    resetViews()
                } else {
                    calculatedOffsetY = Constants.fullOffset
                }
                
                lastOffsetY = calculatedOffsetY
                isDraggingDown = false
            }
    }
    
    private func resetViews() {
        UIApplication.shared.endEditing()
        calculatedOffsetY = Constants.halfOffset
        lastOffsetY = calculatedOffsetY
        isOpen = false
        sharedState.resetState()
    }
}

struct HappyPanel_Previews: PreviewProvider {
    static var previews: some View {
        HappyPanel(isOpen: .constant(true),
                   selectedEmoji: .constant(nil))
    }
}
