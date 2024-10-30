//
//  AddtestView.swift
//  Haru
//
//  Created by 김은정 on 10/18/24.
//

import SwiftUI

struct AddtestView: View {
    @State var testG: GroupI = GroupI(name: "그룹1", member: ["1번","2번","33번 민지"])
    
    var body: some View {
        VStack{
            NavigationLink(destination: MakeGroupView()) {
                Text("설정")
                    .foregroundColor(.white)
                    .frame(width: 337, height: 59)
                    .background(Color.blue)
                    .cornerRadius(20)
            }
            
            
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .frame(width: 353, height: 272)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 0)
                
                VStack(alignment: .leading) {
                    Text(testG.name)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                    
                    HStack{
                        ForEach(testG.member, id: \.self) { member in
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
        .toolbar(.hidden, for: .tabBar)

    }
}

#Preview {
    AddtestView()
}
