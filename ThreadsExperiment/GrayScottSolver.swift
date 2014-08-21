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
    public var f : Double
    public var k : Double
    public var dU : Double
    public var dV : Double
}


private var solverstatsCount = 0
public func grayScottSolver(grayScottConstData: [GrayScottStruct], parameters:GrayScottParmeters)->[GrayScottStruct] {

    let semaphore = dispatch_semaphore_create(0)
    let queue0 = dispatch_queue_create("com.humanfriendly.grayscottsolver0",  DISPATCH_QUEUE_SERIAL)
    let queue1 = dispatch_queue_create("com.humanfriendly.grayscottsolver1",  DISPATCH_QUEUE_SERIAL)
    
    var outputArray = [GrayScottStruct](count: grayScottConstData.count, repeatedValue: GrayScottStruct(u: 0, v: 0))
    dispatch_async(queue0) {
        grayScottPartialSolver(grayScottConstData, parameters, 0, Constants.LENGTH/2, &outputArray)
        dispatch_semaphore_signal(semaphore)
    }
    dispatch_async(queue1) {
        grayScottPartialSolver(grayScottConstData, parameters, Constants.LENGTH/2, Constants.LENGTH, &outputArray)
        dispatch_semaphore_signal(semaphore)
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    
    return outputArray
}

private func grayScottPartialSolver(grayScottConstData: [GrayScottStruct], parameters: GrayScottParmeters, startLine:Int, endLine:Int, inout outputArray: [GrayScottStruct]) {
    let stats = solverstatsCount % 1024 == 0
    var startTime : CFAbsoluteTime?
    if stats {
        startTime = CFAbsoluteTimeGetCurrent();
    }
    assert(startLine >= 0)
    assert(endLine <= Constants.LENGTH)
    assert(outputArray.count == Constants.LENGTH_SQUARED)
    assert(grayScottConstData.count == Constants.LENGTH_SQUARED)
    
    var index : Int = startLine * Constants.LENGTH
    
    for i in startLine ..< endLine
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
}
