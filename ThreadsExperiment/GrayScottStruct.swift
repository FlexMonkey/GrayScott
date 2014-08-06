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
    var u : Float = 0.0;
    var v : Float = 0.0;
    
    init(u : Float, v: Float)
    {
        self.u = u;
        self.v = v;
    }
}
