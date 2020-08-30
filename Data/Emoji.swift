//
//  Emoji.swift
//  EmojiApp
//
//  Created by Huong Do on 8/25/20.
//

import Foundation

struct Emoji: Decodable {
    let emoji: String
    let category: String
    let description: String
    let aliases: [String]
    let tags: [String]
}

struct EmojiStore {
    let allEmojis: [Emoji]
    let allCategories: [String]
    let emojisByCategory: [String: [Emoji]]
    
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
        
        var result: [String: [Emoji]] = [:]
        for category in allCategories {
            result[category] = allEmojis.filter { $0.category == category }
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
