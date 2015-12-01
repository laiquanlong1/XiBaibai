//
//  XBBHomeViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/11/29.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBHomeViewController.h"
#import "XBBBannerView.h"

@interface XBBHomeViewController() <UIScrollViewDelegate>
{
    UIScrollView  *_bannerScrollView;
//    BOOL isOk;
//    float ok;
    
}
@property (nonatomic, strong) UIPageControl *pageControl;
@end

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
//    [self setUpBanner];
    [self setBanner];

}
- (void)setBanner
{
    XBBBannerView *banner = [[XBBBannerView alloc] initWithFrame:CGRectMake(0, self.xbbNavigationBar.frame.size.height, XBB_Screen_width, 200) imagesNames:@[@"dsd",@"dsd",@"dssd",@"dsds",@"dasdas"]];
    [self.backgroundScrollView addSubview:banner];
}
- (IBAction)one:(id)sender
{
    
}
- (void)setUpBanner
{
    _bannerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.xbbNavigationBar.frame.size.height, XBB_Screen_width, 300)];
    _bannerScrollView.contentSize = CGSizeMake(XBB_Screen_width * 6, 0);
    for (int i = 0; i < 5; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * XBB_Screen_width, 0, XBB_Screen_width, _bannerScrollView.frame.size.height)];
        switch (i) {
            case 0:
            {
                button.backgroundColor = [UIColor blueColor];
            }
                break;
            case 1:
            {
                 button.backgroundColor = [UIColor orangeColor];
            }
                break;
            case 2:
            {
                 button.backgroundColor = [UIColor grayColor];
            }
                break;
            case 3:
            {
                 button.backgroundColor = [UIColor redColor];
            }
                break;
            case 4:
            {
                 button.backgroundColor = [UIColor blueColor];
            }
                break;
            default:
                break;
        }
        [_bannerScrollView addSubview:button];
    }
    _bannerScrollView.pagingEnabled = YES;
    _bannerScrollView.showsHorizontalScrollIndicator = NO;
    _bannerScrollView.showsVerticalScrollIndicator = NO;
    _bannerScrollView.delegate = self;
    [self.backgroundScrollView addSubview:_bannerScrollView];

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
