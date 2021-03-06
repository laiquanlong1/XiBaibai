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










@property (nonatomic, assign) float coupons_price;
@property (nonatomic, copy) NSString *advice;
@property (nonatomic, copy) NSString *user_evaluate;
@property (nonatomic, copy) NSArray *washimg;


@property (nonatomic, copy) NSArray *prolist;
@property (nonatomic, copy) NSString *order_id;
@property (copy, nonatomic) NSString *pay_type;//"pay_type" = "--";
@property (copy, nonatomic) NSString  *pay_time;//"pay_time" = "--";
@property (assign, nonatomic) NSInteger pay_num;//"pay_num" = "0.01";
@property (assign, nonatomic) NSInteger p_order_time_cid;
@property (copy, nonatomic) NSString *car_wash_before_img;
@property (copy, nonatomic) NSString *car_wash_end_img;
@property (assign, nonatomic) NSInteger emp_advice;
@property (copy, nonatomic) NSString *emp_advice_imgs;
@property (copy, nonatomic) NSString *emp_reminder;
@property (copy, nonatomic) NSString *emp_img;
@property (copy, nonatomic) NSString *emp_num;
@property (copy, nonatomic) NSString *emp_iphone;
@property (copy, nonatomic) NSString *emp_name;
@property (copy, nonatomic) NSString *act_id;
@property (copy, nonatomic) NSString *audio;
@property (copy, nonatomic) NSString *c_ids;
@property (nonatomic, assign) NSInteger c_type;
@property (copy, nonatomic) NSString *c_name;
@property (copy, nonatomic) NSString *c_plate_num;
@property (copy, nonatomic) NSString *c_brand;
@property (copy, nonatomic) NSString *c_color;
//totalprice = 99;
@property (copy, nonatomic) NSString *carinfo;
@property (assign, nonatomic) NSInteger orderId;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *location_lg;
@property (copy, nonatomic) NSString *location_lt;
@property (assign, nonatomic) NSInteger operate_time;
@property (assign, nonatomic) NSInteger order_reg_id;
@property (copy, nonatomic) NSString *p_ids;//"p_ids" = "1,12,15,14,33,13";
@property (copy, nonatomic) NSString *p_order_time;
@property (copy, nonatomic) NSString *plan_time;
@property (copy, nonatomic) NSString *remark;
@property (assign, nonatomic) NSInteger state;
@property (nonatomic, assign) float totalprice;
@property (copy, nonatomic) NSString *total_price;
@property (assign, nonatomic) NSInteger uid;
@property (copy, nonatomic) NSString *order_num;
@property (copy, nonatomic) NSString *order_name;
@property (assign, nonatomic) NSInteger order_state;
@property (copy, nonatomic) NSString *star;
@property (copy, nonatomic) NSString *servicetime;//servicetime = "\U5373\U523b\U6d17\U8f66";
@property (copy, nonatomic) NSString *cartype;
@property (copy, nonatomic) NSString *coupons;
@property (nonatomic, assign) NSInteger order_star;
//"user_remark" = "<null>";
@property (nonatomic, copy) NSString *user_remark;
@property (nonatomic, copy) NSString *uname;
- (NSString *)orderStateString;

@end
