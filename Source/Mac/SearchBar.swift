//
//  SearchBar.swift
//  HappyMenuBar
//
//  Created by Huong Do on 9/17/20.
//

import SwiftUI
import Shared

struct SearchBar: View {
    @EnvironmentObject var sharedState: SharedState
    @ObservedObject private var settings = HappySettings.shared
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.leading, 8)
            TextField(settings.showingKaomojis ? "Search kaomojis" : "Search emojis",
                      text: $sharedState.keyword)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .frame(height: 44)
        .padding(.horizontal, 8)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
            .environmentObject(SharedState())
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { super.focusRingType = .none }
    }
}
