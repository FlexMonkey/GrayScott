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
    
    let arraySide = 100;
    var grayScottData = Array<Array<(CGFloat,CGFloat,CGFloat)>>()

    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        for column in 0..<arraySide
        {
            grayScottData.append(Array(count:arraySide, repeatedValue:(CGFloat(),CGFloat(),CGFloat())))
        }
     
        UIGraphicsBeginImageContextWithOptions(CGSize(width: arraySide, height: arraySide), true, 1);
        let context = UIGraphicsGetCurrentContext();
        
        for i in 0 ..< arraySide
        {
            for j in 0 ..< arraySide
            {
                var color : (CGFloat,CGFloat,CGFloat);
                
                if arc4random() % 10 > 5
                {
                    color = (CGFloat(0.5), CGFloat(0.5), CGFloat(0.9));
                }
                else
                {
                    color = (CGFloat(0.9), CGFloat(0.9), CGFloat(0.2));
                }
                
                grayScottData[i][j] = color;
                
                CGContextSetRGBFillColor (context, color.0, color.1, color.2, 1);
                CGContextFillRect (context, CGRectMake (CGFloat(i), CGFloat(j), 1, 1));
            }
        }
        

        
        /*
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), true, 1);
        let context = UIGraphicsGetCurrentContext();
  
        CGContextSetRGBFillColor (context, 1, 1, 0, 1)
        CGContextFillRect (context, CGRectMake (0, 0, 200, 200))
        CGContextSetRGBFillColor (context, 1, 0, 0, 1)
        CGContextFillRect (context, CGRectMake (0, 0, 100, 100))
        CGContextSetRGBFillColor (context, 1, 1, 0, 1)
        CGContextFillRect (context, CGRectMake (0, 0, 50, 50))
        CGContextSetRGBFillColor (context, 0, 0, 1, 0.5);
        CGContextFillRect (context, CGRectMake (0, 0, 50, 100))
        */
        
        var image = UIGraphicsGetImageFromCurrentImageContext();
        
        var texture = SKTexture(image: image)

        imageView.image = image;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

