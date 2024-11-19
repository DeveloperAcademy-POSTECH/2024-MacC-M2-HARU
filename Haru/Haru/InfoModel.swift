//
//  InfoModel.swift
//  Haru
//
//  Created by 김은정 on 9/19/24.
//

import Foundation
import SwiftUI

import SwiftData


@Model
class PhotoInfo: Identifiable {
    @Attribute(.unique) var imageName: String
    var photo: Data
    var date: Date
    var place: String
    var text: String
    var groupName: String
    var groupMember: [String]

    init(imageName: String, photo: Data, date: Date, place: String, text: String, groupName: String, groupMember: [String]) {
        self.imageName = imageName
        self.photo = photo
        self.date = date
        self.place = place
        self.text = text
        self.groupName = groupName
        self.groupMember = groupMember
    }
}




@Model
class GroupInfo: Identifiable, ObservableObject {
    let id = UUID()
    var name: String
    var member: [String]
    
    init(name: String, member: [String]) {
        self.name = name
        self.member = member
    }
}


//struct GroupI: Identifiable {
//    let id = UUID() // 고유한 ID 생성
//    var name: String
//    var member: [String]
//}
