//
//  CarInfo.h
//  XBB
//
//  Created by Daniel on 15/8/27.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarInfo : NSObject

/**
 * @brief 车信息
 * @detail 绑定车辆的信息
 * @param  add_time:添加的时间 c_color:车的颜色 c_img:车的图片 c_plate_num:
 **/
@property (strong,nonatomic) NSString *add_time;
@property (strong,nonatomic) NSString *c_color;
@property (strong,nonatomic) NSString *c_img;
@property (strong,nonatomic) NSString *c_plate_num;
@property (strong,nonatomic) NSString *c_remark;
@property (strong,nonatomic) NSString *c_type;
@property (strong,nonatomic) NSString *c_id;

+ (NSString *)carType:(NSInteger)c_type;

@end
