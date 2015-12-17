//
//  XBBOrderInfoViewController.h
//  XiBaibai
//
//  Created by HoTia on 15/12/15.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBViewController.h"

@interface XBBOrderInfoViewController : XBBViewController

@property (nonatomic, copy) NSString* orderid ,*orderNum , *orderName;
@property (nonatomic, assign) BOOL isPayBack;
@property (nonatomic, assign) NSInteger pageController; // 1 第一次支付 2.列表页 
@end
