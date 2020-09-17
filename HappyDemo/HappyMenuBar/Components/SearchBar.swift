//
//  SearchBar.swift
//  HappyMenuBar
//
//  Created by Huong Do on 9/17/20.
//

import SwiftUI

struct SearchBar: View {
    @EnvironmentObject var sharedState: SharedState
    
    var body: some View {
        TextField("Search emoji", text: $sharedState.keyword)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 8)
            .frame(height: 44)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
            .environmentObject(SharedState())
    }
}
