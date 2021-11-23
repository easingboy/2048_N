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
    let defaultFrame = CGRect(x: 10, y: 30, width: 300, height: 110)
    let defaultFrame1 = CGRect(x: 130, y: 30, width: 180, height: 50)
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
        label = UILabel(frame: CGRect(x: 120, y: 0, width: 180, height: 60))
        label.textAlignment = NSTextAlignment.center
        scoreBlock = UIView(frame: CGRect(x: 120, y: 0, width: 180, height: 60))
        scoreBlock.backgroundColor = colorDesignInterface.bgcolorForBoard()
        scoreBlock.layer.cornerRadius = 10.0
        logoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
        logoLabel.textAlignment = NSTextAlignment.center
        logoLabel.text = "2048"
        logoLabel.textColor = UIColor.white
        logoLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)!
        
        authLabel = UILabel(frame: CGRect(x: 120, y: 70, width: 180, height: 40))
        authLabel.textAlignment = NSTextAlignment.center
        authLabel.text = "成功在于积累"
        authLabel.font = UIFont(name: "HelveticaNeue", size: 25)
        
        logoView = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
        logoView.backgroundColor = UIColor.orange
        logoView.layer.cornerRadius = 10.0

        super.init(frame: defaultFrame)
        //backgroundColor = colorDesignInterface.bgcolorForBoard()
        label.textColor = UIColor.white
        label.font = colorDesignInterface.fontForNumbers()
        label.text = "分数: 0"
        layer.cornerRadius = 10.0
        self.addSubview(logoView)
        self.addSubview(scoreBlock)
        self.addSubview(label)
        self.addSubview(logoLabel)
        self.addSubview(authLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scoreChanged(newScore s: Int)  {
        score = s
    }
}
