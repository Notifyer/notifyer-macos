//
//  NotificationsHandler.swift
//  Notifyer
//
//  Created by Noel Cabus on 1/3/24.
//  En colaboracion con Laceperro (con ayuda en si mismo a chatgpt (ya no se ni lo que estoy escribiendo))
//
import Combine
import Foundation
import UserNotifications

struct Get: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let idSession: String
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
    
    func sendNotification(identifier: String, title: String, description: String) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: description,
                                                                arguments: nil)
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
        
    }
    
    func fetchData() async -> Bool {
        guard let downloadedData: [Get] = await WebService().downloadData(fromURL: queryUrl) else {return false}
        for data in downloadedData {
            sendNotification(identifier: "\(data.id)_\(data.idSession)" ,title: data.title, description: data.description)
            do {
                sleep(4)
            }
        }
        
        return true;
    }
}
