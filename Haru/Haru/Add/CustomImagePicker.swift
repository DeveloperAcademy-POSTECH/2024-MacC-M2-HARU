//
//  CustomImagePicker.swift
//  Haru
//
//  Created by 김은정 on 10/11/24.
//

import SwiftUI
import SwiftData
import Photos
import CoreML
import Vision

struct CustomImagePicker: View {
    @State private var assets: [PHAsset] = []
    @State private var selectedAssets: [PHAsset] = [] // 선택된 사진 배열
    @State private var currentIndex = 0
    @State private var isLoading = true
    private let fetchLimit = 500000
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    @Environment(\.modelContext) var modelContext
    
    @Query private var savedPhoto: [PhotoInfo]
    
    
    var body: some View {
        VStack {
            if isLoading {
                // 로딩 화면
                ProgressView("로딩 중...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                        ForEach(assets, id: \.self) { asset in
                            ImageCell(asset: asset, isSelected: selectedAssets.contains(asset)) {
                                toggleSelection(for: asset)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("사진 찾기")
                
                Button(action: saveSelectedPhotos) {
                    Text("저장하기")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(selectedAssets.isEmpty) // 선택된 사진이 없으면 비활성화
            }
        }
        .onAppear {
            fetchPhotos(startDate: startDate, endDate: endDate)
            isLoading = false // 로딩 종료
            
        }
        
    }
    
    private func fetchPhotos(startDate: Date, endDate: Date) {
        //        isLoading = true // 로딩 시작
        let options = PHFetchOptions()
        options.includeHiddenAssets = false
        options.includeAssetSourceTypes = [.typeUserLibrary]
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // 날짜 범위 설정
        options.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate <= %@", startDate as NSDate, endDate as NSDate)
        
        let album = PHAsset.fetchAssets(with: .image, options: options)
        let assetsCount = album.count
        
        // assetsCount가 0인 경우
        guard assetsCount > 0 else {
            print("가져올 사진이 없습니다.")
            self.isLoading = false // 로딩 종료
            return
        }
        
        // currentIndex가 assetsCount를 초과할 경우 처리
        guard currentIndex < assetsCount else {
            print("더 이상 가져올 사진이 없습니다.")
            isLoading = false // 로딩 종료
            return
        }
        
        let dispatchGroup = DispatchGroup() // 비동기 처리를 위한 DispatchGroup
        let endIndex = min(currentIndex + fetchLimit, assetsCount)
        
        for index in currentIndex..<endIndex {
            print("실행")
            if let asset = album.object(at: index) as? PHAsset {
                dispatchGroup.enter() // 새로운 작업 시작
                
                classifyImage(asset: asset) { isFourCut in
                    if isFourCut {
                        DispatchQueue.main.async {
                            self.assets.append(asset) // 배열에 추가
                        }
                    }
                    dispatchGroup.leave() // 작업 완료
                }
            }
        }
        
        //        dispatchGroup.notify(queue: .main) {
        //            self.currentIndex += fetchLimit // 다음 가져올 사진 인덱스 업데이트
        //        }
    }
    
    
    private func toggleSelection(for asset: PHAsset) {
        if let index = selectedAssets.firstIndex(of: asset) {
            selectedAssets.remove(at: index) // 이미 선택된 경우 제거
        } else {
            selectedAssets.append(asset) // 선택되지 않은 경우 추가
        }
    }
    
    private func saveSelectedPhotos() {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true // 동기 요청을 위해 설정
        
        for asset in selectedAssets {
            let date = asset.creationDate ?? Date() // 이미지의 생성 날짜
            let imageName = (asset.value(forKey: "filename") as! String)
            
            if savedPhoto.firstIndex(where: { $0.imageName == imageName }) == nil
            {
                // 이미지 데이터 요청
                imageManager.requestImageData(for: asset, options: options) { data, _, _, _ in
                    guard let data = data else { return }
                    
                    // PhotoInfo 객체 생성
                    let photoInfo = PhotoInfo(imageName: imageName, photo: data, date: date, place: "", text: "", groupName: "", groupMember: [])
                    
                    
                    modelContext.insert(photoInfo)
                }
            }
        }
    }
    
    //    private func isImageNameDuplicate(_ imageName: String) -> Bool {
    //        // SwiftData를 사용하여 PhotoInfo 검색
    //        let query = PhotoInfo.where(\.$imageName == imageName)
    //
    //        // 결과를 가져오기
    //        do {
    //            let existingPhotos = try modelContext.fetch(query)
    //            return !existingPhotos.isEmpty // 존재하면 true 반환
    //        } catch {
    //            print("Failed to fetch PhotoInfo: \(error)")
    //            return false // 오류 발생 시 false 반환
    //        }
    //    }
    
    
    //    private func addNewPhoto(imageName: String) -> Bool {
    //        // 중복 검사
    //        if let index = savedPhoto.firstIndex(where: { $0.imageName == imageName }) {
    //            // 중복된 이름이 있는 경우
    ////            showAlert.toggle()
    //        } else {
    //            // 새로운 PhotoInfo 객체 생성
    //            let newPhoto = PhotoInfo(imageName: newCarName, photo: Data(), date: Date(), place: "", text: "", groupName: "", groupMember: [])
    //            modelContext.insert(newPhoto)
    //            newCarName = "" // 입력 필드 초기화
    //            withAnimation {
    //                // dismiss()는 필요한 경우에 사용하세요.
    //            }
    //        }
    //    }
    
    //    private func loadMorePhotos(startDate: Date, endDate: Date) {
    //        guard !isLoading else { return }
    //        isLoading = true
    //
    //        let options = PHFetchOptions()
    //        options.includeHiddenAssets = false
    //        options.includeAssetSourceTypes = [.typeUserLibrary]
    //        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    //
    //        // 날짜 범위 설정
    //        options.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate <= %@", startDate as NSDate, endDate as NSDate)
    //
    //        let album = PHAsset.fetchAssets(with: .image, options: options)
    //        let assetsCount = album.count
    //
    //        let dispatchGroup = DispatchGroup() // 비동기 처리를 위한 DispatchGroup
    //
    //        for index in currentIndex..<min(assetsCount, currentIndex + fetchLimit) {
    //            if let asset = album.object(at: index) as? PHAsset {
    //                print("실행")
    //
    //                dispatchGroup.enter() // 새로운 작업 시작
    //
    //                classifyImage(asset: asset) { isFourCut in
    //                    if isFourCut {
    //                        self.assets.append(asset) // 배열에 추가
    //                    }
    //                    dispatchGroup.leave() // 작업 완료
    //                }
    //            }
    //        }
    //        print("끝")
    //
    //
    //        dispatchGroup.notify(queue: .main) {
    //            self.currentIndex += self.fetchLimit
    //            self.isLoading = false
    //        }
    //    }
    
    func classifyImage(asset: PHAsset, completion: @escaping (Bool) -> Void) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true // 동기 요청을 위해 설정
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: options) { (image, _) in
            guard let uiImage = image, let ciImage = CIImage(image: uiImage) else {
                completion(false)
                return
            }
            
            // 모델 생성
            guard let coreMLModel = try? cutClassification(configuration: MLModelConfiguration()),
                  let visionModel = try? VNCoreMLModel(for: coreMLModel.model) else {
                fatalError("Loading CoreML Model Failed")
            }
            
            
            // 리퀘스트 생성
            // 리퀘스트 결과는 VNClassificationObservation의 배열
            let request = VNCoreMLRequest(model: visionModel) { request, error in
                guard let result = request.results as? [VNClassificationObservation] else {
                    completion(false)
                    return
                }
                
                // "4cut"인지 확인
                if let identifier = result.first?.identifier {
                    completion(identifier == "4cut")
                } else {
                    completion(false)
                }
            }
            
            // 리퀘스트를 처리해줄 핸들러 선언
            let handler = VNImageRequestHandler(ciImage: ciImage)
            
            do {
                try handler.perform([request])
            } catch {
                print(error)
                completion(false)
            }
        }
    }
}

struct ImageCell: View {
    var asset: PHAsset
    var isSelected: Bool
    var onSelect: () -> Void
    
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 180)
                    .clipped()
                
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 4)
                    )
                    .onTapGesture {
                        onSelect() // 사진 선택 시 호출
                    }
                    .onAppear {
                        loadImage()
                    }
            } else {
                Color.gray
                    .frame(height: 100)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 4)
                    )
                    .onTapGesture {
                        onSelect() // 사진 선택 시 호출
                    }
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) { uiImage, _ in
            self.image = uiImage
        }
    }
}

// Preview
struct CustomImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomImagePicker(startDate: .constant(Date()), endDate: .constant(Date()))
    }
}
