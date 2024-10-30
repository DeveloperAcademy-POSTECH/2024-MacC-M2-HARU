//
//  PhotoPickerView.swift
//  Haru
//
//  Created by 김은정 on 10/2/24.
//

import SwiftUI
import PhotosUI
import AVFoundation
import Photos


struct PhotoPickerView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var videoURL: URL?

    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedItems) {
                Text("사진 선택하기")
            }
            .onChange(of: selectedItems) { newItems in
                loadPhotos(newItems)
            }

            if let videoURL = videoURL {
                Button("인스타그램에 공유하기") {
                    shareToInstagram(videoURL: videoURL)
                }
            }
        }
    }

    private func loadPhotos(_ items: [PhotosPickerItem]) {
        var images: [UIImage] = []
        let group = DispatchGroup() // 이미지 로딩을 동기화하기 위한 그룹

        for item in items {
            group.enter() // 그룹에 엔트리 추가

            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        images.append(image)
                    }
                    group.leave() // 그룹에서 엔트리 제거
                case .failure(let error):
                    print("Error loading image data: \(error)")
                    group.leave() // 에러 발생 시 그룹에서 제거
                }
            }
        }

        // 모든 이미지가 로드된 후 동영상 생성
        group.notify(queue: .main) {
            createVideo(from: images) { url in
                if let url = url {
                    videoURL = url
                }
            }
        }
    }
    
    private func createVideo(from images: [UIImage], completion: @escaping (URL?) -> Void) {
        let videoSize = CGSize(width: 1920, height: 1080)
        let videoPath = NSTemporaryDirectory().appending("output.mov")
        
        guard let videoWriter = try? AVAssetWriter(outputURL: URL(fileURLWithPath: videoPath), fileType: .mov) else {
            completion(nil)
            return
        }
        
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: videoSize.width,
            AVVideoHeightKey: videoSize.height
        ]
        
        let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        videoWriter.add(videoInput)
        
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: .zero)
        
        let frameDuration = CMTime(value: 1, timescale: 30) // 1초에 30프레임
        var currentTime = CMTime.zero
        
        for image in images {
            guard let cgImage = image.cgImage else { continue }
            let presentationTime = currentTime
            
            // 이미지에서 비디오 프레임 생성
            if let pixelBuffer = createPixelBuffer(from: cgImage, size: videoSize) {
                let sampleBuffer = createSampleBuffer(from: pixelBuffer, presentationTime: presentationTime)
                if let sampleBuffer = sampleBuffer {
                    videoInput.append(sampleBuffer)
                }
            }
            
            currentTime = CMTimeAdd(currentTime, frameDuration)
        }
        
        videoInput.markAsFinished()
        videoWriter.finishWriting {
            completion(URL(fileURLWithPath: videoPath))
        }
    }
    
    private func createPixelBuffer(from image: CGImage, size: CGSize) -> CVPixelBuffer? {
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(size.width),
                                         Int(size.height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)
        
        guard status == noErr, let buffer = pixelBuffer else { return nil }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        CVPixelBufferUnlockBaseAddress(buffer, [])
        
        return buffer
    }
    
    private func createSampleBuffer(from pixelBuffer: CVPixelBuffer, presentationTime: CMTime) -> CMSampleBuffer? {
        var timingInfo = CMSampleTimingInfo(duration: CMTime(value: 1, timescale: 30),
                                            presentationTimeStamp: presentationTime,
                                            decodeTimeStamp: presentationTime)
        
        // CMVideoFormatDescription 생성
        var formatDescription: CMFormatDescription?
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        
        // codecType을 UInt32로 변환
        let codecType = kCVPixelFormatType_32ARGB // 또는 다른 적절한 코덱 타입으로 수정 가능
        
        let status = CMVideoFormatDescriptionCreate(allocator: kCFAllocatorDefault,
                                                    codecType: codecType,
                                                    width: Int32(width),
                                                    height: Int32(height),
                                                    extensions: nil,
                                                    formatDescriptionOut: &formatDescription)
        
        guard status == noErr, let videoFormatDescription = formatDescription else { return nil }
        
        var sampleBuffer: CMSampleBuffer?
        let sampleBufferStatus = CMSampleBufferCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                                    imageBuffer: pixelBuffer,
                                                                    dataReady: true,
                                                                    makeDataReadyCallback: nil,
                                                                    refcon: nil,
                                                                    formatDescription: videoFormatDescription,
                                                                    sampleTiming: &timingInfo,
                                                                    sampleBufferOut: &sampleBuffer)
        
        return sampleBufferStatus == noErr ? sampleBuffer : nil
    }
    
    
    private func shareToInstagram(videoURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
        // 현재 ViewController에서 activityViewController.present(...)
    }
}



#Preview {
    PhotoPickerView()
}
