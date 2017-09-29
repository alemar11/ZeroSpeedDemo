//
//  EmojiView.swift
//  ZeroSpeedDemo
//
//  Created by Alessandro Marzoli on 29/09/17.
//

import UIKit

class EmojiView: UIView {
  let emojiLayers: [CALayer]

  override init(frame: CGRect) {
    let emojiList = "😀😃😄😁😆😅😂🤣☺️😊😇🙂🙃😉😌😍😘😗😙😚😋😜😝😛🤑🤗🤓😎🤡🤠😏😒"
    let screenScale = UIScreen.main.scale
    let cornerInset = 45 // starting x/y position for the grid[weak self] in
    let layerSize = 70

    var index = 0 // to keep track of what column / row we'ew on
    var emojiLayers: [CALayer] = []
    for e in emojiList.characters {
      let layer = CATextLayer()
      layer.string = String(e)
      layer.fontSize = 50
      layer.contentsScale = screenScale
      layer.bounds = CGRect(x: 0, y: 0, width: layerSize, height: layerSize)
      layer.alignmentMode = kCAAlignmentCenter

      let column = index % 4
      let row = (index - column) / 4
      layer.position = CGPoint(x: cornerInset + layerSize * column, y: cornerInset + layerSize * row)

      emojiLayers.append(layer)
      index = index + 1
    }
    self.emojiLayers = emojiLayers

    super.init(frame: frame)

    // this part is not shown in the video (it puts the layer at the top left)
    // ----- from here -----
    layer.backgroundColor = UIColor.white.cgColor
    layer.masksToBounds = true
    layer.cornerRadius = 40
    layer.anchorPoint = .zero
    layer.position = CGPoint(x: 40, y: 80)

    for layer in emojiLayers {
      self.layer.addSublayer(layer)
    }
    // ----- to here -----

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
