//
//  IntExtension.swift
//  ThreadsExperiment
//
//  Created by Simon Gladman on 03/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation

extension Int
{
    func wrap(max : Int) -> Int
    {
        if self < 0
        {
            return max;
        }
        else if self > max
        {
            return 0
        }
        else
        {
            return self; 
        }
    }
}
