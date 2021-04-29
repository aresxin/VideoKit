
import UIKit
import AVFoundation


extension Array where Element: BaseAnimationLayer {
    func totalDuration() -> Double {
        var duration: Double = 0
        for element in self {
            duration = duration + element.duration
        }
        return duration
    }
}

open class BaseAnimationLayer {
    let frame: CGRect
    let delay: TimeInterval
    let duration: TimeInterval
    let backgroundColor: UIColor

    var startAnimation: CAAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = timeRange.start.seconds == 0.0 ? 1.0 : 0.0
        animation.toValue = 1.0
        animation.beginTime = AVCoreAnimationBeginTimeAtZero + timeRange.start.seconds
        animation.duration = 0.01
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }

    var endAnimation: CAAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.beginTime = AVCoreAnimationBeginTimeAtZero + timeRange.start.seconds + timeRange.duration.seconds
        animation.duration = 0.01
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        return animation
    }
    
    var layer: CALayer {
        fatalError("Subclasses need to implement the `layer` property.")
    }

    var timeRange: CMTimeRange {
        let timescale: Double = 1000

        let startTime = CMTimeMake(value: Int64(delay*timescale), timescale: Int32(timescale))
        let durationTime = CMTimeMake(value: Int64(duration*timescale), timescale: Int32(timescale))

        return CMTimeRangeMake(start: startTime, duration: durationTime)
    }

    init(frame: CGRect,
         delay: TimeInterval,
         duration: TimeInterval,
         backgroundColor: UIColor = UIColor.clear) {

        self.frame = frame
        self.delay = delay
        self.duration = duration
        self.backgroundColor = backgroundColor
    }
}
