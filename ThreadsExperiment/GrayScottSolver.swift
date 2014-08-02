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
    private var grayScottData = Array<Array<(CGFloat,CGFloat)>>();
    
    override func main() -> ()
    {
        let arrayLength = grayScottData.count;
        
        for i in 1 ..< arrayLength - 1
        {
            for j in 1 ..< arrayLength - 1
            {
                let f : CGFloat = 0.035;
                let k : CGFloat = 0.064;
                let dU : CGFloat = 0.032;
                let dV : CGFloat = 0.041;
                
                let thisPixel = grayScottData[i][j];
                let northPixel = grayScottData[i][j + 1];
                let southPixel = grayScottData[i][j - 1];
                let eastPixel = grayScottData[i - 1][j];
                let westPixel = grayScottData[i + 1][j];

                let laplacianU = northPixel.0 + southPixel.0 + westPixel.0 + eastPixel.0 - (4.0 * thisPixel.0);
                let laplacianV = northPixel.1 + southPixel.1 + westPixel.1 + eastPixel.1 - (4.0 * thisPixel.1);
                
                let deltaU = dU * laplacianU - thisPixel.0 * thisPixel.1 * thisPixel.1 + f * (1.0 - thisPixel.0);
                let deltaV = dV * laplacianV + thisPixel.0 * thisPixel.1 * thisPixel.1 - (f + k) - thisPixel.1;
                
                grayScottData[i][j] = ((thisPixel.0 + deltaU).clip(), (thisPixel.1 + deltaV).clip());
            }
        }
    }
    
    public func setGrayScott(value : Array<Array<(CGFloat,CGFloat)>>)
    {
        grayScottData = value;
    }
    
    public func getGrayScott() -> Array<Array<(CGFloat,CGFloat)>>
    {
        return grayScottData;
    }

}