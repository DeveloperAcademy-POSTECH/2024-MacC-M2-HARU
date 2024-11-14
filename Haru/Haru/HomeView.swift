//
//  HomeView.swift
//  Haru
//
//  Created by 김은정 on 9/19/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query var photos: [PhotoInfo]
    
    @State var todayPhotoList: [PhotoInfo] = []
    
    @State var isSlide = false
//    @Environment(\.dismiss) var dismiss
    
    //    var currentSelectedGlobalTime = "Africa/Algiers"
    //    UserDefaults.shared.set(currentSeletedGlobalTime, forKey: "timezone")
    
    
    //    init(){
    //        updateImageIfNeeded()
    //    }
    @State var maxCount = 0
    
    @State var isOpen = false
    
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack {
//                    Image("logo")
//                        .resizable()
//                        .scaledToFit()
                    Text("하루네컷")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                    Spacer()
                    Button {
                        todayPhotoList = recommendPhotos(photos: photos)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.customGray)
                            .font(.system(size: 20))
                    }
                    
                    NavigationLink(destination: LibraryView()) {
                        Image(systemName: "photo.fill")
                            .foregroundColor(.customGray)
                            .font(.system(size: 18))
                    }
                    
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.customGray)
                            .font(.system(size: 18))
                    }
                }
                .padding(.top, 30)
                
//                Spacer()
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 336, height: 423)
                        .background(.white)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 0)
                    
                    if isOpen {
                        if let todayPhoto = todayPhotoList.first {
                            if let uiImage = UIImage(data: todayPhoto.photo) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 336)
                            }
                        }
                    }
                    
                    else {
                        Image("뽑기통")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 500)
                        
                    }

                }
                .frame(height: 500)
                .padding(.vertical, 20)
                
                Text("오늘의 캡슐")
                    .foregroundColor(.white)
                    .frame(width: 337, height: 59)
                    .background(Color.CustomPink)
                    .cornerRadius(20)
                    .onTapGesture {
                        isSlide = true
                        isOpen = true
                    }
                
                Spacer()
            }
            .padding(.horizontal, 20)

        }
        .tint(Color.customGray)

        .fullScreenCover(isPresented: $isSlide, content: {
            SlideView(photoList: $todayPhotoList)
        })
    }
    
    
    
    //    private func updateImageIfNeeded() {
    //        let calendar = Calendar.current
    //        let currentHour = calendar.component(.hour, from: Date())
    //
    //        // 현재 시간이 21시라면
    //        if currentHour == 21 {
    //            currentImage = images.randomElement() ?? ""
    //        }
    //    }
    
    // 사진 추천
    func recommendPhotos(photos: [PhotoInfo]) -> [PhotoInfo] {
        print("\(maxCount)")
        maxCount = photos.count
        print("변경1 \(maxCount)")
        
        if maxCount > 4 {
            maxCount = 5
        }
        print("변경2 \(maxCount)")
        
        if hasPhotoForToday(photos: photos) {
            //오늘 사진으로 수정
            let todayPhoto = photos.first
            
            return scorerecommendPhotos(inputPhoto: todayPhoto!, allPhotos: photos)
        }
        
        else {
            return daterecommendPhotos(photos: photos)
        }
    }
    
    
    func hasPhotoForToday(photos: [PhotoInfo]) -> Bool {
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        let todayEnd = calendar.date(byAdding: .day, value: 1, to: todayStart)!
        
        // 오늘 등록된 사진이 있는지 확인
        return photos.contains { photoInfo in
            photoInfo.date >= todayStart && photoInfo.date < todayEnd
        }
    }
    
    
    
    
    // 날짜 추천
    func daterecommendPhotos(photos: [PhotoInfo]) -> [PhotoInfo] {
        let yearPhotos = recommendPhotosWithSameDateDifferentYear(photos: photos)
        let monthPhotos = recommendPhotosWithSameDate(photos: photos)
        
        var recommendedPhotos: [PhotoInfo] = []
        
        // N년 전 오늘의 사진이 있는 경우
        if !yearPhotos.isEmpty {
            // N년 전 오늘 사진 중 랜덤으로 최대 5장 추천
            let randomYearPhotos = yearPhotos.shuffled().prefix(5)
            recommendedPhotos.append(contentsOf: randomYearPhotos)
        }
        
        // N년 전 오늘 사진이 부족한 경우, N개월 전 오늘 사진으로 채우기
        if recommendedPhotos.count < maxCount {
            let remainingCount = maxCount - recommendedPhotos.count
            let additionalMonthPhotos = monthPhotos.shuffled().prefix(remainingCount)
            recommendedPhotos.append(contentsOf: additionalMonthPhotos)
        }
        
        // 5장 이하일 경우, 랜덤으로 추가 추천
        if recommendedPhotos.count < maxCount {
            let remainingCount = maxCount - recommendedPhotos.count
            let randomPhotos = recommendRandomPhotos(photos: photos, count: remainingCount)
            recommendedPhotos.append(contentsOf: randomPhotos)
        }
        
        return Array(recommendedPhotos.prefix(maxCount)) // 최대 5장 반환
    }
    
    // N년 전 오늘
    private func recommendPhotosWithSameDateDifferentYear(photos: [PhotoInfo]) -> [PhotoInfo] {
        let calendar = Calendar.current
        let today = Date()
        
        let components = calendar.dateComponents([.month, .day], from: today)
        
        // 오늘의 날짜와 같은 월, 일을 가진 사진 필터링
        return photos.filter { photoInfo in
            let photoComponents = calendar.dateComponents([.month, .day], from: photoInfo.date)
            return photoComponents.month == components.month && photoComponents.day == components.day
        }
    }
    
    // N개월 전 오늘
    private func recommendPhotosWithSameDate(photos: [PhotoInfo]) -> [PhotoInfo] {
        let calendar = Calendar.current
        let today = Date()
        
        var allMonthPhotos: [PhotoInfo] = []
        
        // 과거 12개월 동안의 사진을 찾기
        for monthsBack in 1...12 {
            guard let nMonthsAgoDate = calendar.date(byAdding: .month, value: -monthsBack, to: today) else {
                continue
            }
            
            let nMonthsAgoComponents = calendar.dateComponents([.month, .day], from: nMonthsAgoDate)
            
            // N개월 전과 같은 월, 일을 가진 사진 필터링
            let monthPhotos = photos.filter { photoInfo in
                let photoComponents = calendar.dateComponents([.month, .day], from: photoInfo.date)
                return photoComponents.month == nMonthsAgoComponents.month && photoComponents.day == nMonthsAgoComponents.day
            }
            
            allMonthPhotos.append(contentsOf: monthPhotos)
        }
        
        return allMonthPhotos
    }
    
    // 랜덤으로 N장 추천
    private func recommendRandomPhotos(photos: [PhotoInfo], count: Int) -> [PhotoInfo] {
        guard photos.count > 0 else { return [] }
        
        var recommendedPhotos = Set<PhotoInfo>()
        
        while recommendedPhotos.count < count {
            if let randomPhoto = photos.randomElement() {
                recommendedPhotos.insert(randomPhoto)
            }
        }
        
        return Array(recommendedPhotos)
    }
    
    
    //    텍스트
    func calculateJaccardSimilarity(text1: String, text2: String) -> Double {
        let words1 = Set(text1.lowercased().split(separator: " "))
        let words2 = Set(text2.lowercased().split(separator: " "))
        
        let intersection = words1.intersection(words2).count
        let union = words1.union(words2).count
        
        guard union != 0 else { return 0.0 }
        
        return Double(intersection) / Double(union)
    }
    
    //    그룹
    func calculateGroupSimilarity(group1: String, group2: String) -> Double {
        return group1 == group2 ? 1.0 : 0.0
    }
    
    func calculateSimilarity(photo1: PhotoInfo, photo2: PhotoInfo) -> Double {
        // 텍스트 유사도 (Jaccard 유사도)
        let textSimilarity = calculateJaccardSimilarity(text1: photo1.text, text2: photo2.text)
        
        // 그룹 유사도
        let groupSimilarity = calculateGroupSimilarity(group1: photo1.groupName, group2: photo2.groupName)
        
        // 총 유사도 점수 계산 (가중치 조정 가능)
        let totalSimilarity: Double
        if textSimilarity == 0 {
            // 텍스트 유사도가 0인 경우, 그룹 유사도만 고려
            totalSimilarity = groupSimilarity * 0.7
        } else {
            totalSimilarity = (textSimilarity * 0.3) + (groupSimilarity * 0.7)
        }
        
        return totalSimilarity
    }
    
    
    func scorerecommendPhotos(inputPhoto: PhotoInfo, allPhotos: [PhotoInfo]) -> [PhotoInfo] {
        var similarities: [(photo: PhotoInfo, score: Double)] = []
        
        for photo in allPhotos {
            let score = calculateSimilarity(photo1: inputPhoto, photo2: photo)
            similarities.append((photo: photo, score: score))
        }
        
        similarities.sort { $0.score > $1.score }
        print("\(maxCount)")
        
        return similarities.prefix(maxCount).map { $0.photo }
    }
}



#Preview {
    //    HomeView(stack: .constant(NavigationPath()))
    NavigationStack{
        HomeView()
            .modelContainer(for: [PhotoInfo.self, GroupInfo.self])
    }
}

