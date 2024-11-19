//
//  EditGroupView.swift
//  Haru
//
//  Created by 김은정 on 11/14/24.
//

import SwiftUI
import SwiftData

struct EditGroupView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var photoInfo: PhotoInfo
    

    
    
    @Query var groupList: [GroupInfo]
    
    @State private var editGroup: GroupInfo? // 선택된 그룹
    
    @State private var groupName: String = "" // 그룹 이름 복사
    @State private var groupMember: [String] = [] // 그룹 멤버 복사

    @State private var newMemberName: String = "" // 추가할 멤버 이름
    
    
    
    
    
    var body: some View {
        VStack{
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(red: 0.47, green: 0.47, blue: 0.5).opacity(0.16))
                    .frame(maxWidth: .infinity, maxHeight: 4)
                    .cornerRadius(100)
                
                Rectangle()
                    .fill(Color.MainRed)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.5, maxHeight: 4)
                    .cornerRadius(100)
                
            }
            .padding(.vertical, 20)
            
            if let uiImage = UIImage(data: photoInfo.photo) {
                Image(uiImage: uiImage)
                
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 40)

                
            }
            
            
            Text("누구랑 찍었나요?")
            
            VStack(spacing: 16) {
            Picker("Select a group", selection: $editGroup) {
                ForEach(groupList, id: \.self) { group in
                    Text(group.name).tag(group as GroupInfo?) // 그룹 객체를 태그로 사용
                }
            }
            .accentColor(.black)
            
            .pickerStyle(MenuPickerStyle())
            .onChange(of: editGroup){
                groupName = editGroup!.name
                groupMember = editGroup!.member
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal, 16)
            .background(Color.LightPink)
            .cornerRadius(10)
            
            
            if let editGroup = editGroup {
                HStack {
                    TextField("Add new member", text: $newMemberName)
                        .scrollContentBackground(.hidden)
                        .background(Color.LightPink)
                        .frame(width: 270, height: 166)
                    Spacer()
                    
                    Button("추가") {
                        if !newMemberName.isEmpty {
                            groupMember.append(newMemberName) // 새로운 멤버 추가
                            newMemberName = "" // 입력 필드 초기화
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
                
                List {
                    ForEach(groupMember, id: \.self) { member in
                        HStack {
                            Text(member)
                            Spacer() // 오른쪽 정렬을 위해 Spacer 추가
                            Button(action: {
                                deleteMember(member)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.CustomPink)
                            }
                        }
                        .listRowBackground(Color.LightPink)
                    }
                    .onDelete(perform: delete) // 스와이프 삭제 기능
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity, maxHeight: 180)
                .cornerRadius(10)
            }
            }
            Spacer()
            
        }
        .padding(.horizontal, 16)
        
        
        
        .navigationTitle("추가하기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            Text("다음")
                .foregroundColor(.black)
                .onTapGesture {
                    photoInfo.groupName = groupName
                    photoInfo.groupMember = groupMember
                    dismiss()
                }
        )
 
        
    }
    
    private func deleteMember(_ member: String) {
        if let index = groupMember.firstIndex(of: member) {
            groupMember.remove(at: index)
        }
    }
    
    private func delete(at offsets: IndexSet) {
        groupMember.remove(atOffsets: offsets)
    }
}


//#Preview {
//    EditGroupView()
//}
