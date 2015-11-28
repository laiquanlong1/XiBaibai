//
//  AddOrderViewController.h
//  XBB
//
//  Created by Daniel on 15/8/20.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mach.h"

@interface AddOrderViewController : UIViewController

@property (nonatomic, copy) NSDictionary *selectCouponWashDic; // 选择的优惠券

@property (nonatomic, copy) NSDictionary *carDic; // 车辆字典

@property (strong,nonatomic) NSString *navtitle;
@property (strong,nonatomic) NSString *c_id;
@property (strong,nonatomic) NSString *p_id;
@property (strong,nonatomic) NSString *location;
@property (strong,nonatomic) NSString *location_lg;
@property (strong,nonatomic) NSString *location_lt;
@property (strong,nonatomic) NSString *total_price;
@property (retain, nonatomic) AVAudioPlayer *avPlay;

@end
