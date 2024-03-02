//
//  NotifyerApp.swift
//  Notifyer
//
//  Created by Noel Cabus on 29/2/24.
//

import SwiftUI
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }

        NSApp.activate(ignoringOtherApps: true)
    }
}

@main
struct NotifyerApp: App {
    var image: String = "iphone.gen1.radiowaves.left.and.right";
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        //This MenuBarExtra makes so the app is in the status bar
        MenuBarExtra("UtilityApp", systemImage: image) {
            ContentView()
        }
    }
}
