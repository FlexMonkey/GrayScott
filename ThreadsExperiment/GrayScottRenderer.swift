//
//  GrayScottRenderer.swift
//  ThreadsExperiment
//
//  Created by Simon Gladman on 03/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import UIKit

class GrayScottRenderer : NSOperation
{

    private var grayScottData = Array<Array<(CGFloat,CGFloat)>>();
    private var grayScottImage = UIImage();
    
    override func main() -> ()
    {
        let arrayLength = grayScottData.count;
        
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
        
        grayScottImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    public func setGrayScott(value : Array<Array<(CGFloat,CGFloat)>>)
    {
        grayScottData = value;
    }
    
    public func getGrayScottImage() -> UIImage
    {
        return grayScottImage;
    }
    
}