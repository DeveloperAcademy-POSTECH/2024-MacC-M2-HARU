////
////  AppDeligate.swift
////  Haru
////
////  Created by 김은정 on 11/20/24.
////
//
//import UIKit
//import BackgroundTasks
//
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Background Task 등록
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.updatePhotos", using: nil) { task in
//            self.handleAppRefresh(task: task as! BGAppRefreshTask)
//        }
//        
//        // 매일 저녁 9시에 작업 예약
//        scheduleAppRefresh()
//        
//        return true
//    }
//
//    func handleAppRefresh(task: BGAppRefreshTask) {
//        let queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 1
//        queue.addOperation {
//            // 데이터 업데이트 메서드 호출
//            NotificationCenter.default.post(name: .updatePhotos, object: nil)
//            task.setTaskCompleted(success: true)
//        }
//
//        // 작업이 완료될 때까지 대기
//        task.expirationHandler = {
//            queue.cancelAllOperations()
//        }
//    }
//
//    func scheduleAppRefresh() {
//        let request = BGAppRefreshTaskRequest(identifier: "com.yourapp.updatePhotos")
//        
//        // 현재 날짜와 시간을 가져옴
//        let calendar = Calendar.current
//        let now = Date()
//        
//        // 오늘 21시를 계산
//        var nextDateComponents = calendar.dateComponents([.year, .month, .day], from: now)
//        nextDateComponents.hour = 21
//        nextDateComponents.minute = 0
//        
//        // 오늘 21시가 이미 지나간 경우, 내일 21시로 설정
//        if let nextDate = calendar.date(from: nextDateComponents), nextDate <= now {
//            nextDateComponents.day! += 1
//        }
//        
//        // 다음 실행 시간을 설정
//        guard let nextExecutionDate = calendar.date(from: nextDateComponents) else {
//            return
//        }
//        
//        // 요청의 earliestBeginDate를 다음 실행 시간으로 설정
//        request.earliestBeginDate = nextExecutionDate
//        
//        do {
//            try BGTaskScheduler.shared.submit(request)
//        } catch {
//            print("Could not schedule app refresh: \(error)")
//        }
//    }
//}
