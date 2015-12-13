//
//  UserObj.h
//  XBB
//
//  Created by Daniel on 15/8/19.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyCarModel.h"

@interface UserObj : NSObject

@property (copy, nonatomic) NSString *ads_id;
@property (copy, nonatomic) NSString *age;
@property (copy, nonatomic) NSString *c_id;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *iphone;
@property (copy, nonatomic) NSString *profession;
@property (copy, nonatomic) NSString *QQ;
@property (copy, nonatomic) NSString *imgstring;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *uname;
@property (copy, nonatomic) NSString *weixin;
@property (copy, nonatomic) MyCarModel *carModel;
@property (copy, nonatomic) UIImage  *headImage;

//保存其他一些用户信息
@property (copy, nonatomic) NSString *homeAddress, *homeDetailAddress, *companyAddress, *companyDetailAddress,*currentAddress,*currentAddressDetail;
@property (assign, nonatomic) CLLocationCoordinate2D homeCoordinate, companyCoordinate, currentCoordinate;

+ (instancetype)shareInstance;

@end
