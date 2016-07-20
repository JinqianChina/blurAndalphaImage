//
//  ViewController.m
//  高斯模糊效果Demo
//
//  Created by 郭进 on 16/7/14.
//  Copyright © 2016年 郭进前. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+alpha.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *preImageView;
@property (nonatomic, strong) UIImageView *nowImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //原始图片
    self.preImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, (self.view.bounds.size.height - 20)/2)];
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    self.preImageView.image = image;
    [self.view addSubview:self.preImageView];
    
    //模糊图片
    self.nowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.preImageView.frame.size.height + 20, self.view.bounds.size.width, self.preImageView.frame.size.height)];
    image = [self imageByApplyingAplha:0.6 blurLevel:10.0 image:image];
    self.nowImageView.image = image;
    [self.view addSubview:self.nowImageView];
}

//返回一个模糊图片
- (UIImage *)imageByApplyingAplha:(CGFloat)alpha
                        blurLevel:(CGFloat)blur
                            image:(UIImage *)image
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    CGAffineTransform xform = CGAffineTransformMakeScale(1.0, 1.0);
    [affineClampFilter setValue:inputImage forKey:kCIInputImageKey];
    [affineClampFilter setValue:[NSValue valueWithBytes:&xform
                                               objCType:@encode(CGAffineTransform)]
                         forKey:@"inputTransform"];
    
    CIImage *extendedImage = [affineClampFilter valueForKey:kCIOutputImageKey];
    
    // setting up Gaussian Blur (could use one of many filters offered by Core Image)
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:extendedImage forKey:kCIInputImageKey];
    [blurFilter setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
    CIImage *result = [blurFilter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    //create a UIImage for this function to "return" so that ARC can manage the memory of the blur...
    //ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    //为图片添加透明度
    UIImage *resultImage = [returnImage applyAlpha:alpha];
    
    return resultImage;
}

@end
