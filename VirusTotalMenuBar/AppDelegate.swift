//
//  AppDelegate.swift
//  VirusTotalMenuBar
//
//  Created by Ben Schack on 2/11/25.
//


import SwiftUI
import UserNotifications

func requestNotificationPermission() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            print("Notification permission error: \(error)")
        }
    }
}

func showNotification(title: String, message: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = message
    content.sound = UNNotificationSound.default

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error showing notification: \(error)")
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    var popover = NSPopover()

    func applicationDidFinishLaunching(_ notification: Notification) {
        requestNotificationPermission()

        // Create the menu bar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(systemSymbolName: "shield.lefthalf.fill", accessibilityDescription: "VirusTotal")
            button.action = #selector(togglePopover(_:)) // Ensure it reacts to clicks
            button.target = self
        }

        // Create the SwiftUI content view
        let contentView = ContentView()
        let hostingController = NSHostingController(rootView: contentView)

        // Configure the popover
        popover.contentSize = NSSize(width: 300, height: 100)
        popover.behavior = .transient // Hides when clicking outside
        popover.contentViewController = hostingController
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusBarItem?.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
