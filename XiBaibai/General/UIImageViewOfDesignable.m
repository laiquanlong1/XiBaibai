//
//  UIImageViewOfDesignable.m
//  XBB
//
//  Created by Apple on 15/8/30.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "UIImageViewOfDesignable.h"

@implementation UIImageViewOfDesignable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    _cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
    _borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
    _borderColor = borderColor;
}

@end
