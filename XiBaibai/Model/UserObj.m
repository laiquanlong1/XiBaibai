//
//  UserObj.m
//  XBB
//
//  Created by Daniel on 15/8/19.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "UserObj.h"

@implementation UserObj

+ (instancetype)shareInstance {
    static UserObj *user;
    if (!user) {
        user = [[UserObj alloc] init];
    }
    return user;
}

@end
