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
                    Text("\(formattedDate(photoInfo.date))")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    
                    if photoInfo.place != " " && photoInfo.place != "" {
                        Text("\(photoInfo.place)에서 \(photoInfo.groupName)")
                            .font(.subheadline)
                            .padding(.bottom, 5)
                    }

                    
                    HStack{
                        ForEach(photoInfo.groupMember, id: \.self) { member in
                            Text(member)
                                .font(.subheadline)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.LightPink)
                                .cornerRadius(10)
                        }
                    }
                    
                    
                    Text(photoInfo.text)
                        .font(.subheadline)
                        .padding(.bottom, 5)
                    
                    
                    Spacer()
                    
                }
                .padding(.top, 45)
            }
            .padding()

            
        }

    }
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    

}
//
//#Preview {
//    MemoryInfoView()
//}
