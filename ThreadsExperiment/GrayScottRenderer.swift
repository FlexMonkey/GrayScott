//
//  GrayScottRenderer.swift
//  ThreadsExperiment
//
//  Created by Simon Gladman on 03/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import UIKit

struct PixelData {
    var a:UInt8 = 255
    var r:UInt8
    var g:UInt8
    var b:UInt8
}

private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedFirst.toRaw())

private func imageFromARGB32Bitmap(pixels:[PixelData], width:UInt, height:UInt)->UIImage {
    let bitsPerComponent:UInt = 8
    let bitsPerPixel:UInt = 32
    
    var data = pixels // Copy to mutable []
    let providerRef = CGDataProviderCreateWithCFData(NSData(bytes: &data, length: data.count * sizeof(PixelData)))

    let cgim = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, width * UInt(sizeof(PixelData)), rgbColorSpace,	bitmapInfo, providerRef, nil, true, kCGRenderingIntentDefault)
    return UIImage(CGImage: cgim)
}

func renderGrayScott(grayScottData:[GrayScottStruct])->UIImage
{
    let startTime : CFAbsoluteTime = CFAbsoluteTimeGetCurrent();
    var pixelArray = [PixelData](count: Constants.LENGTH_SQUARED, repeatedValue: PixelData(a: 255, r:0, g: 0, b: 0))
    
    for i in 0 ..< Constants.LENGTH
    {
        for j in 0 ..< Constants.LENGTH
        {
            let grayScottCell : GrayScottStruct = grayScottData[i * Constants.LENGTH + j]
            let index = i * Constants.LENGTH + j
            let u_I = UInt8(grayScottCell.u * 255)
            pixelArray[index].r = u_I
            pixelArray[index].g = u_I
            pixelArray[index].b = UInt8(grayScottCell.v * 255)
        }
    }
    let outputImage = imageFromARGB32Bitmap(pixelArray, UInt(Constants.LENGTH), UInt(Constants.LENGTH))

    println(" R RENDER:" + NSString(format: "%.4f", CFAbsoluteTimeGetCurrent() - startTime));

    return outputImage
}
