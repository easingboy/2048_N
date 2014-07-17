//
//  ScoreView.swift
//  2048
//
//  Created by jackyjiao on 7/16/14.
//  Copyright (c) 2014 jackyjiao. All rights reserved.
//

import UIKit

class ScoreView : UIView {
    var colorDesignInterface: ColorDesign = ColorDesign()
    let defaultFrame = CGRectMake(10, 30, 300, 110)
    let defaultFrame1 = CGRectMake(130, 30, 180, 50)
    var label: UILabel
    var logoLabel: UILabel
    var authLabel: UILabel
    var logoView: UIView
    var scoreBlock: UIView
    var score: Int = 0 {
        didSet {
            label.text = "分数: \(score)"
        }
    }
    
    init(score:Int) {
        label = UILabel(frame: CGRectMake(120, 0, 180, 60))
        label.textAlignment = NSTextAlignment.Center
        scoreBlock = UIView(frame: CGRectMake(120, 0, 180, 60))
        scoreBlock.backgroundColor = colorDesignInterface.bgcolorForBoard()
        scoreBlock.layer.cornerRadius = 10.0
        logoLabel = UILabel(frame: CGRectMake(0, 0, 110, 110))
        logoLabel.textAlignment = NSTextAlignment.Center
        logoLabel.text = "2048"
        logoLabel.textColor = UIColor.whiteColor()
        logoLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        
        authLabel = UILabel(frame: CGRectMake(120, 70, 180, 40))
        authLabel.textAlignment = NSTextAlignment.Center
        authLabel.text = "成功在于积累"
        authLabel.font = UIFont(name: "HelveticaNeue", size: 25)
        
        logoView = UIView(frame: CGRectMake(0, 0, 110, 110))
        logoView.backgroundColor = UIColor.orangeColor()
        logoView.layer.cornerRadius = 10.0

        super.init(frame: defaultFrame)
        //backgroundColor = colorDesignInterface.bgcolorForBoard()
        label.textColor = UIColor.whiteColor()
        label.font = colorDesignInterface.fontForNumbers()
        label.text = "分数: 0"
        layer.cornerRadius = 10.0
        self.addSubview(logoView)
        self.addSubview(scoreBlock)
        self.addSubview(label)
        self.addSubview(logoLabel)
        self.addSubview(authLabel)
    }
    
    func scoreChanged(newScore s: Int)  {
        score = s
    }
}