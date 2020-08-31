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
}

enum SectionType: String, CaseIterable {
    case recent = "Recent"
    case smileys = "Smileys & Emotion"
    case people = "People & Body"
    case animals = "Animals & Nature"
    case food = "Food & Drink"
    case travel = "Travel & Places"
    case activities = "Activities"
    case objects = "Objects"
    case symbols = "Symbols"
    case flags = "Flags"
    
    static let allCategories: [String] = SectionType.allCases
        .filter { $0 != .recent }
        .map { $0.rawValue }
}
