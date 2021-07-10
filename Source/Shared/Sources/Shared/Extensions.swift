//
//  Extensions.swift
//  HappyDemo
//
//  Created by Huong Do on 8/30/20.
//

import Combine
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

@propertyWrapper
public struct UserDefaultWrapper<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    public var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    static let happyUserDefaults = UserDefaults(suiteName: "group.com.ichigo.HappyPanel")!

    @UserDefaultWrapper(key: "recent_emojis", defaultValue: [], container: .happyUserDefaults)
    static var recentEmojis: [String]
    
    @UserDefaultWrapper(key: "recent_kaomojis", defaultValue: [], container: .happyUserDefaults)
    static var recentKaomojis: [String]
    
    @UserDefaultWrapper(key: "showing_kaomojis", defaultValue: false, container: .happyUserDefaults)
    static var showingKaomojis: Bool
}

public class HappySettings: ObservableObject {
    @Published public var showingKaomojis: Bool {
        didSet {
            UserDefaults.showingKaomojis = showingKaomojis
        }
    }
    
    public static let shared: HappySettings = .init()
    
    public init() {
        self.showingKaomojis = UserDefaults.showingKaomojis
    }
}
