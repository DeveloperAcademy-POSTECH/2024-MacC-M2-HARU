//
//  MakeGroupView.swift
//  Haru
//
//  Created by 김은정 on 10/15/24.
//

import SwiftUI
import SwiftData

struct MakeGroupView: View {
//    @Binding var stack: NavigationPath
    @Query var GroupList: [GroupInfo]


    
    @State var groupName: String = ""
    @State var memberList: [String] = []
    @State var memberName: String = ""
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        VStack{
            Text("Hello, World!")
            TextField("groupName", text: $groupName)
            ForEach(memberList, id: \.self) { member in
                Text(member)
                    .background(Color.blue)

            }

            TextField("member", text: $memberName)
            Text("사람 추가")
                .foregroundColor(.white)
                .frame(width: 337, height: 59)
                .background(Color.blue)
                .cornerRadius(20)
                .onTapGesture {
                    memberList.append(memberName)
                    memberName = ""
                }
            
            Text("저장티비")
                .foregroundColor(.white)
                .frame(width: 337, height: 59)
                .background(Color.blue)
                .cornerRadius(20)
                .onTapGesture {
                    let newGroup = GroupInfo(name: groupName, member: memberList)
                    modelContext.insert(newGroup)         
                    print(GroupList)
                    dismiss()
                    
                }
        }
        .toolbar(.hidden, for: .tabBar)

        
    }
}

#Preview {
    MakeGroupView()
        .modelContainer(for: [PhotoInfo.self, GroupInfo.self])

}
