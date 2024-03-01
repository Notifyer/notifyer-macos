//
//  NotifyerApp.swift
//  Notifyer
//
//  Created by Noel Cabus on 29/2/24.
//

import SwiftUI

@main
struct NotifyerApp: App {
    var image: String = "iphone.gen1.radiowaves.left.and.right";
    var body: some Scene {
        //This MenuBarExtra makes so the app is in the status bar
        MenuBarExtra("UtilityApp", systemImage: image) {
            ContentView()
        }
    }
}
