//
//  SectionIndexPicker.swift
//  HappyDemo
//
//  Created by Huong Do on 8/29/20.
//

import SwiftUI

struct SectionIndexPicker: View {
    @Binding var selectedSection: String
    
    var sections: [String]

    var body: some View {
        Picker(selection: $selectedSection, label: Text("Section"), content: {
            ForEach(sections, id: \.self) {
                sectionImage(for: $0)
                    .tag($0)
            }
        })
        .pickerStyle(SegmentedPickerStyle())
        .background(Blur(style: .systemUltraThinMaterial).cornerRadius(8.0))
    }
    
    private func sectionImage(for section: String) -> Image {
        let systemName: String
        switch section {
        case "Recent": systemName = "clock"
        case "Smileys & Emotion": systemName = "smiley"
        case "People & Body": systemName = "person.2"
        case "Animals & Nature": systemName = "tortoise"
        case "Food & Drink": systemName = "heart"
        case "Travel & Places": systemName = "car"
        case "Activities": systemName = "gamecontroller"
        case "Objects": systemName = "lightbulb"
        case "Symbols": systemName = "hexagon"
        case "Flags": systemName = "flag"
        default: systemName = "questionmark"
        }
        
        return Image(systemName: systemName)
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct SectionIndexPicker_Previews: PreviewProvider {
    static var previews: some View {
        let sections = ["🐹", "🦊", "🐧", "🦁", "🐨"]
        SectionIndexPicker(selectedSection: .constant(sections[0]), sections: sections)
    }
}
