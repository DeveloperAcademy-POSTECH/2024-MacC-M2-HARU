//
//  AddView.swift
//  Haru
//
//  Created by 김은정 on 9/19/24.
//

import PhotosUI
import SwiftUI

struct AddView: View {
    //    @Binding var stack: NavigationPath
    
    //    @Binding var path: [String]
    
    @State private var selectedItem: PhotosPickerItem? = nil
    //    @State var selectedImage: Image? = nil
    @State var ImageData: Data? = nil
    //    @State var startDate: Date = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
    @State var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    
    @State var endDate: Date = Date()
    
    @Binding var isSheetOpen: Bool
    
    
    var body: some View {
        VStack {
            HStack{
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 88, height: 88)
                            .background(Color(red: 1, green: 0.74, blue: 0.71))
                            .cornerRadius(7)
                        Text("사진 선택하기")
                        
                    }
                }
                
                
                
                NavigationLink(destination: CustomImagePicker(startDate: $startDate, endDate: $endDate)) {
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 88, height: 88)
                            .background(Color(red: 1, green: 0.74, blue: 0.71))
                            .cornerRadius(7)
                        Text("사진 검색하기")
                        
                    }
                }
                
            }
            .onAppear{
                ImageData = nil
            }
            
            if let selectedImage = ImageData, let uiImage = UIImage(data: selectedImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                
                //                NavigationLink(destination: AddInfoView(isSheetOpen: $isSheetOpen, ImageData: ImageData!)){
                //
                //
                //                    Text("사진 등록하기")
                //                        .foregroundColor(.white)
                //                        .frame(width: 337, height: 59)
                //                        .background(Color.blue)
                //                        .cornerRadius(20)
                //                }
            }
            
            Spacer()
        }
        .navigationTitle("보관함")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
//                NavigationLink(destination: AddInfoView(isSheetOpen: $isSheetOpen, ImageData: ImageData!))
//                {
//                네비게이션만 달면 문제 생김 왜 그럼 제 발
                    Text("다음")
                        .foregroundColor(.black)
//                }
            })
        })
        
        
        .task(id: selectedItem) {
            // 선택된 아이템에서 이미지 데이터 가져오기
            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                ImageData = data
            }
        }
    }
}



#Preview {
    NavigationStack{
        AddView(isSheetOpen: .constant(true))
    }
}
