//
//  PopoverViewController.swift
//  DrinkAssistant
//
//  Created by Wincer Chan on 2020/5/12.
//  Copyright © 2020 Wincer Chan. All rights reserved.
//

import Cocoa
import SwiftUI

struct Config {
    static var interval: UInt32 = 600
    static var titleString: String = "提醒喝水小助手"
    static var subtitleString: String = "该喝水啦～"
    static var running: Bool = false
    static var insideloop: Bool = false
    static var userDefaults = UserDefaults.standard
    
    static func loadConfig() {
        let interval = UInt32(Config.userDefaults.integer(forKey: "interval") )
        Config.interval = interval == 0 ? 600 : interval
        Config.subtitleString = Config.userDefaults.string(forKey: "subtileString") ?? "该喝水啦～"
        Config.titleString = Config.userDefaults.string(forKey: "titleString") ?? "提醒喝水小助手"
    }
    
    static func saveConfig() {
        Config.userDefaults.set(Config.subtitleString, forKey: "subtitleString")
        Config.userDefaults.set(Config.titleString, forKey: "titleString")
        Config.userDefaults.set(Config.interval, forKey: "interval")
        Config.userDefaults.synchronize()
    }
}


class PopoverViewController: NSViewController, NSUserNotificationCenterDelegate {
    
    @IBOutlet var popover: NSView!
    @IBOutlet weak var maintitle: NSTextField!
    
    @IBOutlet weak var subtitle: NSClipView!
    
    @IBOutlet weak var notify: NSComboBox!
    
    @IBOutlet weak var submit: NSButton!
}
