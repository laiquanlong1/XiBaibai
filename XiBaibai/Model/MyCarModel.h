//
//  MyCarModel.h
//  XBB
//
//  Created by Apple on 15/9/4.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCarModel : NSObject <NSCopying>

@property (assign, nonatomic) NSInteger carId;
@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) NSInteger c_type;//1 轿车  2 SUV 3MPV
@property (assign, nonatomic) NSInteger add_time;
@property (copy, nonatomic) NSString *c_img;
@property (copy, nonatomic) NSString *c_plate_num;
@property (copy, nonatomic) NSString *c_color;
@property (copy, nonatomic) NSString *c_remark;
@property (assign, nonatomic) NSInteger defaultID;//默认车辆
@property (copy, nonatomic) NSString *c_brand;

- (NSString *)typeString;
- (NSString *)addTimeString:(NSString *)format;
- (id)copyWithZone:(nullable NSZone *)zone;

@end
