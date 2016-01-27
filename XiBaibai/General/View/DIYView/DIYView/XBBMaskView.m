//
//  XBBMaskView.m
//  XiBaibai
//
//  Created by xbb01 on 16/1/22.
//  Copyright © 2016年 Mingle. All rights reserved.
//

#import "XBBMaskView.h"

@implementation XBBMaskView

- (void)drawRect:(CGRect)rect {
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.6);
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGRect drawRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
    CGContextFillRect(ctx, drawRect);
    CGContextClearRect(ctx, CGRectMake([[UIScreen mainScreen] bounds].size.width/6, [[UIScreen mainScreen] bounds].size.height/10+64, [[UIScreen mainScreen] bounds].size.width/6*4, [[UIScreen mainScreen] bounds].size.width/6*4));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imag = [[UIImageView alloc] initWithImage:image];
    imag.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:imag];
}


@end
