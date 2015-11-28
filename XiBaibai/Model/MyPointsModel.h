//
//  MyPointsModel.h
//  XBB
//
//  Created by Daniel on 15/9/7.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPointsModel : NSObject

@property (copy, nonatomic) NSString *pointId;
@property (copy, nonatomic) NSString *points;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *point_name;
@property (assign, nonatomic) int type;

@end
