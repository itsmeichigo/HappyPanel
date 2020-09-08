//
//  SectionHeader.swift
//  HappyDemo
//
//  Created by Huong Do on 9/7/20.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(.gray)
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(filledBackground)
            .padding(.top, 16)
    }
    
    var filledBackground: some View {
        Group {
            #if os(iOS)
            GeometryReader { proxy in
                Color.background
                    .frame(
                        width: proxy.size.width * 3,
                        height: proxy.size.height * 3
                    )
            }
            .offset(x: -20, y: -20)
            #elseif os(macOS)
            EmptyView()
            #endif
        }
    }
}


struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(title: "Test")
    }
}
