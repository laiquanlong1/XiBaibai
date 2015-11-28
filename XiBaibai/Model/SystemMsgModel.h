//
//  SystemMsgModel.h
//  XBB
//
//  Created by Apple on 15/9/15.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMsgModel : NSObject

@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) NSInteger msgId;
@property (copy, nonatomic) NSString *a_m_tit;
@property (copy, nonatomic) NSString *a_m_con;
@property (copy, nonatomic) NSString *a_m_time;
@property (assign, nonatomic) NSInteger a_m_type;

@end
