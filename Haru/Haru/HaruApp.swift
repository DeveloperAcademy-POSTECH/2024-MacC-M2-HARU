//
//  HaruApp.swift
//  Haru
//
//  Created by 김은정 on 9/19/24.
//

import SwiftUI
import SwiftData
import BackgroundTasks

@main
struct HaruApp: App {
    @StateObject var nm = NotificationManager.nm
//    @StateObject private var appDelegate = AppDelegate()

    var body: some Scene {
        WindowGroup {
            HomeView()
//                .environment(\.modelContext, appDelegate.modelContext)
                .onAppear {
                    nm.request_authorization()
                    nm.schedule_notification()
                }
        }
        .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
//    override init() {
//        super.init()
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.Haru.updatePhotos", using: nil) { task in
//            print("Background task registered")
//            self.handleAppRefresh(task: task as! BGAppRefreshTask)
//        }
//        scheduleAppRefresh()
//    }
//
//    func handleAppRefresh(task: BGAppRefreshTask) {
//        print("Handling background refresh task")
//        let queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 1
//        queue.addOperation {
//            NotificationCenter.default.post(name: .updatePhotos, object: nil)
//            task.setTaskCompleted(success: true)
//        }
//        task.expirationHandler = {
//            queue.cancelAllOperations()
//        }
//    }
//
//    func scheduleAppRefresh() {
//        let request = BGAppRefreshTaskRequest(identifier: "com.Haru.updatePhotos")
//        let calendar = Calendar.current
//        let now = Date()
//        
//        var nextDateComponents = calendar.dateComponents([.year, .month, .day], from: now)
//        nextDateComponents.hour = 10
//        nextDateComponents.minute = 0
//        
//        if let nextDate = calendar.date(from: nextDateComponents), nextDate <= now {
//            nextDateComponents.day! += 1
//        }
//        
//        guard let nextExecutionDate = calendar.date(from: nextDateComponents) else {
//            return
//        }
//        
//        request.earliestBeginDate = nextExecutionDate
//        
//        do {
//            try BGTaskScheduler.shared.submit(request)
//            print("Scheduled background task for \(nextExecutionDate)")
//        } catch {
//            print("Could not schedule app refresh: \(error)")
//        }
//    }
//}
