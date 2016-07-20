//
//  UIImage+alpha.m
//  高斯模糊效果Demo
//
//  Created by 郭进 on 16/7/14.
//  Copyright © 2016年 郭进前. All rights reserved.
//

#import "UIImage+alpha.h"

@implementation UIImage (alpha)

- (UIImage *)applyAlpha:(CGFloat)alpha
{
    int bmpAlpha = MIN(255, MAX(0, (255*alpha)));
    UIImage *image;
    int width = self.size.width * self.scale;
    int height = self.size.height * self.scale;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    if (colorspace == NULL) {
        NSLog(@"Create Colorspace Error!");
        return nil;
    }
    
    Byte *imgData = NULL;
    imgData = malloc(width * height * 4);
    if (imgData == NULL) {
        NSLog(@"Memory Error!");
        CGColorSpaceRelease(colorspace);
        return nil;
    }
    
    CGContextRef bmpContext = CGBitmapContextCreate(imgData, width, height, 8, width * 4, colorspace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    if (!bmpContext) {
        NSLog(@"Create Bitmap context Error!");
        CGColorSpaceRelease(colorspace);
        return nil;
    }
    
    CGContextDrawImage(bmpContext, CGRectMake(0, 0, width, height), self.CGImage);
    for (long i = 0; i < width * height; i++) {
        imgData[4*i+3] = bmpAlpha;
    }
    
    CGImageRef imageRef = CGBitmapContextCreateImage(bmpContext);
    if (imageRef != NULL) {
        image = [[UIImage alloc] initWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
    
    CGColorSpaceRelease(colorspace);
    CGContextRelease(bmpContext);
    free(imgData);
    
    return image;
}

@end
