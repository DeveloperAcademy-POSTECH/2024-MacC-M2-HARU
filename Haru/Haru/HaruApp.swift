//
//  HaruApp.swift
//  Haru
//
//  Created by 김은정 on 9/19/24.
//

import SwiftUI
import SwiftData

@main
struct HaruApp: App {
    @StateObject var nm = NotificationManager.nm

    
    var body: some Scene {
        WindowGroup {
                HomeView()
                .onAppear {
                    nm.request_authorization()
                    nm.schedule_notification() // 추가
                }

            
        }
        .modelContainer(for: [PhotoInfo.self, GroupInfo.self])

    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false ))
        
    }
}
