//
//  AppDelegate.swift
//  KeyStats
//
//  Created by Michael Baker on 7/18/15.
//  Copyright (c) 2015 Michael Baker. All rights reserved.
//

import Cocoa
import SQLite
import Foundation
import AppKit

// TODO: Make this efficient by performing work in the background/batches

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    // -2 here is actually a constant defining the type of status item we want,
    // but Swift doesn't recognize the constant name for whatever reason so I,
    // had to use the number literal instead.
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let db         = connectToDb()

     func applicationDidFinishLaunching(aNotification: NSNotification) {
        if !acquirePrivileges() { exit(0) }
        setUpWidget()
        migrateDatabase(self.db)
        NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.KeyDownMask, handler: { (event) -> Void in self.handleKeyPress(event) })
    }
    
    func setUpWidget() -> Void {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Quit KeyStats", action: Selector("terminate:"), keyEquivalent: "q"))
        statusItem.menu = menu
        
        if let button = statusItem.button {
            button.image  = NSImage(named: "KeyStatusIcon")
            button.action = Selector("printQuote:")
        }
    }
    
    func handleKeyPress(event: NSEvent) -> Void {
        if let character = event.charactersIgnoringModifiers {
            let commandPressed = event.modifierFlags.rawValue & NSEventModifierFlags.CommandKeyMask.rawValue != 0
            let shiftPressed   = event.modifierFlags.rawValue & NSEventModifierFlags.ShiftKeyMask.rawValue != 0
            let controlPressed = event.modifierFlags.rawValue & NSEventModifierFlags.ControlKeyMask.rawValue != 0
            let altPressed     = event.modifierFlags.rawValue & NSEventModifierFlags.AlternateKeyMask.rawValue != 0
            logKeyStroke(self.db, KeyStroke(
                keyChar:        character,
                commandPressed: commandPressed,
                shiftPressed:   shiftPressed,
                controlPressed: controlPressed,
                altPressed:     altPressed,
                isBackspace:    isBackspace(character)
            ))
        }
    }
    
    func isBackspace(c: String) -> Bool {
        let scalars = c.unicodeScalars
        let char    = scalars[scalars.startIndex].value
        return Int(char) == 127
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func acquirePrivileges() -> Bool {
        let accessEnabled = AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true])
        
        return accessEnabled == 1
    }
}

