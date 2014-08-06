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
    private var grayScottData = NSMutableArray(capacity: 70 * 70);
    
    private var f : Float?;
    private var k : Float?;
    private var dU : Float?;
    private var dV : Float?;
    
    override func main() -> ()
    {
        let startTime : CFAbsoluteTime = CFAbsoluteTimeGetCurrent();
        
        let arrayLength = 70;

        let grayScottConstData = grayScottData;
        var outputArray = NSMutableArray(capacity: 70 * 70);
     
        var index : Int = 0;
        
        for i in 0 ..< arrayLength
        {
            for j in 0 ..< arrayLength
            {
                let thisPixel : GrayScottStruct! = grayScottConstData[i * arrayLength + j] as GrayScottStruct;
                let northPixel : GrayScottStruct! = grayScottConstData[i * arrayLength + (j + 1).wrap(arrayLength - 1)] as GrayScottStruct;
                let southPixel : GrayScottStruct! = grayScottConstData[i * arrayLength + (j - 1).wrap(arrayLength - 1)] as GrayScottStruct;
                let eastPixel : GrayScottStruct! = grayScottConstData[(i - 1).wrap(arrayLength - 1) * arrayLength + j] as GrayScottStruct;
                let westPixel : GrayScottStruct! = grayScottConstData[(i + 1).wrap(arrayLength - 1) * arrayLength + j] as GrayScottStruct;

                let laplacianU = northPixel.u + southPixel.u + westPixel.u + eastPixel.u - (4.0 * thisPixel.u);
                let laplacianV = northPixel.v + southPixel.v + westPixel.v + eastPixel.v - (4.0 * thisPixel.v);
                let reactionRate = thisPixel.u * thisPixel.v * thisPixel.v;
                
                let deltaU : Float = dU! * laplacianU - reactionRate + f! * (1.0 - thisPixel.u);
                let deltaV : Float = dV! * laplacianV + reactionRate - k! * thisPixel.v;
                
                let outputPixel = GrayScottStruct(u: Float(thisPixel.u + deltaU).clip(), v: Float(thisPixel.v + deltaV).clip());

                // setting values by subscripting is about 15% faster than append()!
                //outputArray.append(outputPixel);
                outputArray[index++] = outputPixel;
            }
        }

        grayScottData = outputArray;
        
        println("GrayScottSolver:" + NSString(format: "%.4f", CFAbsoluteTimeGetCurrent() - startTime));
    }
    
    func setParameterValues(#f: Float, k : Float, dU : Float, dV : Float)
    {
        self.f = f;
        self.k = k;
        self.dU = dU;
        self.dV = dV;
    }
    
    func setGrayScott(value : NSMutableArray)
    {
        grayScottData = value;
    }

    func getGrayScott() -> NSMutableArray
    {
        return grayScottData;
    }

}