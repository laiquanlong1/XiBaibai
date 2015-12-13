//
//  MyCouponsModel.h
//  XBB
//
//  Created by Daniel on 15/9/2.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCouponsModel : NSObject

@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *couponsId;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *coupons_name;
@property (copy, nonatomic) NSString *coupons_price;
@property (copy, nonatomic) NSString *coupons_remark;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *effective_time;
@property (copy, nonatomic) NSString *expired_time;

@end
