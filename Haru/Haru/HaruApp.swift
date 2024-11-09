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
//            ContentView()
//            PhotoPickerView()
//            PhotoPickView()
//            CustomImagePicker()
//            CutClassificationView()
//            SelectGroupView()
//            HelloView()

//            NavigationStack{
//                SettingView()
//            }
                HomeView()
                .onAppear {
                    nm.request_authorization()
                }
            
        }
        .modelContainer(for: [PhotoInfo.self, GroupInfo.self])

    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false ))
        
    }
}
