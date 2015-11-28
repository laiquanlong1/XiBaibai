//
//  CarListTableViewController.h
//  XiBaibai
//
//  Created by Apple on 15/9/20.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarBrandModel.h"

typedef void(^CarBrandSelectBlock)(id param);

@interface CarListTableViewController : UITableViewController

@property (copy, nonatomic) CarBrandSelectBlock brandSelectedCallback;

@end
