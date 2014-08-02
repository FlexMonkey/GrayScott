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
    var grayScottData = Array<Array<Float>>()

    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        for column in 0..<arraySide
        {
            grayScottData.append(Array(count:arraySide, repeatedValue:Float()))
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: arraySide, height: arraySide), true, 1);
        
        let context = UIGraphicsGetCurrentContext();
  
        CGContextSetRGBFillColor (context, 1, 1, 0, 1)
        CGContextFillRect (context, CGRectMake (0, 0, 200, 200))
        CGContextSetRGBFillColor (context, 1, 0, 0, 1)
        CGContextFillRect (context, CGRectMake (0, 0, 100, 100))
        CGContextSetRGBFillColor (context, 1, 1, 0, 1)
        CGContextFillRect (context, CGRectMake (0, 0, 50, 50))
        CGContextSetRGBFillColor (context, 0, 0, 1, 0.5);
        CGContextFillRect (context, CGRectMake (0, 0, 50, 100))

        
        var image = UIGraphicsGetImageFromCurrentImageContext();
        
        var texture = SKTexture(image: image)

        imageView.image = image;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

