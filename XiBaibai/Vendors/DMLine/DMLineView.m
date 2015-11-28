//
//  DMLineView.m
//  DMLineDemo
//
//  Created by Apple on 15/8/31.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "DMLineView.h"

@implementation DMLineView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //NO.1画一条线
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    if (self.lineDirection == LineHorizontal) {
        CGFloat y;
        switch (_lineLocation) {
            case -1:
                y = 0;
                break;
            case 0:
                y = (CGRectGetHeight(self.frame) - _lineWidth) / 2.0;
                break;
            default:
                y = self.frame.size.height - _lineWidth;
                break;
        }
        if (self.dotted) {
            NSInteger runloopTime = ceil(rect.size.width / (self.dottedGap * 2));
            for (int i = 0; i < runloopTime; i++) {
                CGContextMoveToPoint(context, i == 0? 0: self.dottedGap * 2 * i, y);
                CGContextAddLineToPoint(context, (i == 0? 0: self.dottedGap * 2 * i) + self.dottedGap, y);
            }
        } else {
            CGContextMoveToPoint(context, 0, y);
            CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), y);
        }
    } else {
        CGFloat x;
        switch (_lineLocation) {
            case -1:
                x = 0;
                break;
            case 0:
                x = (CGRectGetWidth(self.frame) - _lineWidth) / 2.0;
                break;
            default:
                x = self.frame.size.width - _lineWidth;
                break;
        }
        if (self.dotted) {
            NSInteger runloopTime = ceil(rect.size.width / (self.dottedGap * 2));
            for (int i = 0; i < runloopTime; i++) {
                CGContextMoveToPoint(context, x, i == 0? 0: self.dottedGap * 2 * i);
                CGContextAddLineToPoint(context, x, (i == 0? 0: self.dottedGap * 2 * i) + self.dottedGap);
            }
        } else {
            CGContextMoveToPoint(context, x, 0);
            CGContextAddLineToPoint(context, x, CGRectGetHeight(self.frame));
        }
    }
    CGContextStrokePath(context);
    self.backgroundColor = [UIColor clearColor];
}

@end