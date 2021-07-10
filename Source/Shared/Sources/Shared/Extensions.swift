//
//  Extensions.swift
//  HappyDemo
//
//  Created by Huong Do on 8/30/20.
//

import SwiftUI

public extension Color {
    static var background: Color {
        #if os(iOS)
        return Color(UIColor.systemBackground)
        #elseif os(macOS)
        return Color(NSColor.windowBackgroundColor)
        #endif
    }
}
