//
//  AppDelegate.swift
//  Firehose
//
//  Created by Jefferson Jones on 8/15/20.
//  Copyright © 2020 Jefferson Jones. All rights reserved.
//

import Cocoa
import SwiftUI
import CleanroomLogger

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!

    override init() {
        super.init()
        Log.enable(configuration: XcodeLogConfiguration(
            minimumSeverity: .verbose,
            stdStreamsMode: .useAlways
        ))
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Log.info?.message("Firehose \(Version.shortVersionString) (\(Version.buildNumber))")
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView.withDefaultConfiguration()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .texturedBackground, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
            
        )
        window.backgroundColor = NSColor.blue
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}

extension GeometryProxy {
    var maxDimension: CGFloat {
        return max(size.width, size.height)
    }
}

