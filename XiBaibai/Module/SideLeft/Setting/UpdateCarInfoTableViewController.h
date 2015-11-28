//
//  UpdateCarInfoTableViewController.h
//  XBB
//
//  Created by mazi on 15/9/13.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCarModel.h"

@interface UpdateCarInfoTableViewController : UITableViewController

@property (strong, nonatomic) MyCarModel *carModel;

- (IBAction)back:(id)sender;

@end
