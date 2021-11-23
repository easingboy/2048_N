//
//  NumberGame.swift
//  2048
//
//  Created by jackyjiao on 7/14/14.
//  Copyright (c) 2014 jackyjiao. All rights reserved.
//

import Foundation
import UIKit

protocol Protocol4GameView {
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
        resetBtn = UIButton(type: UIButton.ButtonType.custom) as UIButton
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = colorDesignInterface.bgcolor()
        setupGestureControls()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // View Controller
    override func viewDidLoad()  {
        super.viewDidLoad()
        setupGameView()
        //reset button
        resetBtn.frame = CGRect(x: 50, y: 262, width: 220, height: 80)//CGRect(x:80, y:460, width:160, height:60)
        resetBtn.setTitle("重新开始", for: UIControl.State.normal)
        resetBtn.layer.cornerRadius = 10.0
        resetBtn.backgroundColor = UIColor.gray
        //resetBtn.font = UIFont(name: "HelveticaNeue-Bold", size: 30)!//todo
        resetBtn.setTitleColor(UIColor.gray, for: UIControl.State.highlighted)
        resetBtn.setTitleColor(UIColor.red, for: UIControl.State.normal)
        resetBtn.addTarget(self, action: Selector("buttonClick:"), for: UIControl.Event.touchUpInside)
    }
    
    func setupGameView() {
        board = GameboardView(dimension:dimension, delegate:self)
        view.addSubview(board!)
    }
    
    func changeDimension(dim:Int) {
        board!.removeFromSuperview()
        board = GameboardView(dimension:dim, delegate:self)
        view.addSubview(board!)
    }
    
    
    func setupGestureControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("upCommand"))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("downCommand"))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("leftCommand"))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("rightCommand"))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }

    func enableRstBtn() {
        view.addSubview(resetBtn)
    }
    
    func buttonClick(sender:UIButton!) {
        board!.resetGame()
        resetBtn.removeFromSuperview()
    }
    
    func leftCommand() {
        board!.flick(direct: 3)
    }
    
    func rightCommand() {
        board!.flick(direct: 2)
    }
    
    func upCommand() {
        board!.flick(direct: 1)
    }
    
    func downCommand() {
        board!.flick(direct: 0)
    }

}
