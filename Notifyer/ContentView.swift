//
//  ContentView.swift
//  Notifyer
//
//  Created by Noel Cabus on 29/2/24.
//
import SwiftUI

struct ContentView: View {
    @State var isRunning = false;
    @StateObject var requester = NotificationsHandler()
    
    var body: some View {
        VStack {
            Text("Notifyer")
                .font(.largeTitle)
                .padding()
            if(isRunning) {
                Text("Receiving notifications").padding()
                Text("Code: " + requester.code).padding()
                requester.status ? Text("Server: Online") : Text("Server: Offline")
            } else {
                Text("Not receiving").padding()
            }
            
            Button {
                isRunning = !isRunning;
                requester.handle(startTimer: isRunning)
            } label: {
                isRunning ? Text("Stop") : Text("Start")
            }
            
            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Text("Quit")
            }
        }
    }
}

#Preview {
    ContentView()
}
