//
//  TagButton.swift
//  HappyMenuBar
//
//  Created by ichigo on 17/07/2021.
//

import SwiftUI

struct TagButton: View {
    let title: String
    let selectionHandler: () -> Void
    let isSelected: Bool
    
    var body: some View {
        Button(action: selectionHandler, label: {
            Text(title)
                .foregroundColor(isSelected ? .white : Color(NSColor.controlTextColor))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(isSelected ? Color(NSColor.controlAccentColor) : Color.background)
                .clipShape(Capsule())
        })
        .buttonStyle(PlainButtonStyle())
    }
}

struct TagButton_Previews: PreviewProvider {
    static var previews: some View {
        TagButton(title: "Recent", selectionHandler: {}, isSelected: false)
    }
}
