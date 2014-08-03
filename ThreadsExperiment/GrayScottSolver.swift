//
//  GrayScottSolver.swift
//  ThreadsExperiment
//
//  Created by Simon Gladman on 02/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//
// Thanks to: http://tetontech.wordpress.com/2014/06/03/swift-ios-and-threading/
//
//  Karlm Sims on Gray Scott: http://www.karlsims.com/rd.html
//  My work with reaction diffusion: http://flexmonkey.blogspot.co.uk/search/label/Reaction%E2%80%93diffusion
//

import Foundation
import UIKit
import CoreImage

class GrayScottSolver : NSOperation
{
    private var grayScottData = Array<(CGFloat,CGFloat)>();
    
    private var f : CGFloat?;
    private var k : CGFloat?;
    private var dU : CGFloat?;
    private var dV : CGFloat?;
    
    override func main() -> ()
    {
        let startTime : CFAbsoluteTime = CFAbsoluteTimeGetCurrent();
        
        let arrayLength = 70;

        var outputArray = Array<(CGFloat,CGFloat)>();
        
        for i in 0 ..< arrayLength
        {
            for j in 0 ..< arrayLength
            {
                var thisPixel = grayScottData[i * arrayLength + j];
                let northPixel = grayScottData[i * arrayLength + (j + 1).wrap(69)];
                let southPixel = grayScottData[i * arrayLength + (j - 1).wrap(69)];
                let eastPixel = grayScottData[(i - 1).wrap(69) * arrayLength + j];
                let westPixel = grayScottData[(i + 1).wrap(69) * arrayLength + j];

                let laplacianU = northPixel.0 + southPixel.0 + westPixel.0 + eastPixel.0 - (4.0 * thisPixel.0);
                let laplacianV = northPixel.1 + southPixel.1 + westPixel.1 + eastPixel.1 - (4.0 * thisPixel.1);
                let reactionRate = thisPixel.0 * thisPixel.1 * thisPixel.1;
                
                let deltaU = dU! * laplacianU - reactionRate + f! * (1.0 - thisPixel.0);
                let deltaV = dV! * laplacianV + reactionRate - k! * thisPixel.1;
                
                let outputPixel = ((thisPixel.0 + deltaU).clip(), (thisPixel.1 + deltaV).clip());

                outputArray.append(outputPixel);
            }
        }

        grayScottData = outputArray;
        
        println("GrayScottSolver:" + NSString(format: "%.4f", CFAbsoluteTimeGetCurrent() - startTime));
    }
    
    public func setParameterValues(#f: CGFloat, k : CGFloat, dU : CGFloat, dV : CGFloat)
    {
        self.f = f;
        self.k = k;
        self.dU = dU;
        self.dV = dV;
    }
    
    public func setGrayScott(value : Array<(CGFloat,CGFloat)>)
    {
        grayScottData = value;
    }

    public func getGrayScott() -> Array<(CGFloat,CGFloat)>
    {
        return grayScottData;
    }

}