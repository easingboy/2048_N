//
//  NumberGame.swift
//  2048
//
//  Created by jackyjiao on 7/14/14.
//  Copyright (c) 2014 jackyjiao. All rights reserved.
//

import Foundation
import UIKit

@class_protocol protocol Protocol4GameView {
    func enableRstBtn()
}

class NumberGameViewController : UIViewController, Protocol4GameView {
    var dimension: Int
    
    var colorDesignInterface: ColorDesign = ColorDesign()
    var board: GameboardView?
    var model: GameboardModel?
    
    var resetBtn:UIButton

    init(dimension d: Int) {
        dimension = d > 2 ? d : 2
        resetBtn = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = colorDesignInterface.bgcolor()
        setupGestureControls()
    }
    
    // View Controller
    override func viewDidLoad()  {
        super.viewDidLoad()
        setupGameView()
        //reset button
        resetBtn.frame = CGRectMake(50, 262, 220, 80)//CGRect(x:80, y:460, width:160, height:60)
        resetBtn.setTitle("重新开始",forState:.Normal)
        resetBtn.layer.cornerRadius = 10.0
        resetBtn.backgroundColor = UIColor.grayColor()
        resetBtn.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        resetBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        resetBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        resetBtn.addTarget(self, action: Selector("buttonClick:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setupGameView() {
        board = GameboardView(dimension:dimension, delegate:self)
        view.addSubview(board)
    }
    
    func changeDimension(dim:Int) {
        board!.removeFromSuperview()
        board = GameboardView(dimension:dim, delegate:self)
        view.addSubview(board)
    }
    
    
    func setupGestureControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("upCommand"))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("downCommand"))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("leftCommand"))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("rightCommand"))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(rightSwipe)
    }

    func enableRstBtn() {
        view.addSubview(resetBtn)
    }
    
    func buttonClick(sender:UIButton!) {
        board!.resetGame()
        resetBtn.removeFromSuperview()
    }
    
    func upCommand() {
        board!.upFlick()
    }
    
    func downCommand() {
        board!.downFlick()
    }
    
    func leftCommand() {
        board!.leftFlick()
    }
    
    func rightCommand() {
        board!.rightFlick()
    }
}