//
//  Notification.swift
//  Haru
//
//  Created by 김은정 on 11/9/24.
//

import SwiftUI
import UserNotifications


class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let nm = NotificationManager()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func request_authorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Request Authorization Error: \(error.localizedDescription)")
            } else if granted {
                print("permission granted")
            } else {
                print("permission denied")
            }
        }
    }
    
    func schedule_notification() {
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.body = "content"
        content.sound = UNNotificationSound.default
        
        let dateComponents = DateComponents(hour: 11, minute: 12)
        
        // trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                print("notification scheduled")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .sound])
        }

        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            completionHandler()
        }
}
