//
//  CGFloatExtension.swift
//  ThreadsExperiment
//
//  Created by Simon Gladman on 02/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation

extension Double
{
    func clip() -> Double
    {
        if self < 0
        {
            return 0.0;
        }
        else if self > 1.0
        {
            return 1.0;
        }
        else
        {
            return self;
        }
    }
    
    func format() -> String
    {
        return NSString(format: "%.4f", Double(self));
    }
}