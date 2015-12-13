//
//  SystemObjct.h
//  XiBaibai
//
//  Created by HoTia on 15/12/13.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemObjct : NSObject

@property (nonatomic, copy) NSString *aboutUrlString;
@property (nonatomic, copy) NSString *servicePhoneString;

+ (instancetype)shareSystem;
@end
