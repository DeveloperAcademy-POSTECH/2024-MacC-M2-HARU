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
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .clear // 배경색 설정
        appearance.shadowColor = UIColor.clear

        // 백 버튼 텍스트 색상을 투명하게 설정하여 숨김
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
}


