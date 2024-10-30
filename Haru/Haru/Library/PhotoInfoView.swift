//
//  PhotoInfoView.swift
//  Haru
//
//  Created by 김은정 on 10/2/24.
//

import SwiftUI

struct PhotoInfo1View: View {
//    @Binding var stack: NavigationPath
//    @Binding var photoInfo: PhotoInfo?

    @State private var isSwiped = false

    
    var body: some View {
        VStack{
            
            if let uiImage = UIImage(named: "4cut1") {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 550)
                    .gesture(
                            DragGesture(minimumDistance: 50)
                                .onEnded { value in
                                    if value.translation.height < 50 {
                                        isSwiped = true
                                    } else {
                                        isSwiped = false
                                    }
                                }
                        )
            }
        }
        .toolbar(.hidden, for: .tabBar)

    }
}

#Preview {
    PhotoInfo1View()
        .modelContainer(for: [PhotoInfo.self, GroupInfo.self])

}
