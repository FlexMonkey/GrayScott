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
    
    let queue = NSOperationQueue();
    var solver : GrayScottSolver = GrayScottSolver();
    let arrayLength = 100;
    var grayScottData = Array<Array<(CGFloat,CGFloat)>>();

    override func viewDidLoad()
    {
        super.viewDidLoad();
     
        for column in 0..<arrayLength
        {
            grayScottData.append(Array(count:arrayLength, repeatedValue:(CGFloat(),CGFloat())))
        }
     
        UIGraphicsBeginImageContextWithOptions(CGSize(width: arrayLength, height: arrayLength), true, 1);
        let context = UIGraphicsGetCurrentContext();
        
        for i in 0 ..< arrayLength
        {
            for j in 0 ..< arrayLength
            {
                var color : (CGFloat,CGFloat);
                
                if arc4random() % 10 > 5
                {
                    color = (CGFloat(0.2), CGFloat(0.9));
                }
                else
                {
                    color = (CGFloat(0.9), CGFloat(0.2));
                }
                
                grayScottData[i][j] = color;
                
                CGContextSetRGBFillColor (context, color.0, color.0, color.1, 1);
                CGContextFillRect (context, CGRectMake (CGFloat(i), CGFloat(j), 1, 1));
            }
        }
        
        var image = UIGraphicsGetImageFromCurrentImageContext();
        
        var texture = SKTexture(image: image)

        imageView.image = image;

        solveGrayScott();
    }

    private func solveGrayScott()
    {
        solver = GrayScottSolver();
        solver.setGrayScott(grayScottData)
        queue.addOperation(solver);
        solver.threadPriority = 0;
        solver.completionBlock = {self.didSolve(self.solver.getGrayScott())};
    }
    
    private func didSolve(result : Array<Array<(CGFloat,CGFloat)>>)
    {
        solveGrayScott();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

