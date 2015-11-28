//
//  CarInfo.m
//  XBB
//
//  Created by Daniel on 15/8/27.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "CarInfo.h"

@implementation CarInfo

+ (NSString *)carType:(NSInteger)c_type
{
    switch (c_type) {
        case 1:
        {
            return @"轿车";
        }
            break;
        case 2:
        {
            return @"SUV";
        }
            break;
        case 3:
        {
            return @"MPV";
        }
            break;
            
        default:
            break;
    }
    return nil;
}

@end
