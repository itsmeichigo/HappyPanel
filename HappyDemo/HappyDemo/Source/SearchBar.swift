//
//  SearchBar.swift
//  HappyPanel
//
//  Created by Huong Do on 8/25/20.
//  Copyright © 2020 ichigo. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    @Binding var keyword: String
    var focusHandler: () -> Void
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.15)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search emoji", text: $keyword, onEditingChanged: { inFocus in
                    if inFocus {
                        self.focusHandler()
                    }
                })
                    .font(.body)
            }
            .padding(8)
            
        }
        .frame(maxHeight: 44)
        .cornerRadius(8)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(keyword: .constant(""), focusHandler: {})
    }
}
