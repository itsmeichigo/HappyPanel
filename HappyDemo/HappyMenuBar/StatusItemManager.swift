//
//  StatusItemManager.swift
//  Peachy
//
//  Created by Huong Do on 9/6/20.
//

import Cocoa
import SwiftUI
import Shared

class StatusItemManager: NSObject {

    // MARK: - Properties
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var selectedEmoji: Emoji?
    
    private let emojiStore = EmojiStore.shared
    private let sharedState = SharedState()
    
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
        statusItem?.button?.image = NSImage(named: "ghost")
        statusItem?.button?.image?.isTemplate = true
        statusItem?.button?.target = self
        statusItem?.button?.action = #selector(showContent)
    }
 
    
    fileprivate func initPopover() {
        popover = NSPopover()
        popover?.behavior = .transient
        popover?.delegate = self
        let happyPanel = EmojiPanel(emojiStore: emojiStore) { [weak self] emoji in
            EmojiStore.saveRecentEmoji(emoji)
            self?.selectedEmoji = emoji
            self?.popover?.close()
        }
        .frame(width: 400, height: 280)
        .environmentObject(sharedState)
        
        popover?.contentViewController = NSHostingController(rootView: happyPanel)
    }
    
        
    @objc fileprivate func showContent() {
        guard let popover = popover, let button = statusItem?.button else { return }
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
 
}

extension StatusItemManager: NSPopoverDelegate {
    func popoverDidClose(_ notification: Notification) {
        guard let emoji = selectedEmoji else { return }
        
        let source = """
            set the clipboard to "\(emoji.string)"
            tell application "System Events" to keystroke "v" using command down
        """
        
        if let script = NSAppleScript(source: source) {
            var error: NSDictionary?
            script.executeAndReturnError(&error)
            if let err = error {
                print(err)
            }
        }
        
        selectedEmoji = nil
        sharedState.resetState()
    }
}
