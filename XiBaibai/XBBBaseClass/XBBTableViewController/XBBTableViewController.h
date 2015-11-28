//
//  XBBTableViewController.h
//  xbb
//
//  Created by HoTia on 15/11/26.
//  Copyright © 2015年 *. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBBTableViewController : UITableViewController

@property (nonatomic, copy, nullable) NSString *navigationTitle;
@property (nullable, nonatomic, strong) UIView *xbbNavigationBar;
@property (nonatomic, assign) BOOL showNavigation;
@property (nonatomic, assign) BOOL haveConnection;

- (void)changeNetStatusHaveConnection;
- (void)changeNetStatusHaveDisconnection;

@end
