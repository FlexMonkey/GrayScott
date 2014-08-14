//
//  ViewController.swift
//  ThreadsExperiment
//
//  Created by Simon Gladman on 02/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController
{
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var uiView: UIView!
    @IBOutlet var parameterSlider: UISlider!
    @IBOutlet var parameterButtonBar: UISegmentedControl!
    @IBOutlet var parameterValueLabel: UILabel!

    let queue = NSOperationQueue();
    var solver : GrayScottSolver?;
    var renderer : GrayScottRenderer?;
    
    var f : Double = 0.023;
    var k : Double = 0.0795;
    var dU : Double = 0.16;
    var dV : Double = 0.08;

    var grayScottData : NSMutableArray = NSMutableArray(capacity: Constants.LENGTH_SQUARED);
 
    override func viewDidLoad()
    {
        for i in 0..<Constants.LENGTH_SQUARED
        {
            grayScottData[i] = GrayScottStruct(u:1.0, v:0.0);
        }
        
        for i in 25 ..< 45
        {
            for j in 25 ..< 45
            {
                if arc4random() % 100 > 5
                {
                    grayScottData[i * Constants.LENGTH + j] = GrayScottStruct(u: 0.5, v: 0.25);
                }
            }
        }
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.025, target: self, selector: Selector("timerHandler"), userInfo: nil, repeats: true);
        
        updateLabel();
        dispatchSolverOperation();
    }

    func timerHandler()
    {
        if solver!.finished
        {
            grayScottData = solver!.getGrayScott();
            
            if let tmp = renderer
            {
                if !tmp.executing
                {
                    dispatchRenderOperation();
                }
            }
            else
            {
                dispatchRenderOperation();
            }
            
            dispatchSolverOperation();
        }
        
        if let tmp = renderer
        {
            if(tmp.finished)
            {
                renderGrayScott();
            }
        }
    }
    
    func dispatchRenderOperation()
    {
        renderer = GrayScottRenderer(grayScottData: grayScottData);
        renderer!.threadPriority = 0;
        
        queue.addOperation(renderer);
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
    
    private func dispatchSolverOperation()
    {
        solver = GrayScottSolver(grayScottData: grayScottData);
    
        solver!.setParameterValues(f: f, k: k, dU: dU, dV: dV)
        solver!.threadPriority = 0;
        
        // this doesn't work because the completion block isn't executed in the main thread
        //solver.completionBlock = {self.didSolve(self.solver.getGrayScott())};
  
        queue.addOperation(solver);
    }

    private func renderGrayScott()
    {
        imageView.image = renderer!.getGrayScottImage();
    }

}

