//
//  CarListTableViewController.h
//  XiBaibai
//
//  Created by Apple on 15/9/20.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarBrandModel.h"
#import "XBBViewController.h"

typedef void(^CarBrandSelectBlock)(id param);

@interface CarListTableViewController : XBBViewController

@property (copy, nonatomic) CarBrandSelectBlock brandSelectedCallback;

@end
