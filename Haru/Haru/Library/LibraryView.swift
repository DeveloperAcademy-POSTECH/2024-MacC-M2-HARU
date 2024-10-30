//
//  LibraryView.swift
//  Haru
//
//  Created by 김은정 on 9/23/24.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    //    @Binding var stack: NavigationPath
    
    
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: nil, alignment: nil),
        GridItem(.flexible(), spacing: nil, alignment: nil),
        GridItem(.flexible(), spacing: nil, alignment: nil)
    ]
    
    @Query var photos: [PhotoInfo]
    @State var selectedPhoto: PhotoInfo?
    
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: 6,
                pinnedViews: [],
                content: {
//                    Section(header:
//                                Text("📍 문지기 문지기 문열어라")
//                        .foregroundStyle(Color.gray)
//                        .font(.title3)
//                        .fontWeight(.bold)
//                        .padding(.top, 20)
//                    ) 
//                    {
                        ForEach(photos, id: \.self) { photoInfo in
                            NavigationLink(value: photoInfo){
                                if let uiImage = UIImage(data: photoInfo.photo) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 180)
                                        .clipped()
                                    
                                }
                            }
                            .simultaneousGesture(TapGesture().onEnded{ selectedPhoto = photoInfo })
                            
                        }
                        
                    }
                    
//                }
            )
            
            .padding()
        }
        .navigationTitle("보관함")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: PhotoInfo.self) { photo in
            MemoryView(photoInfo: $selectedPhoto)
            
        }
    }
}

#Preview {
    NavigationStack{
        LibraryView()
            .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
    }
}
