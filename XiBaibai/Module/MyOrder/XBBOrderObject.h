//
//  XBBOrderObject.h
//  XiBaibai
//
//  Created by HoTia on 15/12/14.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBBOrderObject : NSObject

//"c_plate_num" = "<null>";
//carinfo = " ";
//cartype = "\U8f7f\U8f66";
//id = 459;
//location = "\U56db\U5ddd\U7701\U6210\U90fd\U5e02\U53cc\U6d41\U53bf\U6ee8\U6cb3\U8def\U4e8c\U6bb5";
//"order_name" = "\U5feb\U6d17";
//"order_num" = 15110315020688087442;
//"order_state" = 2;
//orderstate = "\U5df2\U6d3e\U5355";
//"p_order_time" = "2015-11-03 15:02";
//"p_order_time_cid" = 0;
//servicetime = "\U5373\U523b\U6d17\U8f66";
//"total_price" = "25.00";


@property (nonatomic, copy) NSString *c_plate_num;
@property (nonatomic, copy) NSString *carinfo;
@property (nonatomic, copy) NSString *cartype;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *order_name;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, assign) NSInteger order_state;
@property (nonatomic, copy) NSString *p_order_time;
@property (nonatomic, assign) NSInteger p_order_time_cid;
@property (nonatomic, copy) NSString *servicetime;
@property (nonatomic, assign) float total_price;

@property (nonatomic, copy) NSString *orderstate;
@end
