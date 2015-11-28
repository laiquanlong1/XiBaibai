//
//  DMLineView.h
//  DMLineDemo
//
//  Created by Apple on 15/8/31.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LineDirectionType) {
    LineHorizontal = 0,
    LineVertical = 1
};
IB_DESIGNABLE
@interface DMLineView : UIView

@property (assign, nonatomic) IBInspectable CGFloat lineWidth;
@property (copy, nonatomic) IBInspectable UIColor *lineColor;
@property (assign, nonatomic) IBInspectable NSInteger lineDirection;
@property (assign, nonatomic) IBInspectable NSInteger lineLocation;//-1顶部或左边，0中间，1底部或右边
@property (assign, nonatomic) IBInspectable BOOL dotted;
@property (assign, nonatomic) IBInspectable CGFloat dottedGap;

@end
