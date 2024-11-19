//
//  EditGroupSetView.swift
//  Haru
//
//  Created by 김은정 on 11/18/24.
//

import SwiftUI
import SwiftData

struct EditGroupSetView: View {
    @Binding var editGroup: GroupInfo
    
    @State var groupName: String
    @State var memberList: [String]
    @State var memberName: String = ""

    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        VStack(spacing: 20){
            HStack{
                Text("그룹 추가하기")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                Spacer()
                
                Button("완료") {
                    if groupName != "" && !memberList.isEmpty {
                        editGroup.name = groupName
                        editGroup.member = memberList
                        dismiss()
                    }
                    else{
                        print("확인하셈")

                    }
                }
            }
                
                VStack{
                TextField("groupName", text: $groupName)
                    .scrollContentBackground(.hidden)

            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: 44)
            .background(Color.LightPink)
            .cornerRadius(10)




            HStack {
                TextField("Add new member", text: $memberName)
                    .scrollContentBackground(.hidden)
                    .background(Color.LightPink)
                    .frame(width: 270, height: 166)
                Spacer()
                
                Button("추가") {
                    if !memberName.isEmpty {
                        memberList.append(memberName)
                        memberName = "" // 입력 필드 초기화
                    }
                    
                }
                .font(.system(size: 15))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.CustomPink)
                .cornerRadius(5)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: 44)
            .background(Color.LightPink)
            .cornerRadius(10)

                
            HStack{
                ForEach(memberList, id: \.self) { member in
                    HStack(spacing: 6){
                        Text(member)

                        Button(action: {
                            deleteMember(member)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 15))

                                .foregroundColor(.CustomPink)
                        }
                    }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(Color.LightPink)
                        .cornerRadius(10)
                }
            }

            Spacer()
        }
        .padding(16)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)

        
    }
    
    private func deleteMember(_ member: String) {
        if let index = memberList.firstIndex(of: member) {
            memberList.remove(at: index)
        }
    }
    
    private func delete(at offsets: IndexSet) {
        memberList.remove(atOffsets: offsets)
    }
}

//#Preview {
//    EditGroupSetView()
//}
