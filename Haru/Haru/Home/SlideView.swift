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

    
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "ellipsis")
                        Image(systemName: "xmark")
                        .onTapGesture {
                            dismiss()
                        }
                }
                .padding()

                
                Memory1View(photoInfo: $photoList[currentIndex])
                
                HStack {
                    Button(action: previousImage) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(currentIndex == 0)
                    
                    Spacer()
                    Text("\(currentIndex+1)/\(photoList.count)")
                    Spacer()
                    
                    Button(action: nextImage) {
                        Image(systemName: "chevron.right")
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
}



//#Preview {
//    SlideView()
//}
