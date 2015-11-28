//
//  DiyModel.h
//  XBB
//
//  Created by Apple on 15/9/17.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiyModel : NSObject
/*
 "id":"21",
 "p_name":"内饰SPA",
 "p_price":"0.00",
 "p_info":"内饰SPA",
 "p_type":"0",
 "p_type_t":"5",
 "p_cuo":"",
 "p_time":"0",
 "p_wimg":"w3x_32.png",
 "p_ximg":"x3x_32.png"
 */

@property (copy, nonatomic) NSString *diyId;
@property (copy, nonatomic) NSString *p_name;
@property (copy, nonatomic) NSString *p_price;
@property (copy, nonatomic) NSString *p_info;
@property (copy, nonatomic) NSString *p_type;
@property (copy, nonatomic) NSString *p_type_t;
@property (copy, nonatomic) NSString *p_cuo;
@property (copy, nonatomic) NSString *p_time;
@property (copy, nonatomic) NSString *p_wimg;
@property (copy, nonatomic) NSString *p_ximg;

@end
