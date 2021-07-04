//
//  SectionHeader.swift
//  HappyDemo
//
//  Created by Huong Do on 9/7/20.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    #if os(iOS)
    let titleFont: Font = .caption
    #elseif os(macOS)
    let titleFont: Font = .title3
    #endif
    
    var body: some View {
        #if os(iOS)
        sectionText
        #elseif os(macOS)
        sectionText.padding()
        #endif
    }
    
    var sectionText: some View {
        Text(title)
            .foregroundColor(.gray)
            .font(titleFont)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(filledBackground)
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
