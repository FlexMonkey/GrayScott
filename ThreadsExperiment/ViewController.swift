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
    @IBOutlet var labelTwo: UILabel!
    
    let queue = NSOperationQueue();
    var solver : GrayScottSolver = GrayScottSolver();
    let arrayLength = 100;
    var grayScottData = Array<Array<(CGFloat,CGFloat)>>();
    
    @IBAction func actionChanged(sender: AnyObject)
    {
        labelTwo.text = NSString(format: "%.5f", slider.value );
    }
    
    override func viewDidLoad()
    {
        queue.maxConcurrentOperationCount = 1;

        for column in 0..<arrayLength
        {
            grayScottData.append(Array(count:arrayLength, repeatedValue:(CGFloat(),CGFloat())))
        }

        for i in 0 ..< arrayLength
        {
            for j in 0 ..< arrayLength
            {
                var color : (CGFloat,CGFloat);
                
                if arc4random() % 10 > 8 || ((i > 35 && i < 65) && (j > 35 && j < 65) && arc4random() % 10 > 2)
                {
                    color = (CGFloat(0.2), CGFloat(0.9));
                }
                else
                {
                    color = (CGFloat(0.9), CGFloat(0.2));
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
            renderGrayScott();
        }
    }
    
    private func solveGrayScott()
    {
        solver = GrayScottSolver();
        solver.setGrayScott(grayScottData);
        solver.threadPriority = 0;
        //solver.completionBlock = {self.didSolve(self.solver.getGrayScott())};
  
        queue.addOperation(solver);
    }

    /*
    private func didSolve(result : Array<Array<(CGFloat,CGFloat)>>)
    {
        grayScottData = result;
        
        renderGrayScott();
    }
    */

    private func renderGrayScott()
    {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: arrayLength, height: arrayLength), true, 1);
        let context = UIGraphicsGetCurrentContext();

        for i in 0 ..< arrayLength
        {
            for j in 0 ..< arrayLength
            {
                let grayScottCell = grayScottData[i][j];
                
                CGContextSetRGBFillColor (context, grayScottCell.0, grayScottCell.0, grayScottCell.1, 1);
                CGContextFillRect (context, CGRectMake (CGFloat(i), CGFloat(j), 1, 1));
            }
        }
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();
    }

}

