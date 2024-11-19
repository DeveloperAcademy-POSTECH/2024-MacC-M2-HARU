//
//  EditDateView.swift
//  Haru
//
//  Created by 김은정 on 11/14/24.
//

import SwiftUI

struct EditDateView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var photoInfo: PhotoInfo

    
    
    @State var editDate: Date

    
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(red: 0.47, green: 0.47, blue: 0.5).opacity(0.16))
                    .frame(maxWidth: .infinity, maxHeight: 4)
                    .cornerRadius(100)
                
                Rectangle()
                    .fill(Color.MainRed)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.25, maxHeight: 4)
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
            DatePicker("날짜", selection: $editDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
//                .foregroundColor(Color.CustomPink) // 강조 색상 설정

            
            
            
            
            Spacer()
            
        }
        .padding(.horizontal, 16)

        
        .navigationTitle("보관함")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            Text("수정")
                .foregroundColor(.black)
                .onTapGesture {
                    photoInfo.date = editDate
                    dismiss()
                }
        )
        
    }
}

//#Preview {
//    EditDateView()
//}
