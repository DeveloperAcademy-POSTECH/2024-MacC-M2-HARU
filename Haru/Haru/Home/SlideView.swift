//
//  SlideView.swift
//  Haru
//
//  Created by 김은정 on 10/18/24.
//

import SwiftUI

struct SlideView: View {
    @Binding var photoList: [PhotoInfo] // 사진 리스트
    @State private var currentIndex: Int = 0 // 현재 사진 인덱스
    @Environment(\.dismiss) var dismiss
    @State private var backgroundColor: Color = .white
    @Environment(\.modelContext) var modelContext

    
    var body: some View {
        VStack {
            ZStack (alignment: .top){
                Memory1View(photoInfo: $photoList[currentIndex])
                
                HStack {
                    Spacer()
                    Menu {
                        NavigationLink(destination: EditDateView(photoInfo: $photoList[currentIndex], editDate: photoList[currentIndex].date)) {Text("날짜 수정")}
                        
                        NavigationLink(destination: EditGroupView(photoInfo: $photoList[currentIndex])) {Text("그룹 수정")}
                        
                        NavigationLink(destination: EditMemoView(photoInfo: $photoList[currentIndex], place: photoList[currentIndex].place, text: photoList[currentIndex].text)) {Text("메모 수정")}
                        
                        Button("삭제", action: {modelContext.delete(photoList[currentIndex])})
                    } label: {Image(systemName: "ellipsis")
                            .foregroundColor(.customGray)
                    }
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.customGray)
                        .onTapGesture {
                            dismiss()
                        }
                }
                .padding()
                
                
            }
            
            HStack {
                Button(action: previousImage) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.CustomPink)

                }
                .disabled(currentIndex == 0)
                
                Spacer()
                Text("\(currentIndex+1)/\(photoList.count)")
                Spacer()
                
                Button(action: nextImage) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.CustomPink)

                }
                .disabled(currentIndex == photoList.count - 1)
            }
            .padding()
            .padding(.bottom, 30)
            .background(.white)
            
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func nextImage() {
        if currentIndex < photoList.count - 1 {
            currentIndex += 1
        }
    }
    
    func previousImage() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    func loadImageAndColor(from imgdata: Data) {
        guard let uiImage = UIImage(data: imgdata) else { return }
        let color = extractDominantColor(from: uiImage)
        self.backgroundColor = color
    }
    
    
    private func extractDominantColor(from image: UIImage) -> Color {
        guard let ciImage = CIImage(image: image) else { return .white }
        
        let width = ciImage.extent.width
        let height = ciImage.extent.height
        let borderHeight = height * 0.05
        let borderRect = CGRect(x: 0, y: borderHeight, width: width, height: height - (borderHeight * 2))
        
        var colorCount: [UInt32: Int] = [:]
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return .white }
        
        let data = cgImage.dataProvider?.data
        guard let pixelData = CFDataGetBytePtr(data) else { return .white }
        
        // 픽셀 샘플링 간격 설정
        let step = 10 // 10픽셀 간격으로 샘플링
        
        for y in stride(from: Int(borderRect.minY), to: Int(borderRect.maxY), by: step) {
            for x in stride(from: Int(borderRect.minX), to: Int(borderRect.maxX), by: step) {
                let pixelIndex = ((cgImage.width * y) + x) * 4
                let r = pixelData[pixelIndex]
                let g = pixelData[pixelIndex + 1]
                let b = pixelData[pixelIndex + 2]
                let color = (UInt32(r) << 16) | (UInt32(g) << 8) | UInt32(b)
                
                colorCount[color, default: 0] += 1
            }
        }
        
        let dominantColor = colorCount.max { $0.value < $1.value }?.key ?? 0
        let r = CGFloat((dominantColor >> 16) & 0xFF) / 255.0
        let g = CGFloat((dominantColor >> 8) & 0xFF) / 255.0
        let b = CGFloat(dominantColor & 0xFF) / 255.0
        
        return Color(red: r, green: g, blue: b)
    }
}



//#Preview {
//    SlideView()
//}
