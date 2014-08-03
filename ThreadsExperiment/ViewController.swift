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
    
    let queue = NSOperationQueue();
    var solver : GrayScottSolver = GrayScottSolver();
    var renderer : GrayScottRenderer = GrayScottRenderer();
    let arrayLength = 70;

    var grayScottData = Array<(CGFloat,CGFloat)>(count: 70 * 70, repeatedValue: (CGFloat(1.0), CGFloat(0.0))  );
 
    override func viewDidLoad()
    {
        for i in 0 ..< arrayLength
        {
            for j in 0 ..< arrayLength
            {
                var color : (CGFloat,CGFloat);
                
                if ((i > 25 && i < 45) && (j > 25 && j < 45) && arc4random() % 100 > 5)
                {
                    color = (CGFloat(0.5), CGFloat(0.25));
                }
                else
                {
                    color = (CGFloat(1.0), CGFloat(0.0));
                }
                
                grayScottData[i * arrayLength + j] = color;
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

