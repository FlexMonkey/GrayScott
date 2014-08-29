//
//  GSWindowController.swift
//  ThreadsExperiment
//
//  Created by Joseph on 22/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Cocoa

class GSWindowController: NSWindowController {

    @IBOutlet var imageView: NSImageView!
    
    var parameters = GrayScottParameters(f: 0.023, k: 0.0795, dU: 0.16, dV: 0.08)
    var grayScottData:[GrayScottStruct] = {
        
        var data = [GrayScottStruct]()
        for i in 0..<Constants.LENGTH_SQUARED
        {
            data.append(GrayScottStruct(u:1.0, v:0.0))
        }
        let t0 = Constants.LENGTH * 5 / 14
        let t1 = Constants.LENGTH - t0
        for i in t0 ..< t1
        {
            for j in t0 ..< t1
            {
                if arc4random() % 100 > 5
                {
                    data[i * Constants.LENGTH + j] = GrayScottStruct(u: 0.5, v: 0.25);
                }
            }
        }
        return data
        }()
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        dispatchSolverOperation()
    }
    
    
    private final func dispatchSolverOperation()
    {
        var lastFrameCountTime = CFAbsoluteTimeGetCurrent()
        var frameCount = 0
        var solveCount:Int32 = 0
        var waitingFrames:Int32 = 0
        var data = grayScottData
        let params = parameters
        weak var weakSelf = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            while (true) {
                var pixelData:[PixelData]
                (data, pixelData) = grayScottSolver(data, params)
                let dataCopy = data
                if let s = weakSelf {
                OSAtomicIncrement32(&solveCount)
                OSAtomicIncrement32(&waitingFrames)
                if waitingFrames < 3 {
                    dispatch_async(dispatch_get_main_queue()) {
                        
                            s.grayScottData = data
                            s.imageView.image = imageFromARGB32Bitmap(pixelData, UInt(Constants.LENGTH), UInt(Constants.LENGTH))
                            if CFAbsoluteTimeGetCurrent() - lastFrameCountTime > 1.0 {
                                println("Frame count = \(frameCount) Solve count: \(solveCount)")
                                frameCount = 0
                                solveCount = 0
                                lastFrameCountTime = CFAbsoluteTimeGetCurrent()
                            }
                            ++frameCount
                            OSAtomicDecrement32(&waitingFrames)
                        }
                    } else { OSAtomicDecrement32(&waitingFrames) }
                }
            }
        }
    }
}
