//
//  Memory1View.swift
//  Haru
//
//  Created by 김은정 on 10/21/24.
//

import SwiftUI

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftData


//struct MemoryView: View {
struct Memory1View: View {
    
    //    @Binding var stack: NavigationPath
    @Binding var photoInfo: PhotoInfo
    
    @State private var selectedImage: UIImage?
    @State private var backgroundColor: Color = .white
    @State private var isSwiped = false
    @State private var imageOffset: CGFloat = 0
    private let maxSwipeUp: CGFloat = -80
    
    var body: some View {
        VStack {
            if let image = UIImage(data: photoInfo.photo) {
                ZStack {
                    Rectangle()
                        .fill(backgroundColor)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 550)
                            .offset(y: imageOffset)
                        
                        if isSwiped {
                            VStack {
                                Text("Date: \(photoInfo.date.formatted())")
                                Text("Text: \(photoInfo.text)")
                                Text("Group: \(photoInfo.groupName)")
                                
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
                            if !isSwiped {
                                if value.translation.height < 0 && imageOffset > maxSwipeUp {
                                    imageOffset = value.translation.height
                                }
                            }
                        }
                        .onEnded { value in
                            if value.translation.height < -50 {
                                isSwiped = true
                            } else if value.translation.height > 50 {
                                isSwiped = false
                            }
                            imageOffset = 0
                        }
                )
            }
        }
        .toolbar(.hidden, for: .tabBar)
        
        .onAppear {
            loadImageAndColor()
            print("초기실행")        }
        .onChange(of: photoInfo) { _ in
            loadImageAndColor()
            print("바뀌면 실행") 
        }
    }
    
    private func loadImageAndColor() {        
        if let uiImage = UIImage(data: photoInfo.photo) {
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
