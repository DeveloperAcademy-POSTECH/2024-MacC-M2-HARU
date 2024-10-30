//
//  AddInfoView.swift
//  Haru
//
//  Created by 김은정 on 9/19/24.
//

import SwiftUI
import SwiftData

struct AddInfoView: View {
//    @Binding var stack: NavigationPath
    
    //    @Binding var path: [String]
    
    @Binding var isSheetOpen: Bool

    
    @State var ImageData: Data
    @State var date: Date = Date()
    @State var text: String = ""
    
    //    @State var selectedGroup: String = ""
    @Query var groupList: [GroupInfo]
    
    
    @State private var selectedGroup: GroupInfo? // 선택된 그룹
    @State private var selectedMember: String? // 선택된 멤버
    
    @State private var selectedMembers: Set<String> = [] // 선택된 멤버를 저장할 Set
    @State private var newMemberName: String = "" // 추가할 멤버 이름
    
    
    var body: some View {
        ScrollView{
            VStack{
                if let uiImage = UIImage(data: ImageData) {
                    Image(uiImage: uiImage)
                    
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                }
                DatePicker("날짜", selection: $date)
                
                
                TextEditor(text: $text)
                    .frame(width: 337, height: 80)
                    .cornerRadius(15)
                    .padding()
                    .background(.blue)
                
                
                
                NavigationLink(destination: SelectGroupView(photo: $ImageData, date: $date, text: $text, isSheetOpen: $isSheetOpen))
                {
                    Text("그룹 정보 입력")
                        .foregroundColor(.white)
                        .frame(width: 337, height: 59)
                        .background(Color.blue)
                        .cornerRadius(20)
                }

            }
            
            .padding()
            
        }
        .toolbar(.hidden, for: .tabBar)

    }
    
}

struct AddInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(named: "4cut1") // 로컬 이미지 이름으로 변경
        let imageData = sampleImage?.pngData() ?? Data() // 이미지 데이터를 Data로 변환
        
        NavigationStack {
            AddInfoView(isSheetOpen: .constant(true), ImageData: imageData)
        }
    }
}
