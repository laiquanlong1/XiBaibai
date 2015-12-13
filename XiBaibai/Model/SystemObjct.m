//
//  SystemObjct.m
//  XiBaibai
//
//  Created by HoTia on 15/12/13.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "SystemObjct.h"

@implementation SystemObjct

+ (instancetype)shareSystem
{
    static SystemObjct *system;
    if (!system) {
        system = [[SystemObjct alloc] init];
    }
    return system;
}
@end
