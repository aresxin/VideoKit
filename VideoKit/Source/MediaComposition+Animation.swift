

import Foundation
import AVFoundation
import UIKit

extension MediaComposition {
    public func imagesVideo(with layers: [BaseAnimationLayer], progress: ProgressBlock?, success: SuccessBlock?, failure: FailureBlock?) {
        guard let videoPath = videoResource == nil ? Bundle.main.path(forResource: "black", ofType: "mp4") : videoResource else {
            failure?("资源出错")
            return
        }
        
        let tempDuration = layers.totalDuration()
        self.duration = Float(tempDuration > 180.0 ? 180.0 : tempDuration)
        self.progress = progress
        self.failure = failure
        self.success = success
        self.outputPath = NSTemporaryDirectory() + "imagesComposition.mp4"
        let videoAsset = AVURLAsset(url: URL(fileURLWithPath: videoPath))
        let mutableComposition = AVMutableComposition()
        guard let videoCompositionTrack = mutableComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid), let videoAssetTrack = videoAsset.tracks(withMediaType: .video).first else {
            failure?("视频轨道出错")
            return
        }
        //合成视频时间
        let endTime = CMTime(value: CMTimeValue(videoAsset.duration.timescale * Int32(duration)), timescale: videoAsset.duration.timescale)
        let timeR = CMTimeRangeMake(start: .zero, duration: endTime)
        do {
            try videoCompositionTrack.insertTimeRange(timeR, of: videoAssetTrack, at: .zero)
        }catch {
            failure?(error.localizedDescription)
            return
        }
        //创建合成指令
        let videoCompostionInstruction = AVMutableVideoCompositionInstruction()
        //设置时间范围
        videoCompostionInstruction.timeRange = timeR
        //创建层指令，并将其与合成视频轨道相关联
        let videoLayerInstruction = AVMutableVideoCompositionLayerInstruction.init(assetTrack: videoCompositionTrack)
        videoLayerInstruction.setTransform(videoAssetTrack.preferredTransform, at: .zero)
        videoLayerInstruction.setOpacity(0, at: endTime)
        videoCompostionInstruction.layerInstructions = [videoLayerInstruction]
        //创建视频组合
        let mutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.renderSize = naturalSize
        //设置帧率
        mutableVideoComposition.frameDuration = CMTime(value: 1, timescale: CMTimeScale(frameNumber))
        mutableVideoComposition.instructions = [videoCompostionInstruction]
        addLayer(mutableVideoComposition, layers: layers)
        setupAssetExport(mutableComposition, videoCom: mutableVideoComposition)
    }


    private func addLayer(_ composition: AVMutableVideoComposition, layers: [BaseAnimationLayer]) {
        let bgLayer = CALayer()
        bgLayer.frame = CGRect(x: 0, y: 0, width: naturalSize.width, height: naturalSize.height)
        bgLayer.position = CGPoint(x: naturalSize.width / 2, y: naturalSize.height / 2)
        //必须设置backgroundColor否则crash
        bgLayer.backgroundColor = UIColor.black.cgColor

        for layer in layers {
            let calayer = layer.layer
            calayer.add(layer.startAnimation, forKey: "startAnimation")
            calayer.add(layer.endAnimation, forKey: "endAnimation")
            bgLayer.addSublayer(calayer)
        }

        let parentLayer = CALayer()
        let videoLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: naturalSize.width, height: naturalSize.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: naturalSize.width, height: naturalSize.height)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(bgLayer)
        parentLayer.isGeometryFlipped = true
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    }
}
