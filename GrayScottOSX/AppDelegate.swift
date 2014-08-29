//
//  AppDelegate.swift
//  GrayScottOSX
//
//  Created by Joseph on 22/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Cocoa

public let solverQueues = 1
public struct Constants
{
    static let LENGTH : Int = 256
    static let LENGTH_MINUS_ONE : Int = LENGTH - 1
    static let LENGTH_SQUARED : Int = LENGTH * LENGTH
}

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet weak var window: NSWindow!
    var windowController:GSWindowController!

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        windowController = GSWindowController(windowNibName: "GrayScottWindow")
        windowController.showWindow(self)
        window = windowController.window
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

    func applicationDidHide(notification: NSNotification!) {
        // 
    }
}

