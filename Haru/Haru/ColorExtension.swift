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
    static let SubBackground = Color(hex: "FCF3F2")
    static let Button = Color(hex: "FFBCB6")
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
