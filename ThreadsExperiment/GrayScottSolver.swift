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

        let grayScottConstData = grayScottData;
        var outputArray = Array<(CGFloat,CGFloat)>(count: arrayLength * arrayLength, repeatedValue: (CGFloat(1.0), CGFloat(0.0)) );
     
        var index : Int = 0;
        
        for i in 0 ..< arrayLength
        {
            for j in 0 ..< arrayLength
            {
                let thisPixel = grayScottConstData[i * arrayLength + j];
                let northPixel = grayScottConstData[i * arrayLength + (j + 1).wrap(arrayLength - 1)];
                let southPixel = grayScottConstData[i * arrayLength + (j - 1).wrap(arrayLength - 1)];
                let eastPixel = grayScottConstData[(i - 1).wrap(arrayLength - 1) * arrayLength + j];
                let westPixel = grayScottConstData[(i + 1).wrap(arrayLength - 1) * arrayLength + j];

                let laplacianU = northPixel.0 + southPixel.0 + westPixel.0 + eastPixel.0 - (4.0 * thisPixel.0);
                let laplacianV = northPixel.1 + southPixel.1 + westPixel.1 + eastPixel.1 - (4.0 * thisPixel.1);
                let reactionRate = thisPixel.0 * thisPixel.1 * thisPixel.1;
                
                let deltaU = dU! * laplacianU - reactionRate + f! * (1.0 - thisPixel.0);
                let deltaV = dV! * laplacianV + reactionRate - k! * thisPixel.1;
                
                let outputPixel = ((thisPixel.0 + deltaU).clip(), (thisPixel.1 + deltaV).clip());

                // setting values by subscripting is about 15% faster than append()!
                //outputArray.append(outputPixel);
                outputArray[index++] = outputPixel;
            }
        }

        grayScottData = outputArray;
        
        println("GrayScottSolver:" + NSString(format: "%.4f", CFAbsoluteTimeGetCurrent() - startTime));
    }
    
    func setParameterValues(#f: CGFloat, k : CGFloat, dU : CGFloat, dV : CGFloat)
    {
        self.f = f;
        self.k = k;
        self.dU = dU;
        self.dV = dV;
    }
    
    func setGrayScott(value : Array<(CGFloat,CGFloat)>)
    {
        grayScottData = value;
    }

    func getGrayScott() -> Array<(CGFloat,CGFloat)>
    {
        return grayScottData;
    }

}