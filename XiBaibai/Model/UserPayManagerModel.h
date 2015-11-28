//
//  UserPayManagerModel.h
//  XBB
//
//  Created by Apple on 15/9/15.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPayManagerModel : NSObject

@property (copy, nonatomic) NSString *operate_time;
@property (copy, nonatomic) NSString *operate_money;
@property (copy, nonatomic) NSString *remark;
@property (assign, nonatomic) int operate_type;//1收入、2支出

- (NSString *)signMoney;

@end
