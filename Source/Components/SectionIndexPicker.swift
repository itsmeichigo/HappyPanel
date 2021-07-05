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
    var selectionHandler: () -> Void

    var body: some View {
        #if os(iOS)
        Picker(selection: $sharedState.currentCategory, label: Text("Section"), content: {
            ForEach(sections, id: \.self) {
                Image(systemName: EmojiStore.systemImageName(for: $0))
                    .tag($0)
            }
        })
        .pickerStyle(SegmentedPickerStyle())
        .background(Blur().cornerRadius(8.0))
        .labelsHidden()
        #elseif os(macOS)
        SegmentedControl(selection: $sharedState.currentCategory, dataSource: sections, images: sections.map { NSImage(systemSymbolName: EmojiStore.systemImageName(for: $0), accessibilityDescription: nil) }.compactMap { $0 }, selectionHandler: selectionHandler)
        #endif
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

struct SegmentedControl<T: Hashable>: NSViewRepresentable {
    @Binding var selection: T

    private let images: [NSImage]
    private let dataSource: [T]
    private let selectionHandler: () -> Void
    
    init(selection: Binding<T>, dataSource: [T], images: [NSImage], selectionHandler: @escaping () -> Void) {
        self._selection = selection
        self.images = images
        self.dataSource = dataSource
        self.selectionHandler = selectionHandler
    }
    
    func makeNSView(context: Context) -> NSSegmentedControl {
        let control = NSSegmentedControl(images: images, trackingMode: .selectOne, target: context.coordinator, action: #selector(Coordinator.onChange(_:)))
        return control
    }
    
    func updateNSView(_ nsView: NSSegmentedControl, context: Context) {
        nsView.selectedSegment = dataSource.firstIndex(of: selection) ?? 0
    }
    
    func makeCoordinator() -> SegmentedControl.Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator {
        let parent: SegmentedControl
        init(parent: SegmentedControl) {
            self.parent = parent
        }
        
        @objc
        func onChange(_ control: NSSegmentedControl) {
            parent.selection = parent.dataSource[control.selectedSegment]
            parent.selectionHandler()
        }
    }
}
#endif

struct SectionIndexPicker_Previews: PreviewProvider {
    static var previews: some View {
        let sections = ["Recent", "Smileys & Emotion", "People & Body", "Animals & Nature", "🐨"]
        SectionIndexPicker(sections: sections) {}
            .environmentObject(SharedState())
    }
}
