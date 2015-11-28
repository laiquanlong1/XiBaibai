//
//  UserPayManagerModel.m
//  XBB
//
//  Created by Apple on 15/9/15.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "UserPayManagerModel.h"

@implementation UserPayManagerModel

- (NSString *)signMoney {
    if (!self.operate_money) {
        return @"";
    }
    if (self.operate_type == 1) {
        return [@"+" stringByAppendingString:self.operate_money];
    } else {
        return [@"-" stringByAppendingString:self.operate_money];
    }
}

@end
