//
//  MyOrderModel.m
//  XBB
//
//  Created by Apple on 15/8/30.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "MyOrderModel.h"

@implementation MyOrderModel

- (NSString *)orderStateString {
//0未付款1派单中2已派单3在路上4进行中5未评价6已评价7已取消
    NSString *str;
    switch (self.order_state) {
        case 0:
            str = @"未付款";
            break;
        case 1:
            str = @"派单中";
            break;
        case 2:
            str = @"已派单";
            break;
        case 3:
            str = @"在路上";
            break;
        case 4:
            str = @"进行中";
            break;
        case 5:
            str = @"未评价";
            break;
        case 6:
            str = @"已评价";
            break;
        case 7:
            str = @"已取消";
            break;
        default:
            str = @"未知";
            break;
    }
    return str;
}

@end
