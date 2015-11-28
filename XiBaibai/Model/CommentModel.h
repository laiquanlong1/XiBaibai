//
//  CommentModel.h
//  XBB
//
//  Created by mazi on 15/9/4.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

/*
 accounts = 12312;
 "act_id" = "<null>";
 audio = "b75cfbd37c898091b167898e192d5ffc.aac";
 "c_brand" = "";
 "c_car" = "<null>";
 "c_color" = "\U84dd\U8272";
 "c_ids" = 15;
 "c_plate_num" = aaa;
 "car_wash_before_img" = "";
 "car_wash_end_img" = "";
 comment = "\U5f20\U5e08\U5085\U4e0d\U9519\U54e6";
 "comment_time" = 1442500950;
 "current_address" = "\U6b66\U4faf\U533a\U502a\U5bb6\U6865\U5730\U94c1\U53e3";
 "current_address_lg" = "106.6660000";
 "current_address_lt" = "30.3333000";
 "emp_advice" = "";
 "emp_advice_imgs" = "";
 "emp_id" = 1;
 "emp_img" = "";
 "emp_iphone" = 15528367910;
 "emp_name" = "\U5f20\U5e08\U5085";
 "emp_num" = 1;
 "emp_reminder" = "";
 id = 2;
 "identiy_id" = 1;
 "last_time" = "<null>";
 location = "\U5317\U4eac\U5e02\U4e1c\U57ce\U533a\U5e7f\U573a\U897f\U4fa7\U8def";
 "location_lg" = "116.4029670";
 "location_lt" = "39.9129400";
 "operate_time" = 0;
 "order_customer" = "";
 "order_id" = 107;
 "order_num" = 15091621118948370828;
 "order_plate_num" = "";
 "order_reg_id" = 1;
 "order_state" = 5;
 "order_way" = 1;
 "p_ids" = 1;
 "p_order_time" = 1442409063;
 "p_order_time_cid" = 0;
 "pay_num" = "0.00";
 "pay_time" = 0;
 "pay_type" = 0;
 "plan_time" = "";
 pwd = 4122312;
 remark = "";
 star = "4.0";
 state = 2;
 "total_price" = "20.00";
 type = 1;
 uid = 26;
 */

@property (copy, nonatomic) NSString *commentId;
@property (copy, nonatomic) NSString *order_id;
@property (copy, nonatomic) NSString *order_num;
@property (copy, nonatomic) NSString *emp_num;
@property (copy, nonatomic) NSString *emp_name;
@property (copy, nonatomic) NSString *emp_img;
@property (copy, nonatomic) NSString *emp_id;
@property (copy, nonatomic) NSString *emp_iphone;
@property (assign, nonatomic) float star;
@property (copy, nonatomic) NSString *comment;
@property (assign, nonatomic) long comment_time;
@property (copy, nonatomic) NSString *c_plate_num;
@property (copy, nonatomic) NSString *c_color;
@property (copy, nonatomic) NSString *c_brand;

@end
