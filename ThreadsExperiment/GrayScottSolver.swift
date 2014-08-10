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

public class GrayScottSolver : NSOperation
{
    private var grayScottData = NSMutableArray(capacity: Constants.LENGTH_SQUARED);
    
    private var f : Double?;
    private var k : Double?;
    private var dU : Double?;
    private var dV : Double?;
    
    init(grayScottData : NSMutableArray)
    {
        super.init();
        
        self.setGrayScott(grayScottData);
    }
    
    override public func main() -> ()
    {
        let startTime : CFAbsoluteTime = CFAbsoluteTimeGetCurrent();
  
        let grayScottConstData = grayScottData;
        var outputArray = NSMutableArray(capacity: Constants.LENGTH_SQUARED);
     
        var index : Int = 0;
        
        for i in 0 ..< Constants.LENGTH
        {
            for j in 0 ..< Constants.LENGTH
            {
                let thisPixel : GrayScottStruct! = grayScottConstData[i * Constants.LENGTH + j] as GrayScottStruct;
                let northPixel : GrayScottStruct! = grayScottConstData[i * Constants.LENGTH + (j + 1).wrap(Constants.LENGTH_MINUS_ONE)] as GrayScottStruct;
                let southPixel : GrayScottStruct! = grayScottConstData[i * Constants.LENGTH + (j - 1).wrap(Constants.LENGTH_MINUS_ONE)] as GrayScottStruct;
                let eastPixel : GrayScottStruct! = grayScottConstData[(i - 1).wrap(Constants.LENGTH_MINUS_ONE) * Constants.LENGTH + j] as GrayScottStruct;
                let westPixel : GrayScottStruct! = grayScottConstData[(i + 1).wrap(Constants.LENGTH_MINUS_ONE) * Constants.LENGTH + j] as GrayScottStruct;

                let laplacianU = northPixel.u + southPixel.u + westPixel.u + eastPixel.u - (4.0 * thisPixel.u);
                let laplacianV = northPixel.v + southPixel.v + westPixel.v + eastPixel.v - (4.0 * thisPixel.v);
                let reactionRate = thisPixel.u * thisPixel.v * thisPixel.v;
                
                let deltaU : Double = dU! * laplacianU - reactionRate + f! * (1.0 - thisPixel.u);
                let deltaV : Double = dV! * laplacianV + reactionRate - k! * thisPixel.v;
                
                let outputPixel = GrayScottStruct(u: (thisPixel.u + deltaU).clip(), v: (thisPixel.v + deltaV).clip());

                // setting values by subscripting is about 15% faster than append()!
                //outputArray.append(outputPixel);
                outputArray[index++] = outputPixel;
            }
        }

        grayScottData = outputArray;
        
        println("S  SOLVER:" + NSString(format: "%.4f", CFAbsoluteTimeGetCurrent() - startTime));
    }
    
    // Double is faster that Double...
    public func setParameterValues(#f: Double, k : Double, dU : Double, dV : Double)
    {
        self.f = f;
        self.k = k;
        self.dU = dU;
        self.dV = dV;
    }
    
    private func setGrayScott(value : NSMutableArray)
    {
        grayScottData = value;
    }

    public func getGrayScott() -> NSMutableArray
    {
        return grayScottData;
    }

}