//
//  OffsetObserver.swift
//  HappyMenuBar
//
//  Created by ichigo on 10/07/2021.
//

import Shared
import SwiftUI

struct OffsetViewFrame: Equatable {
    let id: String
    let frame: CGRect

    static func == (lhs: OffsetViewFrame, rhs: OffsetViewFrame) -> Bool {
        lhs.id == rhs.id && lhs.frame == rhs.frame
    }
}

struct OffsetKey: PreferenceKey {
    typealias Value = [OffsetViewFrame] // The list of view frame changes in a View tree.

    static var defaultValue: [OffsetViewFrame] = []

    /// When traversing the view tree, Swift UI will use this function to collect all view frame changes.
    static func reduce(value: inout [OffsetViewFrame], nextValue: () -> [OffsetViewFrame]) {
        value.append(contentsOf: nextValue())
    }
}

struct OffsetObserver: ViewModifier {
    let category: String
    let geometryProxy: GeometryProxy
    let sharedState: SharedState
    let updateHandler: () -> Void
    
    func body(content: Content) -> some View {
        content
            .transformAnchorPreference(key: OffsetKey.self, value: .bounds) {
                $0.append(OffsetViewFrame(id: category, frame: geometryProxy[$1]))
            }
            .onPreferenceChange(OffsetKey.self) {
                guard sharedState.currentCategory != category else {
                    return
                }
                if let item = $0.filter({ $0.id == category }).last,
                   item.frame.origin.y <= 0,
                   abs(item.frame.origin.y) < abs(item.frame.size.height) {
                    updateHandler()
                    sharedState.currentCategory = category
                }
            }
    }
}

extension View {
    func observeOffset(for category: String, geometryProxy: GeometryProxy, sharedState: SharedState, updateHandler: @escaping () -> Void) -> some View {
        modifier(OffsetObserver(category: category, geometryProxy: geometryProxy, sharedState: sharedState, updateHandler: updateHandler))
    }
}
