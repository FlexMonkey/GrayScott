//
//  GrayScottRenderNSImage.swift
//  ThreadsExperiment
//
//  Created by Joseph on 22/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import AppKit


private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(CGImageAlphaInfo.NoneSkipFirst.toRaw())

func imageFromARGB32Bitmap(pixels:[PixelData], width:UInt, height:UInt)->NSImage {
    let bitsPerComponent:UInt = 8
    let bitsPerPixel:UInt = 32
    
    assert(pixels.count == Int(width * height))

    var data = pixels // Copy to mutable []
    let providerRef = CGDataProviderCreateWithCFData(
        NSData(bytes: &data, length: data.count * sizeof(PixelData))
    )
    
    let cgim = CGImageCreate(
        width,
        height,
        bitsPerComponent,
        bitsPerPixel,
        width * UInt(sizeof(PixelData)),
        rgbColorSpace,
        bitmapInfo,
        providerRef,
        nil,
        true,
        kCGRenderingIntentDefault
    )
    return NSImage(CGImage: cgim, size:NSSize(width: Constants.LENGTH, height: Constants.LENGTH))
}