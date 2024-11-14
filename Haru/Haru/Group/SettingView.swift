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
        .navigationTitle("보관함")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Button { isSheetOpen = true } label: {Image(systemName: "plus") .foregroundColor(Color.CustomPink)})
        
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading:
//                                Image(systemName: "chevron.left") .onTapGesture { dismiss() })
        
        .sheet(isPresented: $isSheetOpen){
            MakeGroupView()
        }
        
    }
}

#Preview {
    NavigationStack{
        SettingView()
            .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
    }
}
