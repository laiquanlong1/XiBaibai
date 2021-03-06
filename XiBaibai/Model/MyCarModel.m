//
//  MyCarModel.m
//  XBB
//
//  Created by Apple on 15/9/4.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "MyCarModel.h"

@implementation MyCarModel
//@property (assign, nonatomic) NSInteger carId;
//@property (assign, nonatomic) NSInteger uid;
//@property (assign, nonatomic) NSInteger c_type;//1 轿车  2 SUV 3MPV
//@property (assign, nonatomic) NSInteger add_time;
//@property (copy, nonatomic) NSString *c_img;
//@property (copy, nonatomic) NSString *c_plate_num;
//@property (copy, nonatomic) NSString *c_color;
//@property (copy, nonatomic) NSString *c_remark;
//@property (assign, nonatomic) NSInteger defaultID;//默认车辆
//@property (copy, nonatomic) NSString *c_brand;

- (id)copyWithZone:(nullable NSZone *)zone
{
    MyCarModel *model = [[[self class] alloc] init];
    model.carId = self.carId;
    model.uid = self.uid;
    model.c_type = self.c_type;
    model.add_time = self.add_time;
    model.c_img = self.c_img;
    model.c_plate_num = self.c_plate_num;
    model.c_color = self.c_color;
    model.c_remark = self.c_remark;
    model.defaultID = self.defaultID;
    model.c_brand = self.c_brand;
    return model;
}

- (NSString *)typeString {
    //1微型2小型3紧凑型4中型5中大型6大型7suv8mpv9跑车10皮卡11微面12电动车
    NSString *typeStr;
    switch (self.c_type) {
        case 1:
            typeStr = @"轿车";
            break;
        case 2:
            typeStr = @"SUV";
            break;
        case 3:
            typeStr = @"MPV";
            break;
        case 4:
            typeStr = @"中型";
            break;
        case 5:
            typeStr = @"中大型";
            break;
        case 6:
            typeStr = @"大型";
            break;
        case 7:
            typeStr = @"SUV";
            break;
        case 8:
            typeStr = @"MPV";
            break;
        case 9:
            typeStr = @"跑车";
            break;
        case 10:
            typeStr = @"皮卡";
            break;
        case 11:
            typeStr = @"微面";
            break;
        case 12:
            typeStr = @"电动车";
            break;
        default:
            typeStr = @"未知";
            break;
    }
    return typeStr;
}

- (NSString *)addTimeString:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.add_time];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = format;
    return [fmt stringFromDate:date];
}

- (void)setdefalutId:(NSInteger )carId{
    NSLog(@"defalut");
}

@end
