//
//  ViewController.swift
//  ZeroSpeedDemo
//
//  Created by Alessandro Marzoli on 29/09/17.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

  var containerView: EmojiView?

  let maxContainerSize = CGSize(width: 300, height: 540)

  var currentContainerExpansion: Double = 0 {
    didSet {
      containerView?.layer.timeOffset = currentContainerExpansion
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black

    let point = CGPoint(x: view.bounds.midX - maxContainerSize.width / 2, y: view.bounds.midY - maxContainerSize.height / 2)
    let containerFrame = CGRect(origin: point, size: maxContainerSize)
    let containerView = EmojiView(frame: containerFrame)
    view.addSubview(containerView)
    self.containerView = containerView

    setupAnimations()

    let rec = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    view.addGestureRecognizer(rec)
  }

  @objc func handlePan(_ recognizier: UIPanGestureRecognizer) {
    let dragDistanceY = recognizier.translation(in: view).y
    let scaledDragAmount = Double(dragDistanceY / maxContainerSize.height) // scale from ~0.height to ~0...1

    currentContainerExpansion = min(max(currentContainerExpansion + scaledDragAmount, 0), 1) // clamp to 0-1 range so we don't have to set a fill mod e on the main animation

    recognizier.setTranslation(.zero, in: view)
  }

  func setupAnimations() {

    if let containerLayer = containerView?.layer, let emojiLayers = containerView?.emojiLayers {

      containerLayer.speed = 0
      let animation = CABasicAnimation(keyPath: "bounds.size.height")
      animation.fromValue = 80
      animation.toValue = maxContainerSize.height
      animation.duration = 1
      animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

      let widthAnimation = CABasicAnimation(keyPath: "bounds.size.width")
      widthAnimation.fromValue = 80
      widthAnimation.toValue = maxContainerSize.width
      widthAnimation.duration = 0.2
      widthAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

      containerLayer.add(animation, forKey: nil)
      containerLayer.add(widthAnimation, forKey: nil)

      let baseStartTime = containerLayer.convertTime(CACurrentMediaTime(), from: nil)
      for i in emojiLayers.indices {
        let layer = emojiLayers[i]

        let animation = CABasicAnimation(keyPath: "transform.scale.xy")
        animation.fromValue = 0.01
        animation.toValue = 1
        animation.duration = 0.1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.beginTime = baseStartTime + 0.028 * Double(i)
        animation.fillMode = kCAFillModeBackwards

        layer.add(animation, forKey: nil)
      }
    }
  }

  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

