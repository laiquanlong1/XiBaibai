//
//  XBBProObject.h
//  XiBaibai
//
//  Created by HoTia on 15/12/7.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBBProObject : NSObject
@property (nonatomic, copy) NSString *p_name;
@property (nonatomic, copy) NSString *p_id;
@property (nonatomic, assign) float price_1;
@property (nonatomic, assign) float price_2;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *p_info;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, assign) NSInteger p_wash_free;
@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, assign) NSInteger type; // 1是diy 2是facial

@end
