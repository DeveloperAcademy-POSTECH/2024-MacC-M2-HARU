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
    var body: some Scene {
        WindowGroup {
            ContentView()
//            PhotoPickerView()
//            PhotoPickView()
//            CustomImagePicker()
//            CutClassificationView()
//            SelectGroupView()
//            HelloView()

//            SettingView()
//            HomeView()
        }
        .modelContainer(for: [PhotoInfo.self, GroupInfo.self])

    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false ))
        
    }
}
