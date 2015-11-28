//
//  TimeConfigModel.h
//  XiBaibai
//
//  Created by Apple on 15/9/20.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeConfigModel : NSObject
/*
 count = 0;
 id = 1;
 max = 5;
 time = "9:00-10:00";
 */

@property (copy, nonatomic) NSString *time;
@property (assign, nonatomic) NSInteger count, timeConfigId, max;

@end
