//
//  SettingView.swift
//  Haru
//
//  Created by 김은정 on 10/8/24.
//

import SwiftUI
import SwiftData



struct SettingView: View {
    //    @Environment(\.dismiss) var dismiss
    
    
    @Query var Groups: [GroupInfo]
    @Environment(\.modelContext) var modelContext
    @State var isSheetOpen = false
    @State var isEdit = false
    
    @State private var showAlert = false
    @State private var selectedGroup: GroupInfo?
    
    
    var body: some View {
        ScrollView{
            VStack {
                ForEach(Groups, id: \.id){ groupInfo in
                    VStack(alignment: .leading) {
                        HStack{
                            Text(groupInfo.name)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "pencil")
                                .onTapGesture {
                                    selectedGroup = groupInfo
                                    isEdit = true
                                }
                            Image(systemName: "trash.fill")
                                .onTapGesture {
                                    selectedGroup = groupInfo
                                    showAlert = true
                                }
                            
                        }
                        HStack{
                            ForEach(groupInfo.member, id: \.self) { member in
                                Text(member)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.LightPink)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // 둥근 모서리 테두리
                            .stroke(Color.CustomPink, lineWidth: 1) // 분홍색 테두리
                    )
                    .padding(.bottom, 16)
                }
            }
            .padding(16)
            
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("삭제 확인"),
                message: Text("정말로 이 그룹을 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("삭제")) {
                    if let groupToDelete = selectedGroup {
                        deleteGroup(groupToDelete)
                    }
                },
                secondaryButton: .cancel()
            )
        }
        
        .navigationTitle("그룹")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Button { isSheetOpen = true } label: {Image(systemName: "plus") .foregroundColor(Color.CustomPink)})
        
        //        .navigationBarBackButtonHidden(true)
        //        .navigationBarItems(leading:
        //                                Image(systemName: "chevron.left") .onTapGesture { dismiss() })
        
        .sheet(isPresented: $isSheetOpen){
            MakeGroupView()
        }
        
        .sheet(item: $selectedGroup) { group in
            EditGroupSetView(editGroup: Binding(get: { group }, set: { _ in }), groupName: group.name, memberList: group.member) // 수정할 그룹을 전달
        }
        
    }
    
    private func deleteGroup(_ group: GroupInfo) {
        modelContext.delete(group) // 그룹 삭제
        // 필요한 경우 추가적인 작업 (예: 데이터 저장) 수행
    }
}

#Preview {
    NavigationStack{
        SettingView()
            .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
    }
}
