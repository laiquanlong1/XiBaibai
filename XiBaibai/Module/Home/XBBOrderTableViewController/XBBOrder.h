//
//  XBBOrder.h
//  XiBaibai
//
//  Created by HoTia on 15/12/2.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBBOrder : NSObject

@property (nonatomic, copy) NSString *xbbid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, assign) BOOL hasIndication;
@property (nonatomic, copy) NSString *detailString;
@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, strong) NSString *selectTime;

@property (nonatomic, assign) NSInteger p_wash_free;
@property (nonatomic, strong) NSMutableArray *xbbOrders;

@end
