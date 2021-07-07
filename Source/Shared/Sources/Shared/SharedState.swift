//
//  SharedState.swift
//  HappyDemo
//
//  Created by Huong Do on 8/30/20.
//

import Foundation
import Combine

public final class SharedState: ObservableObject {
    @Published public var selectedEmoji: Emoji? = nil
    @Published public var isSearching: Bool = false
    @Published public var keyword: String = ""
    @Published public var currentCategory: String = defaultCategory
    
    public init() {}
    
    public func resetState() {
        isSearching = false
        keyword = ""
        currentCategory = SharedState.defaultCategory
    }
    
    public static var defaultCategory: String {
        EmojiStore.fetchRecentList().isEmpty ?
            SectionType.smileys.rawValue : SectionType.recent.rawValue
    }
}
