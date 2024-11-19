//
//  AddDateView.swift
//  Haru
//
//  Created by 김은정 on 9/19/24.
//

import SwiftUI
import SwiftData

struct AddDateView: View {
//    @Environment(\.dismiss) var dismiss

    
    @Binding var isSheetOpen: Bool
    
    
    
    @State var imageData: Data
    @State var imageName: String
    @State var date: Date

    
    
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

            
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 40)
            }
            DatePicker("날짜", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .accentColor(Color.CustomPink)
            
            
            
            
            
            Spacer()
            
        }
        .padding(.horizontal, 16)

        
        .navigationTitle("추가하기")
        .navigationBarTitleDisplayMode(.inline)
        
        .navigationBarItems(trailing: NavigationLink(destination: AddGroupView(isSheetOpen: $isSheetOpen, imageData: imageData, imageName: imageName, date: date)) {
            Text("다음")
                .foregroundColor(.black)
        })
        
    }
    
}

struct AddDateView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(named: "4cut1") // 로컬 이미지 이름으로 변경
        let imageData = sampleImage?.pngData() ?? Data() // 이미지 데이터를 Data로 변환
        
        NavigationStack {
            AddDateView(isSheetOpen: .constant(true), imageData: imageData, imageName: "4cutIMG", date: Date())
                .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
            
        }
    }
}
