//
//  PayTableViewController.h
//  XBB
//
//  Created by Apple on 15/9/5.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCarModel.h"


@interface PayTableViewController : XBBViewController


// 有订单的时候跳转支付页面 （订单号，订单名称，订单id）
@property (strong, nonatomic) NSString *orderNO, *orderName, *orderId;
@property (assign, nonatomic) BOOL isRecharge; // 是否使用充值储值

// 总金额
@property (assign, nonatomic) double price;// (必须传参数)

@property (nonatomic, copy) NSMutableDictionary *dic_prama; // 订单参数

@property (nonatomic, copy) NSArray *pro_Dics; // 产品信息(必须传参数)

@property (nonatomic, copy) NSDictionary *dic; // 参数字典

@property (nonatomic, assign) NSInteger carType; // 车类型(必须传参数)

@property (nonatomic, strong) NSArray *carModels; // 车信息

@property (nonatomic, copy) NSString *location; // 地址信息

@property (nonatomic, assign) double couponprice; // 优惠价(必传)


@property (nonatomic, copy) NSString *planTime; // 预约时间


// 语音参数数据
@property (nonatomic, strong) NSData *data;

@end
