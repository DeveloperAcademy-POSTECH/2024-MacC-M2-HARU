//
//  MemoryInfoView.swift
//  Haru
//
//  Created by 김은정 on 11/8/24.
//

import SwiftUI

//var photo: Data
//var date: Date
//var text: String
//var groupName: String
//var groupMember: [String]

struct MemoryInfoView: View {
    @Binding var photoInfo: PhotoInfo

    var body: some View {
        ZStack{
            Color(.white)
            VStack{
                Rectangle()
                    .foregroundColor(.customGray)
                    .frame(width: 36, height: 5)
                    .cornerRadius(2.5)
                
                VStack{
                    Text(photoInfo.text)
                    
                    Text("\(photoInfo.date)")
                    Text("\(photoInfo.groupName)")
                    
                    HStack{
                        ForEach(photoInfo.groupMember, id: \.self) { member in
                            Text(member)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.LightPink)
                                .cornerRadius(10)
                        }
                    }
                    Spacer()
                    
                }
                .padding(.top, 30)
            }
            .padding()

            
        }

    }
}
//
//#Preview {
//    MemoryInfoView()
//}
