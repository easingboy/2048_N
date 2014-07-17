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
        
        
        super.init(frame: CGRectMake(0, 0, blockWidth, blockWidth))

        addSubview(scoreView)
        setupBackground()
        
    }
    
    func setupBackground() {
        let background = UIView(frame: CGRectMake(boardX, boardY, boardWidth, boardWidth))
        background.layer.cornerRadius = cornerRadius
        background.backgroundColor = colorDesignInterface.bgcolorForBoard()
        addSubview(background)
        
        for i in 0..dimension {
            for j in 0..dimension {
                // Draw each tile
                let background = UIView(frame: CGRectMake(boardX + paddingWidth + CGFloat(i) * (blockWidth+paddingWidth), boardY + paddingWidth + CGFloat(j) * (blockWidth+paddingWidth), blockWidth, blockWidth))
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
        blockDict.removeAll(keepCapacity: true)
        insertRandom()
        insertRandom()
    }
    
    func insertRandom() {
        var randomInt = Int(arc4random_uniform(UInt32(9)))
        randomInt = (randomInt/8) * 2 + 2
        var index = blockData.insertData(randomInt)
        var y = index/dimension
        var x = index - dimension * y
        insertBlock((x, y), value: randomInt)
        if blockData.isGameOver(){
            viewcontrlInterface.enableRstBtn()
            let alertView = UIAlertView()
            alertView.title = "Game Over"
            alertView.message = "Your Score:\(scoreTotal)"
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
    }
    
    func insertBlock(position:(Int, Int), value: Int) {
        let (posx, posy) = position
        assert(blockDict[NSIndexPath(forRow: posx, inSection: posy)] == nil)
        let zeroposition = CGPointMake(boardX, boardY)
        let block = BlockView(zeroPosition: zeroposition, posx: posx, posy: posy, value: value, blockWidth:blockWidth)
        block.layer.setAffineTransform(CGAffineTransformMakeScale(0, 0))
        addSubview(block)
        blockDict[NSIndexPath(forRow: posx, inSection: posy)] = block
        UIView.animateWithDuration(0.18, delay: 0.25, options: UIViewAnimationOptions.TransitionNone,
            animations: { () -> Void in
                // Make the tile 'pop'
                block.layer.setAffineTransform(CGAffineTransformMakeScale(1.1, 1.1))
            },
            completion: { (finished: Bool) -> Void in
                // Shrink the tile after it 'pops'
                UIView.animateWithDuration(0.08, animations: { () -> Void in
                    block.layer.setAffineTransform(CGAffineTransformMakeScale(1.0, 1.0))
                    })
            })
    }
    
    func moveOneBlock(from:(Int, Int), to:(Int, Int)) {
        let (fromX, fromY) = from
        let (toX, toY) = to
        //println("1.from:\(from) to:\(to)")
        let fromKey = NSIndexPath(forRow: fromX, inSection: fromY)
        let toKey = NSIndexPath(forRow: toX, inSection:toY)
        var zeroposition = CGPointMake(boardX, boardY)
        assert(blockDict[fromKey] != nil)
        var block = blockDict[fromKey]
        
        var finalFrame = block!.frame
        finalFrame.origin.x = finalFrame.origin.x + CGFloat(toX - fromX)*(paddingWidth + blockWidth)
        finalFrame.origin.y = finalFrame.origin.y + CGFloat(toY - fromY)*(paddingWidth + blockWidth)
        UIView.animateWithDuration(0.18, delay: 0.05, options: UIViewAnimationOptions.BeginFromCurrentState,
            animations: { () -> Void in
                block!.frame = finalFrame
            },
            completion: { (finished: Bool) -> Void in
                UIView.animateWithDuration(0.08, animations: { () -> Void in
                    block!.layer.setAffineTransform(CGAffineTransformMakeScale(1.0, 1.0))
                    })
            })
        blockDict.removeValueForKey(fromKey)
        blockDict[toKey] = block
        //println("\(blockDict.count)")
    }
    
    func moveTwoBlock(from:((Int, Int), (Int, Int)), to:(Int, Int), value:Int) {
        let ((from1X, from1Y), (from2X, from2Y)) = from
        let (toX, toY) = to
        //println("2..from:\(from) to:\(to) value:\(value)")
        let fromKey1 = NSIndexPath(forRow: from1X, inSection: from1Y)
        let fromKey2 = NSIndexPath(forRow: from2X, inSection: from2Y)
        let toKey = NSIndexPath(forRow: toX, inSection:toY)
        var zeroposition = CGPointMake(boardX, boardY)
        assert(blockDict[fromKey1] != nil)
        assert(blockDict[fromKey2] != nil)
        var block1 = blockDict[fromKey1]
        var block2 = blockDict[fromKey2]
        
        var finalFrame = block1!.frame
        finalFrame.origin.x = finalFrame.origin.x + CGFloat(toX - from1X)*(paddingWidth + blockWidth)
        finalFrame.origin.y = finalFrame.origin.y + CGFloat(toY - from1Y)*(paddingWidth + blockWidth)
        UIView.animateWithDuration(0.18, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState,
            animations: { () -> Void in
                block1!.frame = finalFrame
                block2!.frame = finalFrame
            },
            completion: { (finished: Bool) -> Void in
                block1!.blockValue = value
                block2!.removeFromSuperview()
                block1!.layer.setAffineTransform(CGAffineTransformMakeScale(1.0, 1.0))
                UIView.animateWithDuration(0.08, animations: { () -> Void in
                    block1!.layer.setAffineTransform(CGAffineTransformMakeScale(1.1, 1.1))
                    },
                completion: { (finished: Bool) -> Void in
                    block1!.layer.setAffineTransform(CGAffineTransformIdentity)
                })
        })
        blockDict.removeValueForKey(fromKey1)
        blockDict.removeValueForKey(fromKey2)
        blockDict[toKey] = block1
        scoreTotal = scoreTotal + value
        //println("score:\(scoreTotal)")
        scoreView.scoreChanged(newScore: scoreTotal)
    }
    
    func leftFlick() {
        var hasChangeFlag:Bool = false
        var getLastValueFlag:Bool
        var lastValue:Int
        var lastIndex:Int
        var movedIndex:Int
        for di in 0..dimension {
            getLastValueFlag = false
            lastValue = -1
            lastIndex = -1
            movedIndex = 0
            for dj in 0..dimension {
                var currentValue: Int = blockData[di, dj]
                if currentValue != 0 {
                    //println("current_i:\(di) current_j:\(dj) getLastValueFlag:\(getLastValueFlag) lastValue:\(lastValue) lastIndex:\(lastIndex) currentValue:\(currentValue) movedIndex:\(movedIndex)")
                    if getLastValueFlag {
                        if currentValue != lastValue { //两个值不同
                            if lastIndex > movedIndex { //需要移动
                                moveOneBlock((lastIndex, di), to:(movedIndex, di))
                                hasChangeFlag = true
                                blockData[di, movedIndex] = lastValue
                                blockData[di, lastIndex] = 0
                            }
                            lastValue = currentValue
                            lastIndex = dj
                        }
                        else {//两个值相同
                            moveTwoBlock(((lastIndex, di), (dj, di)), to:(movedIndex, di), value:(lastValue + currentValue))
                            hasChangeFlag = true
                            blockData[di, lastIndex] = 0
                            blockData[di, dj] = 0
                            blockData[di, movedIndex] = lastValue + currentValue
                            getLastValueFlag = false
                            lastValue = -1
                            lastIndex = -1
                        }
                        movedIndex = movedIndex + 1
                    }
                    else {
                        getLastValueFlag = true
                        lastValue = currentValue
                        lastIndex = dj
                    }
                }
            }
            if getLastValueFlag && lastIndex > movedIndex { //处理最后一个数
                moveOneBlock((lastIndex, di), to:(movedIndex, di))
                hasChangeFlag = true
                blockData[di, movedIndex] = lastValue
                blockData[di, lastIndex] = 0
            }
        }
        if hasChangeFlag {
            insertRandom()
        }
    }
    
    func rightFlick() {
        var hasChangeFlag:Bool = false
        var getLastValueFlag:Bool
        var lastValue:Int
        var lastIndex:Int
        var movedIndex:Int
        for di in 0..dimension {
            var dj:Int = 0
            getLastValueFlag = false
            lastValue = -1
            lastIndex = dimension
            movedIndex = dimension-1
            for j in 0..dimension {
                dj = dimension-1 - j
                var currentValue: Int = blockData[di, dj]
                if currentValue != 0 {
                    //println("current_i:\(di) current_j:\(dj) getLastValueFlag:\(getLastValueFlag) lastValue:\(lastValue) lastIndex:\(lastIndex) currentValue:\(currentValue) movedIndex:\(movedIndex)")
                    if getLastValueFlag {
                        if currentValue != lastValue { //两个值不同
                            if lastIndex < movedIndex { //需要移动
                                moveOneBlock((lastIndex, di), to:(movedIndex, di))
                                hasChangeFlag = true
                                blockData[di, movedIndex] = lastValue
                                blockData[di, lastIndex] = 0
                            }
                            lastValue = currentValue
                            lastIndex = dj
                        }
                        else {//两个值相同
                            moveTwoBlock(((lastIndex, di), (dj, di)), to:(movedIndex, di), value:(lastValue + currentValue))
                            hasChangeFlag = true
                            blockData[di, lastIndex] = 0
                            blockData[di, dj] = 0
                            blockData[di, movedIndex] = lastValue + currentValue
                            getLastValueFlag = false
                            lastValue = -1
                            lastIndex = dimension
                        }
                        movedIndex = movedIndex - 1
                    }
                    else {
                        getLastValueFlag = true
                        lastValue = currentValue
                        lastIndex = dj
                    }
                }
            }
            if getLastValueFlag && lastIndex < movedIndex { //处理最后一个数
                moveOneBlock((lastIndex, di), to:(movedIndex, di))
                hasChangeFlag = true
                blockData[di, movedIndex] = lastValue
                blockData[di, lastIndex] = 0
            }
        }
        if hasChangeFlag {
            insertRandom()
        }
    }

    
    func upFlick() {
        var hasChangeFlag:Bool = false
        var getLastValueFlag:Bool
        var lastValue:Int
        var lastIndex:Int
        var movedIndex:Int
        for dj in 0..dimension {
            getLastValueFlag = false
            lastValue = -1
            lastIndex = -1
            movedIndex = 0
            for di in 0..dimension {
                var currentValue: Int = blockData[di, dj]
                if currentValue != 0 {
                    //println("current_i:\(di) current_j:\(dj) getLastValueFlag:\(getLastValueFlag) lastValue:\(lastValue) lastIndex:\(lastIndex) currentValue:\(currentValue) movedIndex:\(movedIndex)")
                    if getLastValueFlag {
                        if currentValue != lastValue { //两个值不同
                            if lastIndex > movedIndex { //需要移动
                                moveOneBlock((dj, lastIndex), to:(dj, movedIndex))
                                hasChangeFlag = true
                                blockData[movedIndex, dj] = lastValue
                                blockData[lastIndex, dj] = 0
                            }
                            lastValue = currentValue
                            lastIndex = di
                        }
                        else {//两个值相同
                            moveTwoBlock(((dj, lastIndex), (dj, di)), to:(dj, movedIndex), value:(lastValue + currentValue))
                            hasChangeFlag = true
                            blockData[lastIndex, dj] = 0
                            blockData[di, dj] = 0
                            blockData[movedIndex, dj] = lastValue + currentValue
                            getLastValueFlag = false
                            lastValue = -1
                            lastIndex = -1
                        }
                        movedIndex = movedIndex + 1
                    }
                    else {
                        getLastValueFlag = true
                        lastValue = currentValue
                        lastIndex = di
                    }
                }
            }
            if getLastValueFlag && lastIndex > movedIndex { //处理最后一个数
                moveOneBlock((dj, lastIndex), to:(dj, movedIndex))
                hasChangeFlag = true
                blockData[movedIndex, dj] = lastValue
                blockData[lastIndex, dj] = 0
            }
        }
        if hasChangeFlag {
            insertRandom()
        }
    }
    
    func downFlick() {
        var hasChangeFlag:Bool = false
        var getLastValueFlag:Bool
        var lastValue:Int
        var lastIndex:Int
        var movedIndex:Int
        for dj in 0..dimension {
            var di:Int = 0
            getLastValueFlag = false
            lastValue = -1
            lastIndex = dimension
            movedIndex = dimension-1
            for i in 0..dimension {
                di = dimension-1 - i
                var currentValue: Int = blockData[di, dj]
                if currentValue != 0 {
                    //println("current_i:\(di) current_j:\(dj) getLastValueFlag:\(getLastValueFlag) lastValue:\(lastValue) lastIndex:\(lastIndex) currentValue:\(currentValue) movedIndex:\(movedIndex)")
                    if getLastValueFlag {
                        if currentValue != lastValue { //两个值不同
                            if lastIndex < movedIndex { //需要移动
                                moveOneBlock((dj, lastIndex), to:(dj, movedIndex))
                                hasChangeFlag = true
                                blockData[movedIndex, dj] = lastValue
                                blockData[lastIndex, dj] = 0
                            }
                            lastValue = currentValue
                            lastIndex = di
                        }
                        else {//两个值相同
                            moveTwoBlock(((dj, lastIndex), (dj, di)), to:(dj, movedIndex), value:(lastValue + currentValue))
                            hasChangeFlag = true
                            blockData[lastIndex, dj] = 0
                            blockData[di, dj] = 0
                            blockData[movedIndex, dj] = lastValue + currentValue
                            getLastValueFlag = false
                            lastValue = -1
                            lastIndex = dimension
                        }
                        movedIndex = movedIndex - 1
                    }
                    else {
                        getLastValueFlag = true
                        lastValue = currentValue
                        lastIndex = di
                    }
                }
            }
            if getLastValueFlag && lastIndex < movedIndex { //处理最后一个数
                moveOneBlock((dj, lastIndex), to:(dj, movedIndex))
                hasChangeFlag = true
                blockData[movedIndex, dj] = lastValue
                blockData[lastIndex, dj] = 0
            }
        }
        if hasChangeFlag {
            insertRandom()
        }
    }
    
}