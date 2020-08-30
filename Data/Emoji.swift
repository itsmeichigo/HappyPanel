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

struct EmojiStore {
    let allEmojis: [Emoji]
    let allCategories: [String]
    let emojisByCategory: [String: [[Emoji]]]
    
    static let shared = EmojiStore()
    
    init() {
        guard let path = Bundle.main.path(forResource: "emoji", ofType: "json") else {
            self.allEmojis = []
            self.allCategories = []
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
        
        self.allCategories = allEmojis.map { $0.category }.removeDuplicates()
        
        var result: [String: [[Emoji]]] = [:]
        for category in allCategories {
            let items = allEmojis.filter { $0.category == category }
            result[category] = EmojiStore.getItemGroups(from: items, itemPerGroup: 7)
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
    
    static func systemImageName(for section: String) -> String {
        let systemName: String
        switch section {
        case "Recent": systemName = "clock"
        case "Smileys & Emotion": systemName = "smiley"
        case "People & Body": systemName = "person.2"
        case "Animals & Nature": systemName = "tortoise"
        case "Food & Drink": systemName = "heart"
        case "Travel & Places": systemName = "car"
        case "Activities": systemName = "gamecontroller"
        case "Objects": systemName = "lightbulb"
        case "Symbols": systemName = "hexagon"
        case "Flags": systemName = "flag"
        default: systemName = "questionmark"
        }
        
        return systemName
    }
    
    static private func getItemGroups(from items: [Emoji], itemPerGroup: Int) -> [[Emoji]] {
        var groups: [[Emoji]] = []
        var itemsLeft: [Emoji] = items
        
        while !itemsLeft.isEmpty {
            let prefix = Array(itemsLeft.prefix(itemPerGroup))
            groups.append(prefix)
            itemsLeft.removeSubrange(0..<prefix.count)
        }
        
        return groups
    }

}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
