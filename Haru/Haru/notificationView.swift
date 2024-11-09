//
//  notificationView.swift
//  Haru
//
//  Created by 김은정 on 11/9/24.
//

import SwiftUI
import UserNotifications

struct notificationView: View {
    var body: some View {
        VStack {
            Text("로컬 알림")
                .font(.largeTitle)
                .padding()
            Button {
                let dateComponents = DateComponents(hour: 21, minute: 0)
                NotificationManager.nm.schedule_notification()
            } label: {
                Text("알림 보내기")
                    .background(.blue)
                    .foregroundStyle(.white)
                    
            }
        }
        .onAppear {
            NotificationManager.nm.request_authorization()
        }
    }
}

#Preview {
    notificationView()
}
