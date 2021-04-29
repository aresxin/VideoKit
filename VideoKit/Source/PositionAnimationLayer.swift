

import UIKit
import AVFoundation
public class PositionAnimationLayer: BaseAnimationLayer {
    let image: UIImage
    var videoSize: CGSize {
        return frame.size
    }

    override var layer: CALayer {
        let imageLayer = CALayer()
        imageLayer.contents = image.cgImage
        imageLayer.backgroundColor = backgroundColor.cgColor
        imageLayer.frame = frame
        imageLayer.opacity = 0.0
        imageLayer.anchorPoint = CGPoint(x: 0, y: 0)
        return imageLayer
    }

    override var startAnimation: CAAnimation {

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0.0
        opacity.toValue = 1.0
        opacity.beginTime = AVCoreAnimationBeginTimeAtZero
        opacity.duration = 0.01
        opacity.fillMode = .forwards
        opacity.isRemovedOnCompletion = false


        let animation = CABasicAnimation(keyPath: "position")
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x: videoSize.width, y: 0))
        animation.toValue = NSValue(cgPoint: CGPoint(x: 0, y: 0))

        animation.beginTime = AVCoreAnimationBeginTimeAtZero
        animation.duration = 1
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false


        let group = CAAnimationGroup()
        group.animations = [opacity, animation]
        group.duration = 1
        group.beginTime = AVCoreAnimationBeginTimeAtZero + timeRange.start.seconds
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false

        return group
    }

    init(image: UIImage,
         frame: CGRect,
         delay: TimeInterval,
         duration: TimeInterval,
         backgroundColor: UIColor = UIColor.clear) {

        self.image = image

        super.init(frame: frame, delay: delay, duration: duration, backgroundColor: backgroundColor)
    }
}
