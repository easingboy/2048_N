//
//  File.swift
//  2048
//
//  Created by jackyjiao on 7/14/14.
//  Copyright (c) 2014 jackyjiao. All rights reserved.
//

import UIKit

class GameboardView : UIView {
    var dimension: Int
    
    var paddingWidth: CGFloat = 5.0
    var blockWidth: CGFloat = 55.0
    
    var boardWidth: CGFloat = 305.0
    var boardX: CGFloat = 7.0
    var boardY: CGFloat = 150.0
    var viewTotalPadding: CGFloat = 40.0
    var cornerRadius: CGFloat = 10.0
    
    var colorDesignInterface: ColorDesign = ColorDesign()
    
    var blockDict: Dictionary<NSIndexPath, BlockView>
    var blockData: GameboardModel
    var scoreTotal:Int = 0
    var scoreView: ScoreView
    var viewcontrlInterface:Protocol4GameView
    
    init(dimension d: Int, delegate:Protocol4GameView) {
        assert(d > 0)
        dimension = d > 2 ? d : 2
        blockWidth = (boardWidth-CGFloat(dimension+1)*paddingWidth)/CGFloat(dimension)
        viewcontrlInterface = delegate
        blockDict = Dictionary()
        blockData = GameboardModel(dim: dimension)
        scoreView = ScoreView(score: 0)
        
        
        super.init(frame: CGRect(x: 0, y: 0, width: blockWidth, height: blockWidth))

        addSubview(scoreView)
        setupBackground()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackground() {
        let background = UIView(frame: CGRect(x: boardX, y: boardY, width: boardWidth, height: boardWidth))
        background.layer.cornerRadius = cornerRadius
        background.backgroundColor = colorDesignInterface.bgcolorForBoard()
        addSubview(background)
        
        for i in 0...dimension {
            for j in 0...dimension {
                // Draw each tile
                let background = UIView(frame: CGRect(x: boardX + paddingWidth + CGFloat(i) * (blockWidth+paddingWidth), y: boardY + paddingWidth + CGFloat(j) * (blockWidth+paddingWidth), width: blockWidth, height: blockWidth))
                background.layer.cornerRadius = cornerRadius
                background.backgroundColor = colorDesignInterface.bgcolorForBlock()
                addSubview(background)
            }
        }
        insertRandom()
        insertRandom()
    }
    
    
    func resetGame() {
        blockData.resetModel()
        scoreTotal = 0
        scoreView.scoreChanged(newScore: 0)
        for (key, block) in blockDict {
            block.removeFromSuperview()
        }
        blockDict.removeAll(keepingCapacity: true)
        insertRandom()
        insertRandom()
    }
    
    func insertRandom() {
        var randomInt = Int(arc4random_uniform(UInt32(9)))
        randomInt = (randomInt/8) * 2 + 2
        var index = blockData.insertData(value: randomInt)
        var y = index/dimension
        var x = index - dimension * y
        insertBlock(position: (x, y), value: randomInt)
        if blockData.isGameOver(){
            viewcontrlInterface.enableRstBtn()
            let alertView = UIAlertView()
            alertView.title = "Game Over"
            alertView.message = "Your Score:\(scoreTotal)"
            alertView.addButton(withTitle: "OK")
            alertView.show()
        }
    }
    
    func insertBlock(position:(Int, Int), value: Int) {
        let (posx, posy) = position
        assert(blockDict[NSIndexPath(row: posx, section: posy)] == nil)
        let zeroposition = CGPoint(x: boardX, y: boardY)
        let block = BlockView(zeroPosition: zeroposition, posx: posx, posy: posy, value: value, blockWidth:blockWidth)
        block.layer.setAffineTransform(CGAffineTransform(scaleX: 0, y: 0))
        addSubview(block)
        blockDict[NSIndexPath(row: posx, section: posy)] = block
        UIView.animate(withDuration: 0.18, delay: 0.25, options: [],
            animations: { () -> Void in
                // Make the tile 'pop'
                block.layer.setAffineTransform(CGAffineTransform(scaleX: 1.1, y: 1.1))
            },
            completion: { (finished: Bool) -> Void in
                    // Shrink the tile after it 'pops'
                    UIView.animate(withDuration: 0.08, animations: { () -> Void in
                        block.layer.setAffineTransform(CGAffineTransform(scaleX: 1.0, y: 1.0))
                    })
            })
    }
    
    func moveOneBlock(from:(Int, Int), to:(Int, Int)) {
        let (fromX, fromY) = from
        let (toX, toY) = to
        //println("1.from:\(from) to:\(to)")
        let fromKey = NSIndexPath(row: fromX, section: fromY)
        let toKey = NSIndexPath(row: toX, section:toY)
        var zeroposition = CGPoint(x: boardX, y: boardY)
        assert(blockDict[fromKey] != nil)
        var block = blockDict[fromKey]
        
        var finalFrame = block!.frame
        finalFrame.origin.x = finalFrame.origin.x + CGFloat(toX - fromX)*(paddingWidth + blockWidth)
        finalFrame.origin.y = finalFrame.origin.y + CGFloat(toY - fromY)*(paddingWidth + blockWidth)
        UIView.animate(withDuration: 0.18, delay: 0.05, options: UIView.AnimationOptions.beginFromCurrentState,
            animations: { () -> Void in
                block!.frame = finalFrame
            },
            completion: { (finished: Bool) -> Void in
            UIView.animate(withDuration: 0.08, animations: { () -> Void in
                block!.layer.setAffineTransform(CGAffineTransform(scaleX: 1.0, y: 1.0))
                    })
            })
        blockDict.removeValue(forKey: fromKey)
        blockDict[toKey] = block
        //println("\(blockDict.count)")
    }
    
    func moveTwoBlock(from:((Int, Int), (Int, Int)), to:(Int, Int), value:Int) {
        let ((from1X, from1Y), (from2X, from2Y)) = from
        let (toX, toY) = to
        //println("2..from:\(from) to:\(to) value:\(value)")
        let fromKey1 = NSIndexPath(row: from1X, section: from1Y)
        let fromKey2 = NSIndexPath(row: from2X, section: from2Y)
        let toKey = NSIndexPath(row: toX, section:toY)
        var zeroposition = CGPoint(x: boardX, y: boardY)
        assert(blockDict[fromKey1] != nil)
        assert(blockDict[fromKey2] != nil)
        var block1 = blockDict[fromKey1]
        var block2 = blockDict[fromKey2]
        
        var finalFrame = block1!.frame
        finalFrame.origin.x = finalFrame.origin.x + CGFloat(toX - from1X)*(paddingWidth + blockWidth)
        finalFrame.origin.y = finalFrame.origin.y + CGFloat(toY - from1Y)*(paddingWidth + blockWidth)
        UIView.animate(withDuration: 0.18, delay: 0.0, options: UIView.AnimationOptions.beginFromCurrentState,
            animations: { () -> Void in
                block1!.frame = finalFrame
                block2!.frame = finalFrame
            },
            completion: { (finished: Bool) -> Void in
                block1!.blockValue = value
                block2!.removeFromSuperview()
            block1!.layer.setAffineTransform(CGAffineTransform(scaleX: 1.0, y: 1.0))
            UIView.animate(withDuration: 0.08, animations: { () -> Void in
                block1!.layer.setAffineTransform(CGAffineTransform(scaleX: 1.1, y: 1.1))
                    },
                completion: { (finished: Bool) -> Void in
                    block1!.layer.setAffineTransform(CGAffineTransform.identity)
                })
        })
        blockDict.removeValue(forKey: fromKey1)
        blockDict.removeValue(forKey: fromKey2)
        blockDict[toKey] = block1
        scoreTotal = scoreTotal + value
        //println("score:\(scoreTotal)")
        scoreView.scoreChanged(newScore: scoreTotal)
    }
    
    func flick(direct:Int) {
        //left : 3
        //right: 2
        //up   : 1
        //down : 0
        var leftright_or_updown = (direct/2)*2-1   //1:left_right    -1:up_down(交换坐标)
        var leftup_or_rightdown = (direct%2)*2-1   //1:left_up       -1:right_down(逆序)

        var hasChangeFlag:Bool = false
        var getLastValueFlag:Bool
        var lastValue:Int
        var lastIndex:Int
        var movedIndex:Int
        for di in 0...dimension {
            getLastValueFlag = false
            lastValue = -1
            if leftup_or_rightdown == 1 {
                lastIndex = -1
                movedIndex = 0
            }
            else {
                lastIndex = dimension
                movedIndex = dimension-1
            }
            for j in 0...dimension {
                var dj:Int = 0
                if leftup_or_rightdown == 1 {dj = j}
                else {dj = dimension-1 - j}
                var currentValue: Int = 0
                if leftright_or_updown == 1 { currentValue = blockData[di, dj] }
                else { currentValue = blockData[dj, di] }
                if currentValue != 0 {
                    //println("current_i:\(di) current_j:\(dj) getLastValueFlag:\(getLastValueFlag) lastValue:\(lastValue) lastIndex:\(lastIndex) currentValue:\(currentValue) movedIndex:\(movedIndex)")
                    if getLastValueFlag {
                        if currentValue != lastValue { //两个值不同
                            if leftup_or_rightdown*lastIndex > leftup_or_rightdown*movedIndex { //需要移动
                                if leftright_or_updown == 1 {
                                    moveOneBlock(from: (lastIndex, di), to:(movedIndex, di))
                                    blockData[di, movedIndex] = lastValue
                                    blockData[di, lastIndex] = 0
                                }
                                else {
                                    moveOneBlock(from: (di, lastIndex), to:(di, movedIndex))
                                    blockData[movedIndex, di] = lastValue
                                    blockData[lastIndex, di] = 0
                                }
                                hasChangeFlag = true
                            }
                            lastValue = currentValue
                            lastIndex = dj
                        }
                        else {//两个值相同
                            if leftright_or_updown == 1 {
                                moveTwoBlock(from: ((lastIndex, di), (dj, di)), to:(movedIndex, di), value:(lastValue + currentValue))
                                blockData[di, lastIndex] = 0
                                blockData[di, dj] = 0
                                blockData[di, movedIndex] = lastValue + currentValue
                            }
                            else {
                                moveTwoBlock(from: ((di, lastIndex), (di, dj)), to:(di, movedIndex), value:(lastValue + currentValue))
                                blockData[lastIndex, di] = 0
                                blockData[dj, di] = 0
                                blockData[movedIndex, di] = lastValue + currentValue
                            }
                            hasChangeFlag = true
                            getLastValueFlag = false
                            lastValue = -1
                            if leftup_or_rightdown == 1 {lastIndex = -1}
                            else {lastIndex = dimension}
                        }
                        movedIndex = movedIndex + leftup_or_rightdown
                    }
                    else {
                        getLastValueFlag = true
                        lastValue = currentValue
                        lastIndex = dj
                    }
                }
            }
            if getLastValueFlag && leftup_or_rightdown*lastIndex > leftup_or_rightdown*movedIndex { //处理最后一个数
                if leftright_or_updown == 1 {
                    moveOneBlock(from: (lastIndex, di), to:(movedIndex, di))
                    blockData[di, movedIndex] = lastValue
                    blockData[di, lastIndex] = 0
                }
                else {
                    moveOneBlock(from: (di, lastIndex), to:(di, movedIndex))
                    blockData[movedIndex, di] = lastValue
                    blockData[lastIndex, di] = 0
                }
                hasChangeFlag = true
            }
        }
        if hasChangeFlag {
            insertRandom()
        }
    }

    //======================================================================================
    
    
}
