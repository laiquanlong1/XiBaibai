//
//  MyOrderModel.h
//  XBB
//
//  Created by Apple on 15/8/30.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject

/*
 "act_id" = "<null>";
 audio = "";
 "c_ids" = "";
 "car_wash_before_img" = "";
 "car_wash_end_img" = "";
 "emp_advice" = 0;
 "emp_advice_imgs" = "";
 "emp_reminder" = "";
 id = 3;
 location = "\U94f6\U6cb3\U5317\U8857150\U534e\U5b87\U00b7\U9526\U57ce\U540d\U90fd\U534e\U5b87\U00b7\U9526\U57ce\U540d\U90fd(\U897f\U53571\U95e8)";
 "location_lg" = "104.0420160";
 "location_lt" = "30.7003310";
 "operate_time" = 0;
 "order_name" = "\U5feb\U6d17\U7cbe\U6d17";
 "order_num" = "<null>";
 "order_reg_id" = "<null>";
 "order_state" = 0;
 "p_ids" = "1,2";
 "p_order_time" = 1438851420;
 "p_order_time_cid" = 0;
 "pay_num" = 0;
 "pay_time" = 0;
 "pay_type" = 0;
 "plan_time" = 4285568;
 remark = "\U5907\U6ce8";
 state = 0;
 "total_price" = "0.00";
 uid = 26;
*/

@property (assign, nonatomic) NSInteger pay_type;
@property (assign, nonatomic) NSInteger pay_time;
@property (assign, nonatomic) NSInteger pay_num;
@property (assign, nonatomic) NSInteger p_order_time_cid;
@property (copy, nonatomic) NSString *car_wash_before_img;
@property (copy, nonatomic) NSString *car_wash_end_img;
@property (assign, nonatomic) NSInteger emp_advice;
@property (copy, nonatomic) NSString *emp_advice_imgs;
@property (copy, nonatomic) NSString *emp_reminder;
@property (copy, nonatomic) NSString *emp_img;
@property (copy, nonatomic) NSString *emp_num;
@property (copy, nonatomic) NSString *emp_name;
@property (copy, nonatomic) NSString *act_id;
@property (copy, nonatomic) NSString *audio;
@property (copy, nonatomic) NSString *c_ids;
@property (copy, nonatomic) NSString *c_name;
@property (copy, nonatomic) NSString *c_plate_num;
@property (copy, nonatomic) NSString *c_brand;
@property (copy, nonatomic) NSString *c_color;
@property (assign, nonatomic) NSInteger orderId;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *location_lg;
@property (copy, nonatomic) NSString *location_lt;
@property (assign, nonatomic) NSInteger operate_time;
@property (assign, nonatomic) NSInteger order_reg_id;
@property (copy, nonatomic) NSString *p_ids;
@property (copy, nonatomic) NSString *p_order_time;
@property (copy, nonatomic) NSString *plan_time;
@property (copy, nonatomic) NSString *remark;
@property (assign, nonatomic) NSInteger state;
@property (copy, nonatomic) NSString *total_price;
@property (assign, nonatomic) NSInteger uid;
@property (copy, nonatomic) NSString *order_num;
@property (copy, nonatomic) NSString *order_name;
@property (assign, nonatomic) NSInteger order_state;
@property (copy, nonatomic) NSString *star;

- (NSString *)orderStateString;

@end
