//
//  ViewController.swift
//  VideoKit
//

import UIKit
import AVKit

class ViewController: UIViewController {

    var path: String?
    var images: [UIImage] = []
    var layers: [BaseAnimationLayer] = []
    lazy var composition: MediaComposition = {
        let temp = MediaComposition()
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image1 = UIImage(named: "cheese@2x")!
        let image2 = UIImage(named: "kxk@2x")!
        let image3 = UIImage(named: "guide@2x")!
        images = [image1, image2, image3]

        let rect = CGRect(x: 0, y: 0, width: 720, height: 1280)
        let layer1 = PositionAnimationLayer(image: image1, frame: rect, delay: 0, duration: 3)
        let layer2 = PositionAnimationLayer(image: image2, frame: rect, delay: 3, duration: 3)
        let layer3 = PositionAnimationLayer(image: image3, frame: rect, delay: 6, duration: 3)
        layers = [layer1, layer2, layer3]

    }

    @IBAction func compositionAnimationAction(_ sender: UIButton) {
        #if false
        composition.picTime = 3
        composition.imagesVideoAnimation(with: images, progress: { (progress) in
            print("合成进度",progress)
        }, success: {[weak self] (path) in
            guard let `self` = self else {return}
            print("合成后地址",path)
            self.path = path
        }) { (errMessage) in
            print("合成失败",errMessage ?? "")
        }
        #else
        composition.imagesVideo(with: layers) { progress in
            print("合成进度",progress)
        } success: { [weak self] path in
            guard let `self` = self else {return}
            print("合成后地址",path)
            self.path = path
        } failure: { errMessage in
            print("合成失败",errMessage ?? "")
        }

        #endif
    }

    @IBAction func playAction(_ sender: UIButton) {
        guard let path = path else { return }
        let ctrl = AVPlayerViewController()
        ctrl.player = AVPlayer(url: URL(fileURLWithPath: path))
        self.present(ctrl, animated: true, completion: nil)
    }

}

