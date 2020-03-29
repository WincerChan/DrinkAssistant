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
    
    let q = DispatchQueue.background()
    
    override func viewDidLoad() {
            // Do view setup here.
            super.viewDidLoad()
            submit.action = #selector(buttonPress(_:))
            maintitle.stringValue = Config.titleString
            notify.stringValue = String(Config.interval / 60) + " min"
            subtitle.documentView!.insertText(Config.subtitleString)
        }
    
    func asyncShow() -> Void {
        q.async {
            while Config.running {
                Config.insideloop = true
                self.showNotification()
                sleep(Config.interval)
            }
            Config.insideloop = false
        }
    }
    
    func showNotification() -> Void {
        let notification = NSUserNotification()
        notification.title = Config.titleString
        notification.subtitle = Config.subtitleString
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.delegate = self
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    @objc func buttonPress(_ sender: Any) {
        let minutes = notify.stringValue
        let subtitleView = subtitle.documentView! as! NSTextView
        Config.interval = (UInt32(minutes.components(separatedBy: " ")[0]) ?? 10 ) * 60
        popover.window?.close()
        Config.titleString = maintitle.stringValue
        Config.subtitleString = subtitleView.string
        Config.saveConfig()
    }
    
    public func doPause() {
        Config.running = false
    }
    public func doResume() {
        Config.running = true
        if !Config.insideloop {
            asyncShow()
        }
    }
}

extension PopoverViewController {
    static func freshController() -> PopoverViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PopoverViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopoverViewController else {
            fatalError("Something Wrong with Main.storyboard")
        }
        return viewcontroller
    }
}

extension DispatchQueue {
    static func background(delay: Double=0.0, background:(() -> Void)? = nil) -> DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }
}
