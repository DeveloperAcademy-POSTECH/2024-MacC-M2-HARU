//
//  SelectGroupView.swift
//  Haru
//
//  Created by 김은정 on 10/17/24.
//

import SwiftUI
import SwiftData

struct SelectGroupView: View {
    @Binding var isSheetOpen: Bool

    @Binding var photo: Data
    @Binding var date: Date
    
    
    
    
    //    @State var selectedGroup: String = ""
    @Query var groupList: [GroupInfo]
    @Environment(\.modelContext) var modelContext

    
    @State private var selectedGroup: GroupInfo? // 선택된 그룹
    
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
            
            if let uiImage = UIImage(data: photo) {
                Image(uiImage: uiImage)
                
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 40)

                
            }
            
            
            Text("누구랑 찍었나요?")
            
            VStack(spacing: 16) {
            Picker("Select a group", selection: $selectedGroup) {
                ForEach(groupList, id: \.self) { group in
                    Text(group.name).tag(group as GroupInfo?) // 그룹 객체를 태그로 사용
                }
            }
            .accentColor(.black)
            
            .pickerStyle(MenuPickerStyle())
            .onChange(of: selectedGroup){
                groupName = selectedGroup!.name
                groupMember = selectedGroup!.member
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal, 16)
            .background(Color.LightPink)
            .cornerRadius(10)
            
            
            if let selectedGroup = selectedGroup {
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
        
        
        
        .navigationTitle("보관함")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: NavigationLink(destination: AddImageTextView(isSheetOpen: $isSheetOpen, photo: $photo, date: $date, groupName: $groupName, groupMember: $groupMember)) {
            Text("다음")
                .foregroundColor(.black)
        })
        
        
        
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



struct SelectGroupView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(named: "4cut1") // 로컬 이미지 이름으로 변경
        let imageData = sampleImage?.pngData() ?? Data() // 이미지 데이터를 Data로 변환
        
        NavigationStack {
            SelectGroupView(isSheetOpen: .constant(true), photo: .constant(imageData), date: .constant(Date()))
                .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
        }
    }
}
