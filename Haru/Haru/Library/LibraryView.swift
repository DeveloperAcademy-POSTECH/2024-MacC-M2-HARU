//
//  LibraryView.swift
//  Haru
//
//  Created by 김은정 on 9/23/24.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
//    @Environment(\.dismiss) var dismiss
    
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: nil, alignment: nil),
        GridItem(.flexible(), spacing: nil, alignment: nil),
        GridItem(.flexible(), spacing: nil, alignment: nil)
    ]
    
    @Query var photos: [PhotoInfo]
    //    @State var selectedPhoto: PhotoInfo
    
    @State var isSheetOpen = false
    
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: 6,
                pinnedViews: [],
                content: {
                    ForEach(photos) { photo in
                        NavigationLink(destination: Memory1View(photoInfo: Binding(get: { photo }, set: { _ in }))) {
                            if let uiImage = UIImage(data: photo.photo) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 180)
                                    .clipped()
                            }
                        }
                    }
                    
                    
                }
                
            )
            
            .padding()
        }
        .navigationTitle("보관함")
        .navigationBarTitleDisplayMode(.inline)
        
        .navigationBarItems(trailing:
                                Button { isSheetOpen = true } label: {Image(systemName: "plus") .foregroundColor(Color.CustomPink)})
        
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading:
//                                Image(systemName: "chevron.left") .onTapGesture { dismiss() })
        
        .fullScreenCover(isPresented: $isSheetOpen, content: {
            NavigationStack {
                AddView(isSheetOpen: $isSheetOpen)
            }
        })
        
    }
}

#Preview {
    NavigationStack{
        LibraryView()
            .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
    }
}
