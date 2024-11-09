////
////  ContentView.swift
////  Haru
////
////  Created by 김은정 on 9/19/24.
////
//
//import SwiftUI
//
//enum Tab {
//    case first
//    case second
//    case third
//}
//
//
//struct ContentView: View {
//    
//    var body: some View {
//        TabView {
//            NavigationStack {
//                HomeView()
//            }
//            .tag(Tab.first)
//            .tabItem {
//                Image(systemName: "paperplane.fill")
//                Text("추억여행")
//            }
//            
//            NavigationStack {
//                LibraryView()
//            }
//            .tag(Tab.second)
//            .tabItem {
//                Image(systemName: "archivebox.fill")
//                Text("보관함")
//            }
//            
//            NavigationStack {
//                AddView()
//            }
//            .tag(Tab.third)
//            .tabItem {
//                Image(systemName: "photo.badge.plus.fill")
//                Text("사진추가")
//            }
//        }
//
//    }
//}
//
//
//#Preview {
//    ContentView()
//        .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
//    
//}
