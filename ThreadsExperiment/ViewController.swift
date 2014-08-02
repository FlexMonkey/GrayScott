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
    var grayScottData = Array<Array<(CGFloat,CGFloat)>>()

    override func viewDidLoad()
    {
        super.viewDidLoad();
     
        for column in 0..<arraySide
        {
            grayScottData.append(Array(count:arraySide, repeatedValue:(CGFloat(),CGFloat())))
        }
     
        UIGraphicsBeginImageContextWithOptions(CGSize(width: arraySide, height: arraySide), true, 1);
        let context = UIGraphicsGetCurrentContext();
        
        for i in 0 ..< arraySide
        {
            for j in 0 ..< arraySide
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

     
    }

    
 
    /*
    override func update(currentTime: CFTimeInterval)
    {
        for i in 1 ..< arraySide - 1
        {
            for j in 1 ..< arraySide - 1
            {
                let thisPixel = grayScottData[i][j];
                let northPixel = grayScottData[i][j + 1];
                let southPixel = grayScottData[i][j - 1];
            }
        }
    }
*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

