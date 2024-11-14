//
//  MLDataPickerView.swift
//  Haru
//
//  Created by 김은정 on 11/9/24.
//

import SwiftUI

struct MLDataPickerView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()

    
    var body: some View {
        VStack{
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(red: 0.47, green: 0.47, blue: 0.5).opacity(0.16))
                    .frame(maxWidth: .infinity, maxHeight: 4)
                    .cornerRadius(100)
                
                Rectangle()
                    .fill(Color.MainRed)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.25, maxHeight: 4)
                    .cornerRadius(100)
                
            }
            .padding(.vertical, 20)
            
            DatePicker("시작일", selection: $startDate, displayedComponents: [.date])
                .datePickerStyle(.compact)
                .accentColor(Color.CustomPink)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.LightPink)
                .cornerRadius(5)
            

            DatePicker("종료일", selection: $endDate, in: startDate...Calendar.current.date(byAdding: .month, value: 1, to: startDate)!, displayedComponents: [.date])
                .datePickerStyle(.compact)
                .accentColor(Color.CustomPink)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.LightPink)
                .cornerRadius(5)
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationTitle("보관함")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                NavigationLink(destination: CustomImagePicker(startDate: $startDate, endDate: $endDate)) {
                    Text("다음")
                        .foregroundColor(.black)
                }
            })
        })
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Image(systemName: "chevron.left") .onTapGesture { dismiss() })
        

        
    }
}

#Preview {
    NavigationStack{
        MLDataPickerView()
    }
}
