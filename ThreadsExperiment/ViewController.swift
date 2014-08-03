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
    @IBOutlet var label: UILabel!
    @IBOutlet var uiView: UIView!
    @IBOutlet var slider: UISlider!
    
    let queue = NSOperationQueue();
    var solver : GrayScottSolver = GrayScottSolver();
    var renderer : GrayScottRenderer = GrayScottRenderer();
    let arrayLength = 100;
    var grayScottData = Array<Array<(CGFloat,CGFloat)>>();
    

    override func viewDidLoad()
    {
        for column in 0..<arrayLength
        {
            grayScottData.append(Array(count:arrayLength, repeatedValue:(CGFloat(),CGFloat())))
        }

        for i in 0 ..< arrayLength
        {
            for j in 0 ..< arrayLength
            {
                var color : (CGFloat,CGFloat);
                
                if arc4random() % 10 > 8 || ((i > 35 && i < 65) && (j > 35 && j < 65) && arc4random() % 100 > 3)
                {
                    color = (CGFloat(0.5), CGFloat(0.25));
                }
                else
                {
                    color = (CGFloat(1.0), CGFloat(0.0));
                }
                
                grayScottData[i][j] = color;
            }
        }

        let timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("timerHandler"), userInfo: nil, repeats: true)
        
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
    
    private func solveGrayScott()
    {
        solver = GrayScottSolver();
        solver.setGrayScott(grayScottData);
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

