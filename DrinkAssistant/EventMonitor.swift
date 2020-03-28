//
//  EventMonitor.swift
//  DrinkAssistant
//
//  Created by Wincer Chan on 2020/3/28.
//  Copyright © 2020 Wincer Chan. All rights reserved.
//

import Cocoa

public class EventMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() { // open monitor
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    public func stop() { // stop monitor
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
