//
//  XBBTableViewController.h
//  XiBaibai
//
//  Created by HoTia on 15/12/4.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBViewController.h"

@interface XBBTableViewController : XBBViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

- (void)addTabelView:(UITableViewStyle)style;


@end
