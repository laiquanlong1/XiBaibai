//
//  AddOrderViewController.h
//  XBB
//
//  Created by Daniel on 15/8/20.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddOrderViewController : XBBViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *selectArray;

@property (nonatomic, assign) BOOL hasLocation;

@end
