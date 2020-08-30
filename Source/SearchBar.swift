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
    @Binding var isEditing: Bool
    
    var body: some View {
        HStack {
            TextField("Search emoji", text: $keyword, onEditingChanged: { inFocus in
                isEditing = inFocus
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
             
                    if !keyword.isEmpty {
                        Button(action: {
                            self.keyword = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 12)
                        }
                    }
                }
            )
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.keyword = ""
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
        SearchBar(keyword: .constant(""), isEditing: .constant(false))
    }
}
