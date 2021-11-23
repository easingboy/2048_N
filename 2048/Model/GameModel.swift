//
//  GameModel.swift
//  2048
//
//  Created by jackyjiao on 7/14/14.
//  Copyright (c) 2014 jackyjiao. All rights reserved.
//

import Foundation

class GameboardModel  {
    let dimension: Int
    var boardData: Array<Int>
    
    init(dim: Int) {
        dimension = dim
        boardData = Array<Int>(repeating: 0 , count: dimension*dimension)
    }
    
    subscript(row: Int, col: Int) -> Int {
        get {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            return boardData[row*dimension + col]
        }
        set {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            boardData[row*dimension + col] = newValue
        }
    }
    
    func getEmptyCount() -> Int {
        var emptyCount = 0
        for i in 0...(dimension*dimension) {
            if boardData[i] == 0 {
                emptyCount += 1
            }
        }
        return emptyCount
    }
    
    func insertData(value:Int) -> Int {
        var emptyTotal = getEmptyCount()
        //println("empty\(emptyTotal)")
        let index = Int(arc4random_uniform(UInt32(emptyTotal-1)))
        var emptyCount = 0
        for i in 0...(dimension*dimension) {
            if boardData[i] == 0 {
                if emptyCount == index {
                    boardData[i] = value
                    return i
                }
                emptyCount += 1
            }
        }
        return -1
    }
    
    func isMergeOver() -> Bool {
        var lastValue1:Int
        var currentValue1:Int
        var lastValue2:Int
        var currentValue2:Int
        for i in 0...dimension {
            lastValue1 = -1
            lastValue2 = -1
            for j in 0...dimension {
                currentValue1 = boardData[i*dimension + j]
                currentValue2 = boardData[j*dimension + i]
                if (currentValue1 == lastValue1) || (currentValue2 == lastValue2) {
                    return false
                }
                else {
                    lastValue1 = currentValue1
                    lastValue2 = currentValue2
                }
            }
        }
        return true
    }
    
    func isGameOver() -> Bool {
        let emptyCount = getEmptyCount()
        if emptyCount == 0 {
            return isMergeOver()
        }
        return false
    }
    
    func resetModel() {
        for i in 0...dimension {
            for j in 0...dimension {
                self[i, j] = 0
            }
        }
    }
    
}
