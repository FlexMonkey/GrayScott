//
//  GrayScottStruct.swift
//  ThreadsExperiment
//
//  Created by Simon Gladman on 06/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation

class GrayScottStruct : GrayScottProtocol
{
    var u : Double = 0.0;
    var v : Double = 0.0;
    
    init(u : Double, v: Double)
    {
        self.u = u;
        self.v = v;
    }
}
