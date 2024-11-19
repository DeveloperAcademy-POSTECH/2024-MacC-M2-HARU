//
//  AddView.swift
//  Haru
//
//  Created by 김은정 on 9/19/24.
//

import SwiftUI
import SwiftData
import PhotosUI
import Photos



struct AddView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State var imageData: Data? = nil
    @State var imageName: String? = nil
    @State var creationDate: Date? = nil
    
    @Binding var isSheetOpen: Bool
    
    @Query private var savedPhoto: [PhotoInfo]

    @State private var showAlert: Bool = false

    var body: some View {
        VStack {
            HStack {
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 88, height: 88)
                            .background(Color(red: 1, green: 0.74, blue: 0.71))
                            .cornerRadius(7)
                        Text("사진 선택하기")
                    }
                }
                
                NavigationLink(destination: MLDataPickerView()) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 88, height: 88)
                            .background(Color(red: 1, green: 0.74, blue: 0.71))
                            .cornerRadius(7)
                        Text("사진 검색하기")
                    }
                }
            }
            
            if let selectedImage = imageData, let uiImage = UIImage(data: selectedImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                
                Text("파일 이름: \(imageName ?? "알 수 없음")")
                Text("생성 날짜: \(creationDate?.description ?? "알 수 없음")")
                
                NavigationLink(destination: AddDateView(isSheetOpen: $isSheetOpen, imageData: imageData!, imageName: imageName!, date: creationDate!)) {
                    Text("사진 등록하기")
                        .foregroundColor(.white)
                        .frame(width: 337, height: 59)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("중복 오류"), message: Text("이미 존재하는 이미지 이름입니다."), dismissButton: .default(Text("확인")))
                        }
                }
            }
            
            Spacer()
        }
        
        .navigationTitle("추가하기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading:
                                Image(systemName: "chevron.left").onTapGesture { isSheetOpen = false }
        )
        
        .task(id: selectedItem) {
            
            if let item = selectedItem {
                // 선택된 아이템에서 이미지 데이터 가져오기
                if let data = try? await item.loadTransferable(type: Data.self) {
                    imageData = data
                    
                    if let localID = selectedItem?.itemIdentifier {
                        let result = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                        
                        if let asset = result.firstObject {
                            
                            imageName = (asset.value(forKey: "filename") as! String)
                            creationDate = asset.creationDate
                            print("\(String(describing: imageName))")
                            print("\(creationDate)")
                            
                            if savedPhoto.firstIndex(where: { $0.imageName == imageName }) != nil
                            {
                                showAlert.toggle()

                                
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
    
}


#Preview {
    NavigationStack{
        AddView(isSheetOpen: .constant(true))
    }
}
