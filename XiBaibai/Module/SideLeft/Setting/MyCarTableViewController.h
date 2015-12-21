//
//  MyCarTableViewController.h
//  XBB
//
//  Created by Apple on 15/9/3.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBBTableViewController.h"
typedef  void(^Complation)(void);
@interface MyCarTableViewController : XBBTableViewController
@property (nonatomic, assign) BOOL isDownOrder;
@property (nonatomic, copy) Complation complation;
@end
