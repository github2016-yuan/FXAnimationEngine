//
//  UIImage+FXDecoder.m
//  FXAnimationEngineDemo
//
//  Created by ShawnFoo on 17/3/1.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "UIImage+FXDecoder.h"

@implementation UIImage (FXDecoder)

- (UIImage *)fx_decodedImage {
    CGImageRef imgRef = self.CGImage;
    if (!imgRef) {
        return nil;
    }
    size_t imgWidth = CGImageGetWidth(imgRef);
    size_t imgHeight = CGImageGetHeight(imgRef);
    if (0 == imgWidth || 0 == imgHeight) {
        return nil;
    }
	
    const size_t cBPC = 8;
    const size_t cBytesPR = 0;
    
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imgRef);
    BOOL hasAlpha = (kCGImageAlphaPremultipliedFirst == alphaInfo
                     || kCGImageAlphaPremultipliedLast == alphaInfo
                     || kCGImageAlphaFirst == alphaInfo
                     || kCGImageAlphaLast == alphaInfo);
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
    bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imgWidth,
                                                 imgHeight,
                                                 cBPC,
                                                 cBytesPR,
                                                 CGColorSpaceCreateDeviceRGB(),
                                                 bitmapInfo);
	UIImage *decodedImage = nil;
    if (context) {
        CGContextDrawImage(context,
                           CGRectMake(0, 0, imgWidth, imgHeight),
                           imgRef);
        CGImageRef decodedImgRef = CGBitmapContextCreateImage(context);
		decodedImage = [UIImage imageWithCGImage:decodedImgRef];
        CFRelease(context);
		CFRelease(decodedImgRef);
    }
    return decodedImage;
}

@end
