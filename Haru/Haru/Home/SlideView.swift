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
    
    var body: some View {
        NavigationView {
            VStack {                
                Memory1View(photoInfo: $photoList[currentIndex])
                
                HStack {
                    Button(action: previousImage) {
                        Text("이전")
                    }
                    .disabled(currentIndex == 0)
                    
                    Spacer()
                    
                    Button(action: nextImage) {
                        Text("다음")
                    }
                    .disabled(currentIndex == photoList.count - 1)
                }
                .padding()
            }
        }
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
}



//#Preview {
//    SlideView()
//}
