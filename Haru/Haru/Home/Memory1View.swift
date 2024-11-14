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
    @Binding var photoInfo: PhotoInfo
    
    @State private var backgroundColor: Color = .white
    @State private var startingOffsetY: CGFloat = UIScreen.main.bounds.height * 0.8
    @State private var currentDragOffsetY: CGFloat = 0
    @State private var endingOffsetY: CGFloat = 0
    
    @Environment(\.modelContext) var modelContext
//    @Environment(\.dismiss) var dismiss
    
    
    
    var body: some View {
        VStack {
            if let image = UIImage(data: photoInfo.photo) {
                ZStack (alignment: .top) {
                    Rectangle()
                        .fill(backgroundColor)
                        .edgesIgnoringSafeArea(.all)
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 550)
                        .padding(.top, 60)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity, maxHeight: 90)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: .black.opacity(0.1), location: 0.00),
                                    Gradient.Stop(color: .black.opacity(0), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            )
                        )
                    
                    
                    MemoryInfoView(photoInfo: $photoInfo)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
                    
                        .offset(y: startingOffsetY)
                        .offset(y: currentDragOffsetY)
                        .offset(y: endingOffsetY)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    withAnimation(.spring()) {
                                        currentDragOffsetY = value.translation.height
                                    }
                                })
                                .onEnded({ value in
                                    withAnimation(.spring()) {
                                        if currentDragOffsetY < -150 {
                                            endingOffsetY = -UIScreen.main.bounds.height * 0.3 // 절반 올라오게 설정
                                            currentDragOffsetY = .zero
                                        } else if endingOffsetY != 0 && currentDragOffsetY > 150 {
                                            endingOffsetY = 0 // 원래 위치로 돌아가기
                                            currentDragOffsetY = .zero
                                        } else {
                                            currentDragOffsetY = .zero
                                        }
                                    }
                                })
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
        }
        .onChange(of: photoInfo){
            loadImageAndColor()
        }
        .task {
            loadImageAndColor()
        }
        
        .navigationBarItems(trailing: Menu {
            Button("수정", action: {})
            Button("삭제", action: {modelContext.delete(photoInfo)})
        } label: {Image(systemName: "ellipsis")
                .foregroundColor(.customGray)
        })
        
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading:
//                                Image(systemName: "chevron.left") .onTapGesture {
//            print("왜 안됨")
///*            dismiss() */})
        
        
    }
    
    func loadImageAndColor()  {
        if let uiImage = UIImage(data: photoInfo.photo) {
            self.backgroundColor = extractDominantColor(from: uiImage)
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


struct Memory1View_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(named: "4cut1") // 로컬 이미지 이름으로 변경
        let imageData = sampleImage?.pngData() ?? Data() // 이미지 데이터를 Data로 변환
        
        
        let newInfo = PhotoInfo(photo: imageData, date: Date(), text:" ", groupName: "그룹1", groupMember: ["멤버1", "멤버2"])
        
        
        NavigationStack {
            Memory1View(photoInfo: .constant(newInfo))
            
        }
    }
}
