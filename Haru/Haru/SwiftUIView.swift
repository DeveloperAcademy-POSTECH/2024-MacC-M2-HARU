//
//  SwiftUIView.swift
//  Haru
//
//  Created by 김은정 on 9/23/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct SwiftUIView: View {
    @State private var selectedImage: UIImage?
    @State private var backgroundColor: Color = .white

    var body: some View {
        VStack {
            if let image = selectedImage {
                ZStack {
                    // 배경 색상
                    Rectangle()
                        .fill(backgroundColor)
                        .edgesIgnoringSafeArea(.all)

                    // 원본 이미지
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding(50) // 이미지 크기 조정
                }
            } else {
                Text("이미지를 선택하세요")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            // 초기 이미지 로드 및 색상 추출
            if let uiImage = UIImage(named: "4cut3") {
                selectedImage = uiImage
                backgroundColor = extractDominantColor(from: uiImage)
            }
        }
    }

    func extractDominantColor(from image: UIImage) -> Color {
        guard let ciImage = CIImage(image: image) else { return .white }

        let width = ciImage.extent.width
        let height = ciImage.extent.height

        // 테두리 영역 설정 (상단과 하단의 5%를 포함)
        let borderHeight = height * 0.05
        let borderRect = CGRect(x: 0, y: borderHeight, width: width, height: height - (borderHeight * 2))

        // 색상 카운트 딕셔너리
        var colorCount: [UInt32: Int] = [:]

        // CIImage를 CGImage로 변환
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return .white }

        // 픽셀 데이터 추출
        let data = cgImage.dataProvider?.data
        let pixelData = CFDataGetBytePtr(data)

        // 테두리 부분의 픽셀 색상 카운트
        for y in Int(borderRect.minY)..<Int(borderRect.maxY) {
            for x in Int(borderRect.minX)..<Int(borderRect.maxX) {
                let pixelIndex = ((cgImage.width * y) + x) * 4
                let r = pixelData![pixelIndex]
                let g = pixelData![pixelIndex + 1]
                let b = pixelData![pixelIndex + 2]
                let color = (UInt32(r) << 16) | (UInt32(g) << 8) | UInt32(b)

                colorCount[color, default: 0] += 1
            }
        }

        // 가장 많이 사용된 색상 찾기
        let dominantColor = colorCount.max { $0.value < $1.value }?.key ?? 0
        let r = CGFloat((dominantColor >> 16) & 0xFF) / 255.0
        let g = CGFloat((dominantColor >> 8) & 0xFF) / 255.0
        let b = CGFloat(dominantColor & 0xFF) / 255.0

        return Color(red: r, green: g, blue: b)
    }
}

#Preview {
    SwiftUIView()
}

