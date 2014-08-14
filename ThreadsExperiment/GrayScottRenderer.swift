//
//  GrayScottRenderer.swift
//  ThreadsExperiment
//
//  Created by Simon Gladman on 03/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import UIKit

public class GrayScottRenderer : NSOperation
{

    private var grayScottData = NSMutableArray(capacity: Constants.LENGTH_SQUARED);
    private var grayScottImage : UIImage?;
    
    init(grayScottData : NSMutableArray)
    {
        super.init();
        
        self.setGrayScott(grayScottData);
    }
    
    override public func main() -> ()
    {
        let startTime : CFAbsoluteTime = CFAbsoluteTimeGetCurrent();

        UIGraphicsBeginImageContextWithOptions(CGSize(width: Constants.LENGTH, height: Constants.LENGTH), true, 1);
        let context = UIGraphicsGetCurrentContext();

        for i in 0 ..< Constants.LENGTH
        {
            for j in 0 ..< Constants.LENGTH
            {
                let grayScottCell : GrayScottStruct = grayScottData[i * Constants.LENGTH + j] as GrayScottStruct;
                
                CGContextSetRGBFillColor (context, CGFloat(grayScottCell.u), CGFloat(grayScottCell.u), CGFloat(grayScottCell.v), 1);
                CGContextFillRect (context, CGRectMake (CGFloat(i), CGFloat(j), 1, 1));
            }
        }
        
        grayScottImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        println(" R RENDER:" + NSString(format: "%.4f", CFAbsoluteTimeGetCurrent() - startTime));
    }
    
    private func setGrayScott(value : NSMutableArray)
    {
        grayScottData = value;
    }
    
    public func getGrayScottImage() -> UIImage?
    {
        return grayScottImage; 
    }
    
}