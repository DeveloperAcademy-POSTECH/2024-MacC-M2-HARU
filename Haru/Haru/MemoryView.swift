//
//  MemoryView.swift
//  Haru
//
//  Created by 김은정 on 10/8/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftData


//struct MemoryView: View {
struct MemoryView: View {
    
//    @Binding var stack: NavigationPath
    @Binding var photoInfo: PhotoInfo?
    
    @State private var selectedImage: UIImage?
    @State private var backgroundColor: Color = .white
    @State private var isSwiped = false
    @State private var imageOffset: CGFloat = 0 // 이미지의 Y축 위치
    private let maxSwipeUp: CGFloat = -80 // 위로 스와이프할 수 있는 최대 거리
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss



    var body: some View {
        VStack {
            if let imageData = photoInfo?.photo, let image = UIImage(data: imageData) {
                ZStack {
                    Rectangle()
                        .fill(backgroundColor)
                        .edgesIgnoringSafeArea(.all)
                    
                    // 이미지와 정보
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 550)
                            .offset(y: imageOffset) // Y축으로 이동
//                            .animation(.easeInOut(duration: 0.3), value: imageOffset) // 애니메이션 효과
                        
                        if isSwiped {
                            // 정보 표시
                            VStack {
                                Text("Date: \(photoInfo?.date.formatted() ?? "N/A")")
                                Text("Text: \(photoInfo?.text ?? "No description available")")
                                Text("Group: \(photoInfo?.groupName ?? "No group available")")
                                Button(action: {
                                    modelContext.delete(photoInfo!)
                                    dismiss()
                                }) {
                                    Text("삭제")
                                        .foregroundColor(.red)
                                }
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                            }
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .padding()
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 10)
                        .onChanged { value in
                            // 위로 스와이프 시 이미지 이동 (최대값 제한)
                            if !isSwiped {
                                if value.translation.height < 0 && imageOffset > maxSwipeUp {
                                    imageOffset = value.translation.height // 이미지 위로 이동
                                }
                            }
                        }
                        .onEnded { value in
                            // 스와이프가 끝났을 때
                            if value.translation.height < -50 {
                                isSwiped = true // 스와이프가 충분히 위로 이동했을 때
                            } else if value.translation.height > 50 {
                                isSwiped = false // 아래로 스와이프 시 정보 숨기기
                            }
                            // 이미지 원래 위치로 복귀
                            imageOffset = 0
                        }
                )
            }
        }

        .onAppear {
            loadImageAndColor()
        }
    }
    
    private func loadImageAndColor() {
        guard let photoData = photoInfo?.photo else { return }
        
        if let uiImage = UIImage(data: photoData) {
            selectedImage = uiImage
            backgroundColor = extractDominantColor(from: uiImage)
        }
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
//    MemoryView(photoInfo: .constant(PhotoInfo()))
//}
