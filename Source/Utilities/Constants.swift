//
//  Constants.swift
//  HappyDemo
//
//  Created by Huong Do on 8/30/20.
//

import UIKit

enum Constants {
    static let screenHeight = UIScreen.main.bounds.size.height
    static let maxHeight: CGFloat = screenHeight - 24
    static let midHeight: CGFloat = UIScreen.main.bounds.size.height / 2
    static let minHeight: CGFloat = 0
    
    static let halfOffset: CGFloat = maxHeight - midHeight
    static let fullOffset: CGFloat = 24
    static let hiddenOffset: CGFloat = screenHeight
    
    static let firstSectionTitle: String = "Smileys & Emotion"
}
