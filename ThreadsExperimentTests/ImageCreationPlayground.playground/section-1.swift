// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
struct PixelData {
    var r:UInt8
    var g:UInt8
    var b:UInt8
    var a:UInt8
}

var pixelArray = [PixelData](count: 160, repeatedValue: PixelData(r: 128, g: 128, b: 255, a: 254))
var data = NSData(bytes: &pixelArray, length: pixelArray.count * sizeof(PixelData))
//data.length
//let b:UnsafePointer<UInt8> = data.bytes.
//let bytes = UnsafeArray<UInt8>(start:data.bytes, length:data.length)
//let bytes = UnsafeBufferPointer<UInt8>(start:data.bytes, length:data.length)
//println(bytes)
*/

struct PixelData {
    var r:UInt8
    var g:UInt8
    var b:UInt8
    var a:UInt8 = 255
}

UInt8(0.01 * 255)

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

var pixelArray = [PixelData](count: 160, repeatedValue: PixelData(r: 128, g: 128, b: 255, a: 255))
let image1 = imageFromARGB32Bitmap(pixelArray, 40, 40)

//sizeof(pixelArray)