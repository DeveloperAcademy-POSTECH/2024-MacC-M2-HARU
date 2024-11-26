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
    @State private var showButton: Bool = false

    var body: some View {
        VStack {
            HStack {
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    ZStack {
                        Rectangle()
                            .fill(Color.CustomPink)
                            .frame(width: 88, height: 88)
                            .cornerRadius(10)
                        
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.bold)

                            Text("직접선택")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                }
                
                NavigationLink(destination: MLDataPickerView(isSheetOpen: $isSheetOpen)) {
                    ZStack {
                        Rectangle()
                            .fill(Color.CustomPink)
                            .frame(width: 88, height: 88)
                            .cornerRadius(10)
                        VStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.bold)

                            Text("AI검색")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                }
            }
//            .padding(.bottom, 30)

            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(.white)
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 0)
                
                if let selectedImage = imageData, let uiImage = UIImage(data: selectedImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .padding(40)
//                        .frame(minWidth: .infinity, maxHeight: 300)
                } else {
                    VStack(spacing: 40){
                        Image("capsule")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                        Text("사진을 등록해주세요")
//                            .fontWeight(.semibold)
                    }
                }
            }
            .frame(width: 336, height: 423)
            .padding(.vertical, 30)
            
            if imageName != nil {
                NavigationLink(destination: AddDateView(isSheetOpen: $isSheetOpen, imageData: imageData!, imageName: imageName!, date: creationDate!)) {
                    Text("사진 등록하기")
                        .foregroundColor(.white)
                        .frame(width: 337, height: 59)
                        .background(Color.CustomPink)
                        .cornerRadius(20)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("중복 오류"), message: Text("이미 존재하는 이미지 이름입니다."), dismissButton: .default(Text("확인")))
                        }
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("추가하기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading:
            Image(systemName: "chevron.left").onTapGesture { isSheetOpen = false }
        )
        .task(id: selectedItem) {
            await loadImageData()
        }
    }
    
    private func loadImageData() async {
        guard let item = selectedItem else { return }

        // 선택된 아이템에서 이미지 데이터 가져오기
        if let data = try? await item.loadTransferable(type: Data.self) {
            imageData = data
            
            if let localID = selectedItem?.itemIdentifier {
                let result = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                
                if let asset = result.firstObject {
                    imageName = asset.value(forKey: "filename") as? String
                    creationDate = asset.creationDate
                    print("\(String(describing: imageName))")
                    print("\(String(describing: creationDate))")
                    
                    if savedPhoto.firstIndex(where: { $0.imageName == imageName }) != nil {
                        showAlert.toggle()
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
