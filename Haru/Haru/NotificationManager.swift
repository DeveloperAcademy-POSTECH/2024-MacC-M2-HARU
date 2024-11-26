//
//  NotificationManager.swift
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
        content.title = "하루네컷"
        content.body = "오늘 하루의 네컷을 확인하세요"
        content.sound = UNNotificationSound.default
        
        let dateComponents = DateComponents(hour: 21, minute: 00)
        
        // trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "night", content: content, trigger: trigger)
        
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
        // 알림 클릭 시 데이터 업데이트 수행
        performAppUpdate()
        
        // completionHandler 호출
        completionHandler()
    }
    
    private func performAppUpdate() {
        // 데이터 업데이트 로직 추가
        print("알림 클릭 시 데이터 업데이트 수행")
        // 여기서 필요한 데이터 업데이트 작업을 수행합니다.
    }
}
