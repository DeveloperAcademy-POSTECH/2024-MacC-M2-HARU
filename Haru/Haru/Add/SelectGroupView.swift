//
//  SelectGroupView.swift
//  Haru
//
//  Created by 김은정 on 10/17/24.
//

import SwiftUI
import SwiftData

struct SelectGroupView: View {
    
    @Binding var photo: Data
    @Binding var date: Date
    @Binding var text: String
    @Binding var isSheetOpen: Bool

    
    
    
    //    @State var selectedGroup: String = ""
    @Query var groupList: [GroupInfo]
    
    
    @State private var selectedGroup: GroupInfo? // 선택된 그룹
    
    @State private var groupMember: [String] = []
    
    
    @State private var selectedMember: String? // 선택된 멤버
    
    @State private var selectedMembers: Set<String> = [] // 선택된 멤버를 저장할 Set
    @State private var newMemberName: String = "" // 추가할 멤버 이름
    
    @Environment(\.modelContext) var modelContext
    
    
    var body: some View {
        VStack{
            if let uiImage = UIImage(data: photo) {
                Image(uiImage: uiImage)
                
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
            }
            Picker("Select a group", selection: $selectedGroup) {
                ForEach(groupList, id: \.self) { group in
                    Text(group.name).tag(group as GroupInfo?) // 그룹 객체를 태그로 사용
                }
            }
            .onChange(of: selectedGroup){
                groupMember = selectedGroup!.member
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            
            //             두 번째 Picker: 선택된 그룹의 멤버 선택
            if let selectedGroup = selectedGroup {
                //                Picker("Select a member", selection: $selectedMember) {
                //                    ForEach(groupMember, id: \.self) { member in
                //                        Text(member)
                //                    }
                //                }
                //                .pickerStyle(MenuPickerStyle())
                //                .padding()
                //
                //                Text("hello")
                
                // 멤버 선택 리스트
                List(groupMember, id: \.self) { member in
                    HStack {
                        Text(member)
                        if selectedMembers.contains(member) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle()) // 터치 영역 확장
                    .onTapGesture {
                        if selectedMembers.contains(member) {
                            selectedMembers.remove(member) // 이미 선택된 경우 제거
                        } else {
                            selectedMembers.insert(member) // 선택되지 않은 경우 추가
                        }
                    }
                }
                
                // 멤버 추가
                HStack {
                    TextField("Add new member", text: $newMemberName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Add") {
                        if !newMemberName.isEmpty {
                            groupMember.append(newMemberName) // 새로운 멤버 추가
                            newMemberName = "" // 입력 필드 초기화
                        }
                    }
                    .padding()
                }
                
                // 선택된 멤버 삭제
                Button("Remove Selected Members") {
                    groupMember.removeAll { selectedMembers.contains($0) } // 선택된 멤버 삭제
                    selectedMembers.removeAll() // 선택 초기화
                }
                .padding()
                .disabled(selectedMembers.isEmpty) // 선택된 멤버가 없을 경우 비활성화
                
                
                Button {
                    let newInfo = PhotoInfo(photo: photo, date: date, text:text, groupName: selectedGroup.name, groupMember: groupMember)
                    modelContext.insert(newInfo)
                    print("저장")
                    isSheetOpen = false
                    
                } label: {
                    Text("저장티비")
                        .foregroundColor(.white)
                        .frame(width: 337, height: 59)
                        .background(Color.blue)
                        .cornerRadius(20)                }
                
            }
            
        }
        .toolbar(.hidden, for: .tabBar)

    }
}



struct SelectGroupView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(named: "4cut1") // 로컬 이미지 이름으로 변경
        let imageData = sampleImage?.pngData() ?? Data() // 이미지 데이터를 Data로 변환
        
        NavigationStack {
            SelectGroupView(photo: .constant(imageData), date: .constant(Date()), text: .constant("Hello"), isSheetOpen: .constant(true))
                .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
        }
    }
}
