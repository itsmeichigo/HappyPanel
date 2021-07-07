//
//  SearchBar.swift
//  HappyPanel
//
//  Created by Huong Do on 8/25/20.
//  Copyright © 2020 ichigo. All rights reserved.
//

import SwiftUI
import Shared

struct SearchBar: View {
    @EnvironmentObject var sharedState: SharedState
    
    var body: some View {
        HStack {
            TextField("Search emoji", text: $sharedState.keyword, onEditingChanged: { inFocus in
                sharedState.isSearching = inFocus
            })
            .font(.body)
            .padding(8)
            .padding(.horizontal, 28)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 12)
             
                    if !sharedState.keyword.isEmpty {
                        Button(action: {
                            self.sharedState.keyword = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 12)
                        }
                    }
                }
            )
            
            if sharedState.isSearching {
                Button(action: {
                    self.sharedState.isSearching = false
                    self.sharedState.keyword = ""
                    UIApplication.shared.endEditing()
                }) {
                    Text("Cancel")
                }
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
            .environmentObject(SharedState())
    }
}
