//
//  OrderTopView.m
//  XBB
//
//  Created by Apple on 15/9/5.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "OrderTopView.h"

@implementation OrderTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (id)orderTopView {
    OrderTopView *view = [[[UINib nibWithNibName:@"OrderTopView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    return view;
}

@end
