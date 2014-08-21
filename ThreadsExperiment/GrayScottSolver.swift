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

public struct GrayScottParmeters {
    var f : Double
    var k : Double
    var dU : Double
    var dV : Double
}

private var solverstatsCount = 0
public func grayScottSolver(grayScottConstData: [GrayScottStruct], parameters:GrayScottParmeters)->[GrayScottStruct] {
    let stats = solverstatsCount % 1024 == 0
    var startTime : CFAbsoluteTime?
    if stats {
        startTime = CFAbsoluteTimeGetCurrent();
    }
    
    var index : Int = 0;
    var outputArray = grayScottConstData // Copy to get array big enough
    for i in 0 ..< Constants.LENGTH
    {
        for j in 0 ..< Constants.LENGTH
        {
            let thisPixel = grayScottConstData[i * Constants.LENGTH + j]
            let northPixel = grayScottConstData[i * Constants.LENGTH + (j + 1).wrap(Constants.LENGTH_MINUS_ONE)]
            let southPixel = grayScottConstData[i * Constants.LENGTH + (j - 1).wrap(Constants.LENGTH_MINUS_ONE)]
            let eastPixel = grayScottConstData[(i - 1).wrap(Constants.LENGTH_MINUS_ONE) * Constants.LENGTH + j]
            let westPixel = grayScottConstData[(i + 1).wrap(Constants.LENGTH_MINUS_ONE) * Constants.LENGTH + j]
            
            let laplacianU = northPixel.u + southPixel.u + westPixel.u + eastPixel.u - (4.0 * thisPixel.u);
            let laplacianV = northPixel.v + southPixel.v + westPixel.v + eastPixel.v - (4.0 * thisPixel.v);
            let reactionRate = thisPixel.u * thisPixel.v * thisPixel.v;
            
            let deltaU : Double = parameters.dU * laplacianU - reactionRate + parameters.f * (1.0 - thisPixel.u);
            let deltaV : Double = parameters.dV * laplacianV + reactionRate - parameters.k * thisPixel.v;
            
            let outputPixel = GrayScottStruct(u: (thisPixel.u + deltaU).clip(), v: (thisPixel.v + deltaV).clip())
            
            //outputArray.append(outputPixel)
            
            outputArray[index++] = outputPixel;
        }
    }

    if stats {
        println("S  SOLVER:" + NSString(format: "%.4f", CFAbsoluteTimeGetCurrent() - startTime!));
    }
    ++solverstatsCount
    return outputArray
}
