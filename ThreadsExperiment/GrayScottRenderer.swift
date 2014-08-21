//
//  GrayScottRenderer.swift
//  ThreadsExperiment
//
//  Created by Simon Gladman on 03/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import UIKit
/*
class RenderedGSImage : CIImage {
    let grayScottData:[GrayScottStruct]
    init(grayScottData:[GrayScottStruct]) {
        self.grayScottData = grayScottData
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func extent() -> CGRect {
        return CGRect(x: 0, y: 0, width: Constants.LENGTH, height: Constants.LENGTH)
    }
    
}
*/
/*
CGImageRef CreateImageFromARGB32Bitmap(
unsigned int height,
unsigned int width,
void *baseAddr,
unsigned int rowBytes)
{
const size_t bitsPerComponent = 8;
const size_t bitsPerPixel = 32;

CGImageRef retVal = NULL;

// Create a data provider. We pass in NULL for the info
// and the release procedure pointer.
CGDataProviderRef dataProvider =
CGDataProviderCreateWithData(
NULL, baseAddr, rowBytes * height, NULL);

// Get our hands on the generic RGB color space.
CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateWithName(
kCGColorSpaceGenericRGB);
// Create an image
retVal = CGImageCreate(
width, height, bitsPerComponent, bitsPerPixel,
rowBytes, rgbColorSpace, kCGImageAlphaPremultipliedFirst,
dataProvider, NULL, true, kCGRenderingIntentDefault);

// The data provider and color space now belong to the
// image so we can release them.
CGDataProviderRelease(dataProvider);
CGColorSpaceRelease(rgbColorSpace);

return retVal;
}
*/
struct PixelData {
    var r:UInt8
    var g:UInt8
    var b:UInt8
    var a:UInt8 = 255
}
func imageFromARGB32Bitmap(pixels:[PixelData], width:UInt, height:UInt)->UIImage {
    let bitsPerComponent:UInt = 8
    let bitsPerPixel:UInt = 32
    var data = pixels // Copy to mutable []
    let providerRef = CGDataProviderCreateWithCFData(NSData(bytes: &data, length: data.count * sizeof(PixelData))) //NSData(bytes: &pixelArray, length: pixelArray.count * sizeof(PixelData))
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo:CGBitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedFirst.toRaw())
    let cgim = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, width * UInt(sizeof(PixelData)), rgbColorSpace,	bitmapInfo, providerRef, nil, true, kCGRenderingIntentDefault)
    return UIImage(CGImage: cgim)
}

func renderGrayScott(grayScottData:[GrayScottStruct])->UIImage
{
    let startTime : CFAbsoluteTime = CFAbsoluteTimeGetCurrent();
    var pixelArray = [PixelData](count: Constants.LENGTH_SQUARED, repeatedValue: PixelData(r: 0, g: 0, b: 0, a: 255))
    
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
/*
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
    
    let outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
*/
    println(" R RENDER:" + NSString(format: "%.4f", CFAbsoluteTimeGetCurrent() - startTime));

    return outputImage
}
