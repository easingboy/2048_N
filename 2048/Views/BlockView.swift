//
//  BlockView.swift
//  2048
//
//  Created by jackyjiao on 7/15/14.
//  Copyright (c) 2014 jackyjiao. All rights reserved.
//

import UIKit

class BlockView : UIView {
    var width: CGFloat = 55.0
    var paddingWidth: CGFloat = 5.0
    var cornerRadius: CGFloat = 6.0
    var colorDesignInterface: ColorDesign = ColorDesign()
    var blockValue: Int = 0 {
    didSet {
        backgroundColor = colorDesignInterface.blockColor(value: blockValue)
        numberLabel.textColor = colorDesignInterface.numberColor(value: blockValue)
        numberLabel.text = "\(blockValue)"
    }
    }
    var PosX: Int
    var PosY: Int
    var numberLabel: UILabel
    
    init(zeroPosition:CGPoint, posx:Int, posy:Int, value:Int, blockWidth:CGFloat) {
        PosX = posx
        PosY = posy
        blockValue = value
        width = blockWidth
        numberLabel = UILabel(frame: CGRect(x : 0, y : 0, width : width, height : width))
        numberLabel.textAlignment = NSTextAlignment.center
        numberLabel.minimumScaleFactor = 0.5
        numberLabel.font = colorDesignInterface.fontForNumbers()
        numberLabel.textColor = colorDesignInterface.numberColor(value: value)
        numberLabel.text = "\(value)"
        super.init(frame: CGRect(x : zeroPosition.x + paddingWidth + CGFloat(posx) * (width+paddingWidth), y : zeroPosition.y + paddingWidth + CGFloat(posy) * (width+paddingWidth), width : width, height : width))
        layer.cornerRadius = cornerRadius
        backgroundColor = colorDesignInterface.blockColor(value: value)
        addSubview(numberLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
