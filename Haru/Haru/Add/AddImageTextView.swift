//
//  AddImageTextView.swift
//  Haru
//
//  Created by 김은정 on 11/5/24.
//

import SwiftUI

import SwiftUI
import SwiftData

struct AddImageTextView: View {
    @Environment(\.modelContext) var modelContext
//    @Environment(\.dismiss) var dismiss
    
    @Binding var isSheetOpen: Bool

    @Binding var photo: Data
    @Binding var date: Date
    @Binding var groupName: String // 선택된 그룹
    @Binding var groupMember: [String] // 그룹 멤버 복사

    
    @State var text: String = ""
    @State private var place: String = ""
    
    var body: some View {
        VStack{
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(red: 0.47, green: 0.47, blue: 0.5).opacity(0.16))
                    .frame(maxWidth: .infinity, maxHeight: 4)
                    .cornerRadius(100)
                
                Rectangle()
                    .fill(Color.MainRed)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.75, maxHeight: 4)
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
            
            VStack(spacing: 16) {
                Text("장소")
                
                TextField("Add new member", text: $place)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .background(Color.LightPink)
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .cornerRadius(10)
                
                
                
                
                Text("메모")
                
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .background(Color.LightPink)
                    .cornerRadius(10)
                    .lineSpacing(10)
                    .frame(maxWidth: .infinity, maxHeight: 166)
            }
            
            Spacer()
        }
        
        .padding(.horizontal, 16)
        
        
        .navigationTitle("보관함")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                
                                //                                NavigationLink(destination: EmptyView()) {
                            //            Text("완료")
                            //                .foregroundColor(.blue)
                            //        }
                            //
                            Button {
            let newInfo = PhotoInfo(photo: photo, date: date, text:text, groupName: groupName, groupMember: groupMember)
            modelContext.insert(newInfo)
            print("저장")
            isSheetOpen = false
            
        } label: {
            Text("저장")
                .foregroundColor(.black)
        }
        )
        
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading:
//                                Image(systemName: "chevron.left") .onTapGesture { dismiss() })
        
    }
    
}

struct AddImageTextView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(named: "4cut1") // 로컬 이미지 이름으로 변경
        let photo = sampleImage?.pngData() ?? Data() // 이미지 데이터를 Data로 변환
        
        NavigationStack {
            AddImageTextView(isSheetOpen: .constant(true), photo: .constant(photo), date: .constant(Date()), groupName: .constant("그룹1"), groupMember: .constant([" "]))
                .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
            
            
        }
    }
}
