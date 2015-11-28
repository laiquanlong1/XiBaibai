//
//  XBBTableViewController.m
//  xbb
//
//  Created by HoTia on 15/11/26.
//  Copyright © 2015年 *. All rights reserved.
//

#import "XBBTableViewController.h"
#import "Reachability.h"

@interface XBBTableViewController ()
{
    Reachability *reachability;
}
@end

@implementation XBBTableViewController

#pragma mark BaseView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XBB_Bg_Color;
    self.haveConnection = NO;
    reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status != NotReachable) {
        [self changeNetStatusHaveConnection];
        self.haveConnection = YES;
    }else
    {
        self.haveConnection = NO;
        [self changeNetStatusHaveDisconnection];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkchange:) name:kReachabilityChangedNotification object:nil];
    [reachability startNotifier];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)addNavigationBar
{
    _xbbNavigationBar = [[UIView alloc] init];
    _xbbNavigationBar.backgroundColor = XBB_NavBar_Color;
//    _xbbNavigationBar.layer.opacity = 0.8;
//    _xbbNavigationBar.layer.masksToBounds = YES;
//    _xbbNavigationBar.layer.shadowOffset = CGSizeMake(20, 20);
//    _xbbNavigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view insertSubview:_xbbNavigationBar atIndex:1];
    [_xbbNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(XBB_Screen_width);
        make.height.mas_equalTo(64.);
    }];
}

- (void)setShowNavigation:(BOOL)showNavigation
{
    if (_showNavigation!=showNavigation) {
        _showNavigation = showNavigation;
    }
    if (showNavigation) {
        [self addNavigationBar];
    }
}

#pragma mark NetNotification

- (IBAction)netWorkchange:(id)sender
{
    NetworkStatus status = [reachability currentReachabilityStatus];
    switch (status) {
        case NotReachable:
        {
            self.haveConnection = NO;
            [self changeNetStatusHaveDisconnection];
        }
            break;
        default:
        {
             self.haveConnection = YES;
            [self changeNetStatusHaveConnection];
        }
            break;
    }
}

- (void)changeNetStatusHaveConnection
{
    
}
- (void)changeNetStatusHaveDisconnection
{
    
}

#pragma mark SetNULL
- (void)dealloc
{
    [reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    reachability = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
