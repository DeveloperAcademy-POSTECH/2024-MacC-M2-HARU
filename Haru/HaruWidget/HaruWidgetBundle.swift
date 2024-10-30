//
//  HaruWidgetBundle.swift
//  HaruWidget
//
//  Created by 김은정 on 10/25/24.
//

import WidgetKit
import SwiftUI

@main
struct HaruWidgetBundle: WidgetBundle {
    var body: some Widget {
        HaruWidget()
        HaruWidgetLiveActivity()
    }
}
