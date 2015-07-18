//
//  AppDelegate.swift
//  KeyStats
//
//  Created by Michael Baker on 7/18/15.
//  Copyright (c) 2015 Michael Baker. All rights reserved.
//

import Cocoa
import SQLite

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    // -2 here is actually a constant defining the type of status item we want,
    // but Swift doesn't recognize the constant name for whatever reason so I,
    // had to use the number literal instead.
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "PrintQuote", action: Selector("printQuote:"), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit KeyStats", action: Selector("terminate:"), keyEquivalent: "q"))
        statusItem.menu = menu
        
        if let button = statusItem.button {
            button.image  = NSImage(named: "KeyStatusIcon")
            button.action = Selector("printQuote:")
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func printQuote(sender: AnyObject) {
        println("This is not an NSString")
    }


}

