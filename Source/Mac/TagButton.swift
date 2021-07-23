//
//  TagButton.swift
//  HappyMenuBar
//
//  Created by ichigo on 17/07/2021.
//

import SwiftUI

struct TagButton: ViewModifier {    
    let isSelected: Bool
    
    func body(content: Content) -> some View {
        content
        .foregroundColor(isSelected ? .white : Color(NSColor.controlTextColor).opacity(0.5))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isSelected ? Color(NSColor.controlAccentColor) : Color.background)
        .clipShape(Capsule())
        .buttonStyle(PlainButtonStyle())
    }
}

extension Button {
    func makeTag(isSelected: Bool) -> some View {
        self.modifier(TagButton(isSelected: isSelected))
    }
}

struct TagButton_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}, label: {
            Text("Text")
        })
        .makeTag(isSelected: true)
    }
}
