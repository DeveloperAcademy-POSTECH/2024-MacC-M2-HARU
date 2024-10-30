//
//  SettingView.swift
//  Haru
//
//  Created by 김은정 on 10/8/24.
//

import SwiftUI
import SwiftData



struct SettingView: View {
    
    @Query var GroupList: [GroupInfo]
    
    
    var body: some View {
            ScrollView{
                VStack{
                    NavigationLink(destination: MakeGroupView()) {
                        Text("설정")
                            .foregroundColor(.white)
                            .frame(width: 337, height: 59)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                    
                    ForEach(GroupList, id: \.id){ GroupInfo in
                        VStack {
                            ZStack(alignment: .topLeading) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 345, height: 117)
                                    .background(.white)
                                    .cornerRadius(15)
                                    .shadow(color: .black.opacity(0.07), radius: 2, x: 2, y: 2)
                                
                                VStack(alignment: .leading) {
                                    Text(GroupInfo.name)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                    
                                    HStack{
                                        ForEach(GroupInfo.member, id: \.self) { member in
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color.SubBackground)
                                                    .frame(width: 50, height: 24)
                                                Text(member)
                                            }
                                        }
                                    }
                                }
                                .padding(20)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            
        }
}

#Preview {
    SettingView()
    //        .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
    
}
