//
//  UIButtonOfDesignable.h
//  XBB
//
//  Created by Apple on 15/8/30.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIButtonOfDesignable : UIButton

@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;
@property (copy, nonatomic) IBInspectable UIColor *borderColor;

@end
