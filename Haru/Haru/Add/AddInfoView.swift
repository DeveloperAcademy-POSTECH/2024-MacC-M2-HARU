//
//  AddInfoView.swift
//  Haru
//
//  Created by 김은정 on 9/19/24.
//

import SwiftUI
import SwiftData

struct AddInfoView: View {
    //    @Binding var stack: NavigationPath
    
    //    @Binding var path: [String]
    
    @Binding var isSheetOpen: Bool
    
    
    @State var ImageData: Data
    @State var date: Date = Date()
    
    
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
            //                .padding(.leading, 0)
            //                .padding(.trailing, 280)
            //                .padding(.vertical, 0)
            //                .background(Color(red: 0.47, green: 0.47, blue: 0.5).opacity(0.16))
            //                .padding(.horizontal, 16)
            //                .padding(.vertical, 0)
            //                .frame(width: 393, height: 44, alignment: .center)
            //                .background(.white)
            
            if let uiImage = UIImage(data: ImageData) {
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
        .navigationTitle("보관함")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                NavigationLink(destination: SelectGroupView(isSheetOpen: $isSheetOpen, photo: $ImageData, date: $date)) {
                    Text("다음")
                        .foregroundColor(.black)
                }
            })
                        })
        
            //        .navigationBarItems(trailing: )
            
        }
                 
                 }
                 
                 struct AddInfoView_Previews: PreviewProvider {
            static var previews: some View {
                let sampleImage = UIImage(named: "4cut1") // 로컬 이미지 이름으로 변경
                let imageData = sampleImage?.pngData() ?? Data() // 이미지 데이터를 Data로 변환
                
                NavigationStack {
                    AddInfoView(isSheetOpen: .constant(true), ImageData: imageData)
                        .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
                    
                }
            }
        }
