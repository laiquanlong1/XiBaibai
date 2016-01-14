//
//  MyCouponsViewController.h
//  XBB
//
//  Created by Daniel on 15/9/2.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBBViewController.h"
#import "MyCouponsModel.h"

typedef void(^MyCouponsViewControllerBlock)(MyCouponsModel *model);
@interface MyCouponsViewController : XBBViewController

@property (copy, nonatomic) MyCouponsViewControllerBlock couponsBlock;
@property (nonatomic, assign) BOOL isAddoder;

@end
