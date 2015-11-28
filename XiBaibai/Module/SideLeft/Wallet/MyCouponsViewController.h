//
//  MyCouponsViewController.h
//  XBB
//
//  Created by Daniel on 15/9/2.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyCouponsViewControllerBlock)(id);
@interface MyCouponsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *CouponsTableview;
@property (copy, nonatomic) MyCouponsViewControllerBlock couponsBlock;

@end
