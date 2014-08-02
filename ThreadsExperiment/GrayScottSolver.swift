//
//  GrayScottSolver.swift
//  ThreadsExperiment
//
//  Created by Simon Gladman on 02/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//
// Thanks to: http://tetontech.wordpress.com/2014/06/03/swift-ios-and-threading/
//

import Foundation
import UIKit
import SpriteKit

class GrayScottSolver : NSOperation
{
    private var grayScott : Int = 0;
    
    override func main() -> ()
    {
        println("hello from solver");
        println(grayScott);
        println("----");
    }
    
    public func setGrayScott(value : Int)
    {
        grayScott = value + 1;
    }
    
    public func getGrayScott() -> Int
    {
        return grayScott;
    }

}