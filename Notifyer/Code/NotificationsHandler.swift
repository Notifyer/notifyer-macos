//
//  NotificationsHandler.swift
//  Notifyer
//
//  Created by Noel Cabus on 1/3/24.
//
import Combine
import Foundation

struct Get: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
}

class NotificationsHandler: ObservableObject {
    private var timer: AnyCancellable?
    
    @Published var code: String = "";
    @Published var status: Bool = false;
    let queryUrl = "http://localhost:6923/data";
    
    init() {
        code = generateSessionId();
    }
    
    func handle(startTimer: Bool) {
        if (startTimer) {
            print("starting...")
            start()
        } else {
            end()
        }
    }
    
    func start() {
        Task {
            let result = await self.fetchData()
            DispatchQueue.main.async {
                self.status = result
            }
        }
        timer = Timer.publish(every: 10.0, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                Task {
                    let result = await self.fetchData()
                    DispatchQueue.main.async {
                        self.status = result
                    }
                }
            }
    }
    
    func end(){
        timer?.cancel()
        timer = nil
    }
    
    func generateSessionId() -> String {
        let length = 4;
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString = String((0..<length).map { _ in characters.randomElement()! })
        return randomString
    }
    
    func pushNotification(title: String, description: String) {
        let script = """
                display notification "\(description)" with title "\(title)"
                """
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", script]
        
        task.launch()
    }
    
    func fetchData() async -> Bool {
        guard let downloadedData: [Get] = await WebService().downloadData(fromURL: queryUrl) else {return false}
        for data in downloadedData {
            pushNotification(title: data.title, description: data.description)
        }
        
        return true;
    }
}
