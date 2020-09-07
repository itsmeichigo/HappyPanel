//
//  Emoji.swift
//  EmojiApp
//
//  Created by Huong Do on 8/25/20.
//

import Foundation

struct Emoji: Decodable, Hashable {
    let emoji: String
    let category: String
    let description: String
    let aliases: [String]
    let tags: [String]
}

final class EmojiStore {
    let allEmojis: [Emoji]
    let emojisByCategory: [String: [Emoji]]
    
    static let shared = EmojiStore()
    private static let recentEmojiKey: String = "HappyPanelRecentEmojis"
    private static let itemPerGroup: Int = 7
    
    init() {
        guard let path = Bundle.main.path(forResource: "emoji", ofType: "json") else {
            self.allEmojis = []
            self.emojisByCategory = [:]
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let list = try decoder.decode([Emoji].self, from: data)
            self.allEmojis = list
        } catch {
            self.allEmojis = []
        }
        
        
        var result: [String: [Emoji]] = [:]
        for category in SectionType.defaultCategories {
            result[category.rawValue] = allEmojis.filter { $0.category == category.rawValue }
        }
        self.emojisByCategory = result
    }
    
    func filteredEmojis(with keyword: String) -> [Emoji] {
        let lowercasedEmoji = keyword.lowercased()
        return allEmojis.filter { emoji in
            emoji.description.contains(lowercasedEmoji) ||
            emoji.tags.first { $0.contains(lowercasedEmoji) } != nil
        }
    }
}

extension EmojiStore {
    static func systemImageName(for section: String) -> String {
        guard let sectionType = SectionType(rawValue: section) else {
            return "questionmark"
        }
        
        switch sectionType {
        case .recent: return "clock"
        case .smileys: return "smiley"
        case .people: return "person.2"
        case .animals: return "tortoise"
        case .food: return "heart"
        case .travel: return "car"
        case .activities: return "gamecontroller"
        case .objects: return "lightbulb"
        case .symbols: return "hexagon"
        case .flags: return "flag"
        }
    }
    
    static func saveRecentEmoji(_ item: Emoji) {
        let userDefaults = UserDefaults.standard
        var recentList: [String] = []
        if let savedList = userDefaults.array(forKey: recentEmojiKey) as? [String] {
            recentList = Array(
                savedList
                    .filter { $0 != item.emoji }
                    .prefix(itemPerGroup * 3 - 1)
            )
        }
        
        recentList.insert(item.emoji, at: 0)
        userDefaults.set(recentList, forKey: recentEmojiKey)
    }
    
    static func fetchRecentList() -> [String] {
        return (UserDefaults.standard.array(forKey: recentEmojiKey) as? [String]) ?? []
    }
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
    
    static let defaultCategories: [SectionType] = SectionType.allCases
        .filter { $0 != .recent }
}

