//
//  EditMemoView.swift
//  Haru
//
//  Created by 김은정 on 11/14/24.
//

import SwiftUI
import Combine

struct EditMemoView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var photoInfo: PhotoInfo
    
    @State var place: String
    @State var text: String
    @FocusState private var isPlaceFocused: Bool
    @FocusState private var isTextFocused: Bool

    var body: some View {
        ScrollView { // ScrollView 추가
            VStack {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(red: 0.47, green: 0.47, blue: 0.5).opacity(0.16))
                        .frame(maxWidth: .infinity, maxHeight: 4)
                        .cornerRadius(100)

                    Rectangle()
                        .fill(Color.MainRed)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.75, maxHeight: 4)
                        .cornerRadius(100)
                }
                .padding(.vertical, 20)

                if let uiImage = UIImage(data: photoInfo.photo) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding(.bottom, 40)
                }

                VStack(spacing: 16) {
                    Text("장소")
                    
                    TextField("장소를 입력하세요", text: $place)
                        .focused($isPlaceFocused)
                        .scrollContentBackground(.hidden)
                        .padding()
                        .background(Color.LightPink)
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .cornerRadius(10)

                    Text("메모")
                    
                    TextEditor(text: $text)
                        .focused($isTextFocused)
                        .scrollContentBackground(.hidden)
                        .padding()
                        .background(Color.LightPink)
                        .cornerRadius(10)
                        .lineSpacing(10)
                        .frame(maxWidth: .infinity, minHeight: 166)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .navigationTitle("추가하기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                    Text("저장")
                        .foregroundColor(.black)
                        .onTapGesture {
                            photoInfo.place = place
                            photoInfo.text = text
                            dismiss()
                        }
            )
            .onTapGesture {
                // 클릭 시 키보드 숨기기
                isPlaceFocused = false
                isTextFocused = false
            }
        }
        .padding(.bottom, 20) // ScrollView의 하단 여백 추가
        .onReceive(Publishers.keyboardHeight) { height in
            // 키보드 높이에 따라 여백 조정
            withAnimation {
                // 필요에 따라 추가적인 레이아웃 조정
            }
        }
    }
}


//
//#Preview {
//    EditMemoView()
//}
