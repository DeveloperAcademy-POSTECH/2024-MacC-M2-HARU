//
//  ColorExtension.swift
//  Haru
//
//  Created by 김은정 on 10/17/24.
//

import SwiftUI


extension Color{
    static let MainRed = Color(hex: "#FF6F61")
    static let customGray = Color(hex: "999999")
    static let customBlack = Color(hex: "333333")
    static let LightPink = Color(hex: "FCF3F2")
    static let CustomPink = Color(hex: "FF8C8A")
    static let ListBackground = Color(hex: "FFF8F7")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.haru"
        return UserDefaults(suiteName: appGroupId)!
    }
}


//class AppDelegate: NSObject, UIApplicationDelegate {
//
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
//    ) -> Bool {
//        setBackButtonColor()
//        return true
//    }
//}
//
//
//
//extension AppDelegate {
//
//    /// 백버튼의 타이틀을 clear 색상으로 바꾸고, tintColor를 mainTextColor로 바꾼다.
//    private func setBackButtonColor() {
//        let backButtonAppearance = UIBarButtonItemAppearance()
//        let appearance = UINavigationBarAppearance()
//
//        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
//        appearance.configureWithOpaqueBackground()
//        appearance.backButtonAppearance = backButtonAppearance
//        appearance.backgroundColor = UIColor(Color.gray)
//
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().compactAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        UIBarButtonItem.appearance().tintColor = UIColor(Color.gray)
//    }
//}
