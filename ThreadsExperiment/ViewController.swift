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
    var solver : GrayScottSolver = GrayScottSolver();
    var renderer : GrayScottRenderer = GrayScottRenderer();
    let arrayLength = 70;
    
    var f : Float = 0.023;
    var k : Float = 0.0795;
    var dU : Float = 0.16;
    var dV : Float = 0.08;

    var grayScottData : NSMutableArray = NSMutableArray(capacity: 70 * 70);
 
    override func viewDidLoad()
    {
        for i in 0..<70 * 70
        {
            grayScottData[i] = GrayScottStruct(u:1.0, v:0.0);
        }
     
        // d'oh - prepop
        
        for i in 25 ..< 45
        {
            for j in 25 ..< 45
            {
                if arc4random() % 100 > 5
                {
                    grayScottData[i * arrayLength + j] = GrayScottStruct(u: 0.5, v: 0.25);
                }
            }
        }
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("timerHandler"), userInfo: nil, repeats: true)
        
        updateLabel();
        solveGrayScott();
    }

    func timerHandler()
    {
        if solver.finished
        {
            grayScottData = solver.getGrayScott();
            solveGrayScott();
        }
        
        if(renderer.finished)
        {
            renderGrayScott();
        }
    }
    
    @IBAction func sliderValueChangeHandler(sender: AnyObject)
    {
        switch parameterButtonBar.selectedSegmentIndex
        {
            case 0:
                f = Float(parameterSlider.value);
            case 1:
                k = Float(parameterSlider.value);
            case 2:
                dU = Float(parameterSlider.value);
            case 3:
                dV = Float(parameterSlider.value);
            default:
                f = Float(parameterSlider.value);
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
    
    private func solveGrayScott()
    {
        solver = GrayScottSolver();
    
        solver.setGrayScott(grayScottData);
        solver.setParameterValues(f: f, k: k, dU: dU, dV: dV)
        solver.threadPriority = 0;
        
        // this doesn't work because the completion block isn't executed in the main thread
        //solver.completionBlock = {self.didSolve(self.solver.getGrayScott())};
  
        queue.addOperation(solver);
        
        if !renderer.executing
        {
            renderer = GrayScottRenderer();
            renderer.setGrayScott(grayScottData);
            renderer.threadPriority = 0;

            queue.addOperation(renderer);
        }
    }

    private func renderGrayScott()
    {
        imageView.image = renderer.getGrayScottImage();
     
    }

}

