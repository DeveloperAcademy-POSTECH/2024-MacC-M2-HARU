//
//  AddTextView.swift
//  Haru
//
//  Created by 김은정 on 11/5/24.
//

import SwiftUI
import SwiftData
import Combine

struct AddTextView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var isSheetOpen: Bool
    
    @State var imageData: Data
    @State var imageName: String
    @State var date: Date
    
    @Binding var groupName: String
    @Binding var groupMember: [String]

    @State private var text: String = ""
    @State private var place: String = ""
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

                if let uiImage = UIImage(data: imageData) {
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
                Button {
                let newInfo = PhotoInfo(imageName: imageName, photo: imageData, date: date, place: place, text: text, groupName: groupName, groupMember: groupMember)
                    modelContext.insert(newInfo)
                    print("저장")
                    isSheetOpen = false
                } label: {
                    Text("저장")
                        .foregroundColor(.black)
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




struct AddTextView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(named: "4cut1") // 로컬 이미지 이름으로 변경
        let photo = sampleImage?.pngData() ?? Data() // 이미지 데이터를 Data로 변환
        
        NavigationStack {
            AddTextView(isSheetOpen: .constant(true), imageData: photo, imageName: "4cut", date: Date(), groupName: .constant("그룹1"), groupMember: .constant([" "]))
                .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
            
            
        }
    }
}
