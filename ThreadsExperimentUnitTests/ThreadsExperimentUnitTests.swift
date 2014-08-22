//
//  ThreadsExperimentUnitTests.swift
//  ThreadsExperimentUnitTests
//
//  Created by Joseph on 21/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit
import XCTest

let gsParams = GrayScottParameters(f: 0.023, k: 0.0795, dU: 0.16, dV: 0.08)

public struct Constants
{
    static let LENGTH : Int = 512
    static let LENGTH_MINUS_ONE : Int = LENGTH - 1
    static let LENGTH_SQUARED : Int = LENGTH * LENGTH
}

var grayScottData:[GrayScottStruct] = {
    var data = [GrayScottStruct]()
    for i in 0..<Constants.LENGTH_SQUARED
    {
        data.append(GrayScottStruct(u:1.0, v:0.0))
    }
    let t0 = Constants.LENGTH * 5 / 14
    let t1 = Constants.LENGTH - t0
    for i in t0 ..< t1
    {
        for j in t0 ..< t1
        {
            if arc4random() % 100 > 5
            {
                data[i * Constants.LENGTH + j] = GrayScottStruct(u: 0.5, v: 0.25);
            }
        }
    }
    return data
    }()

class ThreadsExperimentUnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceGrayScottSolver() {
        // This is an example of a performance test case.
        var gsData = grayScottData
        self.measureBlock() {
            // Put the code you want to measure the time of here.
            for i in 0..<1024 {
                gsData = grayScottSolver(gsData, gsParams)
            }
        }
    }
    
}
