//
//  SectionIndexPicker.swift
//  HappyDemo
//
//  Created by Huong Do on 8/29/20.
//

import SwiftUI

struct SectionIndexPicker: View {
    @EnvironmentObject var sharedState: SharedState
    
    var sections: [String]

    var body: some View {
        Picker(selection: $sharedState.currentCategory, label: Text("Section"), content: {
            ForEach(sections, id: \.self) {
                Image(systemName: EmojiStore.systemImageName(for: $0))
                    .tag($0)
            }
        })
        .pickerStyle(SegmentedPickerStyle())
        .background(Blur().cornerRadius(8.0))
        .labelsHidden()
    }
}

#if os(iOS)
struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemUltraThinMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
#elseif os(macOS)
struct Blur: NSViewRepresentable {

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .withinWindow
        view.material = .hudWindow
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.blendingMode = .withinWindow
        nsView.material = .hudWindow
    }
}
#endif

struct SectionIndexPicker_Previews: PreviewProvider {
    static var previews: some View {
        let sections = ["Recent", "Smileys & Emotion", "People & Body", "Animals & Nature", "🐨"]
        SectionIndexPicker(sections: sections)
            .environmentObject(SharedState())
    }
}
