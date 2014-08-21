//
//  ViewController.swift
//  ThreadsExperiment
//
//  Created by Simon Gladman on 02/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var uiView: UIView!
    @IBOutlet var parameterSlider: UISlider!
    @IBOutlet var parameterButtonBar: UISegmentedControl!
    @IBOutlet var parameterValueLabel: UILabel!


    
    var f : Double = 0.023;
    var k : Double = 0.0795;
    var dU : Double = 0.16;
    var dV : Double = 0.08;

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

    override func viewDidLoad()
    {
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.025, target: self, selector: Selector("timerHandler"), userInfo: nil, repeats: true);
        
        updateLabel();
        dispatchSolverOperation()
    }

    func timerHandler()
    {
        //self.dispatchSolverOperation()
    }
    
    @IBAction func sliderValueChangeHandler(sender: AnyObject)
    {
        switch parameterButtonBar.selectedSegmentIndex
        {
            case 0:
                f = Double(parameterSlider.value);
            case 1:
                k = Double(parameterSlider.value);
            case 2:
                dU = Double(parameterSlider.value);
            case 3:
                dV = Double(parameterSlider.value);
            default:
                f = Double(parameterSlider.value);
        }
        
        updateLabel();
    }
    

    @IBAction func parametrButtonBarChangeHandler(sender: AnyObject)
    {
        updateLabel();
    }
    
    private func updateLabel()
    {
        switch parameterButtonBar.selectedSegmentIndex
        {
            case 0:
                parameterValueLabel.text = "f = " + f.format();
                parameterSlider.value = Float(f);
            case 1:
                parameterValueLabel.text = "k = " + k.format();
                parameterSlider.value = Float(k);
            case 2:
                parameterValueLabel.text = "Du = " + dU.format();
                parameterSlider.value = Float(dU);
            case 3:
                parameterValueLabel.text = "Dv = " + dV.format();
                parameterSlider.value = Float(dV);
            default:
                parameterValueLabel.text = "";
        }
    }
    
    private var lastFrameCountTime = NSDate()
    private var frameCount = 0
    private var solveCount = 0
    private final func dispatchSolverOperation()
    {
        let dataCopy = grayScottData
        let params = GrayScottParmeters(f: f, k: k, dU: dU, dV: dV)
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
            if skippedCount % 256 == 0 {
                println("Rendering bottleneck, render skipped. Skipped:\(skippedCount) Rendered: \(renderedCount) Skipped: \(100 * skippedCount / (skippedCount + renderedCount))")
            }
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
                    s.imageView.image = newImage
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

