//
//  Extensions.swift
//  HappyDemo
//
//  Created by Huong Do on 8/30/20.
//

import SwiftUI

#if os(iOS)
// MARK: Dismiss keyboard
public extension UIApplication {
    func endEditing() {
        windows.forEach { $0.endEditing(false) }
    }
}
#endif

public extension Color {
    static var background: Color {
        #if os(iOS)
        return Color(UIColor.systemBackground)
        #elseif os(macOS)
        return Color(NSColor.windowBackgroundColor)
        #endif
    }
}
