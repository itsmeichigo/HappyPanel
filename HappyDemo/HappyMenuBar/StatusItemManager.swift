//
//  StatusItemManager.swift
//  Peachy
//
//  Created by Huong Do on 9/6/20.
//

import Cocoa
import SwiftUI

class StatusItemManager: NSObject {

    // MARK: - Properties
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    
    let emojiStore = EmojiStore.shared
    
    // MARK: - Init
    override init() {
        super.init()

        initStatusItem()
        initPopover()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        initStatusItem()
        initPopover()
    }
    
    // MARK: - Fileprivate Methods
    fileprivate func initStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "👻"
        statusItem?.button?.target = self
        statusItem?.button?.action = #selector(showContent)
    }
 
    
    fileprivate func initPopover() {
        popover = NSPopover()
        popover?.behavior = .transient
    }
    
        
    @objc fileprivate func showContent() {
        guard let popover = popover, let button = statusItem?.button else { return }
        
        let happyPanel = EmojiPanel(emojiStore: emojiStore) { emoji in
            let source = """
                set the clipboard to "\(emoji.emoji)"
                tell application "System Events" to keystroke "v" using command down
            """
            if let script = NSAppleScript(source: source) {
                var error: NSDictionary?
                script.executeAndReturnError(&error)
                if let err = error {
                    print(err)
                }
            }
        }
        .frame(width: 400, height: 280)
        
        popover.contentViewController = NSHostingController(rootView: happyPanel)
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
 
}

