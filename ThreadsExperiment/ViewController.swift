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

    override func viewDidLoad()
    {
        
        updateLabel();
        dispatchSolverOperation()
    }
    
    @IBAction func sliderValueChangeHandler(sender: AnyObject)
    {
        switch parameterButtonBar.selectedSegmentIndex
        {
            case 0:
                parameters.f = Double(parameterSlider.value);
            case 1:
                parameters.k = Double(parameterSlider.value);
            case 2:
                parameters.dU = Double(parameterSlider.value);
            case 3:
                parameters.dV = Double(parameterSlider.value);
            default:
                parameters.f = Double(parameterSlider.value);
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
                parameterValueLabel.text = "f = " + parameters.f.format()
                parameterSlider.value = Float(parameters.f)
            case 1:
                parameterValueLabel.text = "k = " + parameters.k.format()
                parameterSlider.value = Float(parameters.k)
            case 2:
                parameterValueLabel.text = "Du = " + parameters.dU.format()
                parameterSlider.value = Float(parameters.dU)
            case 3:
                parameterValueLabel.text = "Dv = " + parameters.dV.format()
                parameterSlider.value = Float(parameters.dV)
            default:
                parameterValueLabel.text = "";
        }
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

