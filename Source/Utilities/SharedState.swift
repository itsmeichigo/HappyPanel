//
//  SharedState.swift
//  HappyDemo
//
//  Created by Huong Do on 8/30/20.
//

import Foundation
import Combine

final class SharedState: ObservableObject {
    @Published var selectedEmoji: Emoji? = nil
    @Published var isSearching: Bool = false
    @Published var keyword: String = ""
    @Published var currentCategory: String = defaultCategory
    
    func resetState() {
        isSearching = false
        keyword = ""
        currentCategory = SharedState.defaultCategory
    }
    
    static var defaultCategory: String {
        EmojiStore.fetchRecentList().isEmpty ?
            SectionType.smileys.rawValue : SectionType.recent.rawValue
    }
}
