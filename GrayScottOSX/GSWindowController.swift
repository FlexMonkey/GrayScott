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
        }() {
        didSet {
            dispatchRender()
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        dispatchSolverOperation()
    }
    
    private var lastFrameCountTime = NSDate()
    private var frameCount = 0
    private var solveCount = 0
    private final func dispatchSolverOperation()
    {
        let dataCopy = grayScottData
        let params = parameters
        weak var weakSelf = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let newGSData = grayScottSolver(dataCopy, params)
            dispatch_async(dispatch_get_main_queue()) {
                if let s = weakSelf {
                    ++s.solveCount
                    s.grayScottData = newGSData
                    s.dispatchSolverOperation()
                }
            }
        }
    }
    private var renderedCount = 0
    private var skippedCount = 0
    private var isRendering = false
    private final func dispatchRender() {
        if isRendering {
            ++skippedCount
            //if skippedCount % 256 == 0 {
            println("Rendering bottleneck, render skipped. Skipped:\(skippedCount) Rendered: \(renderedCount) Skipped: \(100 * skippedCount / (skippedCount + renderedCount))")
            //}
            return
        }
        ++renderedCount
        isRendering = true
        let gsData = self.grayScottData
        weak var weakSelf = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let newImage = renderGrayScott(gsData)
            dispatch_async(dispatch_get_main_queue()) {
                if let s = weakSelf {
                    s.isRendering = false
                    s.imageView.image = newImage as? NSImage
                    if s.lastFrameCountTime.timeIntervalSinceNow < -1.0 {
                        println("Frame count = \(s.frameCount) Solve count: \(s.solveCount)")
                        s.frameCount = 0
                        s.solveCount = 0
                        s.lastFrameCountTime = NSDate()
                    }
                    ++s.frameCount
                    
                }
            }
        }
    }


}
