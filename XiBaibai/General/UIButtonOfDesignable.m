//
//  UIButtonOfDesignable.m
//  XBB
//
//  Created by Apple on 15/8/30.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "UIButtonOfDesignable.h"

@implementation UIButtonOfDesignable

- (instancetype)init {
    if (self = [super init]) {
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.borderWidth = self.borderWidth;
        self.layer.borderColor = self.borderColor.CGColor;
    }
    return self;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
    self.cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
    self.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
    self.borderColor = borderColor;
}

@end
