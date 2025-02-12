//
//  VirusTotalMenuBarApp.swift
//  VirusTotalMenuBar
//
//  Created by Ben Schack on 2/11/25.
//

import SwiftUI

@main
struct VirusTotalMenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()  // No main window, just menu bar
        }
    }
}
