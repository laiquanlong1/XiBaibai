//
//  AddPlanOrderViewController.h
//  XBB
//
//  Created by Daniel on 15/8/21.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mach.h"


typedef void(^AddPlanTime)(NSString *time);
@interface AddPlanOrderViewController : UIViewController
@property (nonatomic, copy) AddPlanTime planTime;  // 返回的block
@property (nonatomic, copy) NSString *timePlan;//预约时间

@end
