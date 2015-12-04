//
//  XBBViewController.m
//  xbb
//
//  Created by HoTia on 15/11/26.
//  Copyright © 2015年 *. All rights reserved.
//

#import "XBBViewController.h"
#import "Reachability.h"


@interface XBBViewController ()
{
    Reachability *reachability;
}
@end

@implementation XBBViewController


#pragma mark baseDatas
- (void)initViewWillAppearDatas
{
    
}
- (void)initViewDidLoadDatas
{
    
}

#pragma mark BaseView
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [self initViewWillAppearDatas];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self disposeWillUI];
        });
    });
    
   
}

- (void)disposeDidLoadUI
{
    
}
- (void)disposeWillUI
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initViewDidLoadDatas];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self disposeDidLoadUI];
        });
    });
    [self initBackScrollView];
    self.view.backgroundColor = XBB_Bg_Color;
    self.haveConnection = NO;
    reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status != NotReachable) {
        self.haveConnection = YES;
        [self changeNetStatusHaveConnection];
    }else
    {
        self.haveConnection = NO;
        [self changeNetStatusHaveDisconnection];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkchange:) name:kReachabilityChangedNotification object:nil];
    [reachability startNotifier];
}

- (void)addNavigationBar
{
    _xbbNavigationBar = [[UIView alloc] init];
    _xbbNavigationBar.backgroundColor = XBB_NavBar_Color;
    [self.view addSubview:_xbbNavigationBar];
    [_xbbNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(XBB_Screen_width);
        make.height.mas_equalTo(64.);
    }];
}

- (void)initBackScrollView
{
    self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.backgroundScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.backgroundScrollView];
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
