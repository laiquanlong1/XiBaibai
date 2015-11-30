//
//  XBBHomeViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/11/29.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBHomeViewController.h"

@implementation XBBHomeViewController

#pragma mark main entry

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIs];
}


#pragma mark UI

- (void)initUIs
{
    [self setNavigationBarControl];
}

- (void)setNavigationBarControl
{
    self.showNavigation = YES;
    UIImage *leftImage = [UIImage imageNamed:@"logo.png"];
    if (XBB_IsIphone6_6s) {
        leftImage = [UIImage imageNamed:@"logo.png"];
    }
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.userInteractionEnabled = YES;
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:leftImage forState:UIControlStateNormal];
    [self.xbbNavigationBar addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.centerY.mas_equalTo(self.xbbNavigationBar).mas_offset(9.f);
//        make.width.mas_equalTo(30.);
//        make.height.mas_equalTo(30.);
    }];
    
    UIButton *titleButton = [[UIButton alloc] init];
    [titleButton setBackgroundColor:[UIColor clearColor]];
    [self.xbbNavigationBar addSubview:titleButton];
    [titleButton setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.xbbNavigationBar).mas_offset(10.f);
        make.left.mas_equalTo(XBB_Screen_width/2-50.);
        make.width.mas_equalTo(100.);
    }];
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.xbbNavigationBar addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.xbbNavigationBar).mas_offset(10.f);
        make.left.mas_equalTo(XBB_Screen_width-60.);
    }];
}


#pragma mark action
- (IBAction)titleAction:(id)sender
{
    DLog(@"")
}
- (IBAction)leftButtonAction:(id)sender
{
    DLog(@"")
}

- (IBAction)rightButtonAction:(id)sender
{
    DLog(@"")
}

@end
