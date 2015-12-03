//
//  IndexViewController.m
//  XBB
//
//  Created by Daniel on 15/8/4.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "XBBHomeViewController.h"
#import "UIImage+ImageScaleSize.h"
#import <BaiduMapAPI/BMKMapView.h>
#import "CustamViewController.h"
#import "AddOrderViewController.h"
#import "AddPlanOrderViewController.h"
#import "AppDelegate.h"
#import "UserObj.h"
#import "UIViewController+MMDrawerController.h"
#import "LoginViewController.h"
#import "MyCarTableViewController.h"
#import "BPush.h"
#import "MyCarTableViewController.h"
#import "XBBBannerView.h"
#import "XBBBannerObject.h"
#import "WebViewController.h"

@interface XBBHomeViewController ()<XBBBannerViewDelegate>{
    UIImageView    *leftNavigationBotton;
    UIButton       *titleCityButton;
    XBBBannerView  *banner;
    NSArray        *bannerArrayData;
    
}


@end

@implementation XBBHomeViewController


#pragma mark featchData
- (void)feachDatas
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    });
}
- (void)feachBannerData
{
    [NetworkHelper postWithAPI:XBB_Banner_roop parameter:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = response;
        if ([dic[@"code"] integerValue] == 1) {
            NSArray  *contentDics = dic[@"result"];
            NSMutableArray *objects = [NSMutableArray array];
            for (NSDictionary *dic_1 in contentDics) {
                XBBBannerObject *ob = [[XBBBannerObject alloc] init];
                ob.oid = dic_1[@"id"];
                ob.imageUrl = [NSString stringWithFormat:@"%@/%@",ImgDomain,dic_1[@"thumb"]];
                ob.url = dic_1[@"url"];
                ob.title = dic_1[@"title"];
                [objects addObject:ob];
            }
            bannerArrayData = [objects copy];
            [self addBannerWithModels:bannerArrayData];
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            });
            
        }
        DLog(@"%@",response);
       
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"获取轮播网络错误"];
        });
    }];
}


#pragma mark XbbBannerViewDelegate

- (void)xbbBanner:(id)sender
{
    UITapGestureRecognizer *tap = sender;
    UIView *view = tap.view;
    XBBBannerObject *object = nil;
    for (XBBBannerObject *o in bannerArrayData) {
        if ([o.oid integerValue] == view.tag) {
            object = o;
        }
    }
    if (object) {
        WebViewController *webView = [[WebViewController alloc] init];
        webView.navigationTitle = object.title;
        webView.urlString = object.url;
        [self presentViewController:webView animated:YES completion:nil];
    }
   
}

#pragma mark NetAbserver

- (void)changeNetStatusHaveDisconnection
{
   
}
- (void)changeNetStatusHaveConnection
{
   
}

#pragma mark notifaction
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserSuccessfulIndex:) name:NotificationUpdateUserSuccessful object:nil];
    
}

- (void)removeNotifaction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationUpdateUserSuccessful object:nil];
}
#pragma mark view disposed

- (void)viewDidLoad {
    [super viewDidLoad];
    [self feachDatas];
    [self initUI];
    [self addNotification];
    if (IsLogin) {
        UserObj *us = [UserObj shareInstance];
        us.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUserSuccessful object:nil];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self feachBannerData];
    });
  
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeBanner];
}

- (void)initUI
{
    [self setNavigationBarControl];
}

- (void)setNavigationBarControl
{
    self.showNavigation = YES;
    //导航栏左边
    leftNavigationBotton=[[UIImageView alloc] initWithFrame:CGRectMake(20.,25., 30, 30)];
    leftNavigationBotton.layer.masksToBounds=YES;
    leftNavigationBotton.layer.cornerRadius=15;
    leftNavigationBotton.image=[UIImage imageNamed:@"nav1.png"];
    leftNavigationBotton.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonAction:)];
    [leftNavigationBotton addGestureRecognizer:tap];
    [self.xbbNavigationBar addSubview:leftNavigationBotton];
    
    
    UIImage *image = [UIImage imageNamed:@"xbb_log"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(XBB_Screen_width/2-image.size.width/2-10, 32.-image.size.height/2+10, image.size.width, image.size.height)];
    [self.xbbNavigationBar addSubview:titleImageView];
    titleImageView.image = image;
    titleImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleAction:)];
    [titleImageView addGestureRecognizer:titleTap];
    
    titleCityButton = [[UIButton alloc] initWithFrame:CGRectMake(titleImageView.frame.size.width+titleImageView.frame.origin.x-7, titleImageView.frame.origin.y + 8, 50, 12)];
    
    UIImage *titImage_2 = [UIImage imageNamed:@"xbbDownLog"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleCityButton.bounds.size.width-titImage_2.size.width, titleCityButton.bounds.size.height/2, titImage_2.size.width, titImage_2.size.height)];
    imageView.image = titImage_2;
    [titleCityButton addSubview:imageView];
    [titleCityButton.titleLabel setFont:[UIFont systemFontOfSize:13.]];
    [titleCityButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleCityButton setBackgroundColor:[UIColor clearColor]];
    [self.xbbNavigationBar addSubview:titleCityButton];
    [titleCityButton addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleCityButton setTitle:@"成都" forState:UIControlStateNormal];
    
    UIImage *rightImage = [UIImage imageNamed:@"xbb_location"];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width - rightImage.size.width-20., 32-rightImage.size.height/2+10, rightImage.size.width, rightImage.size.height)];
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.xbbNavigationBar addSubview:rightButton];
    
}


- (void)addBannerWithModels:(NSArray *)arr
{
    banner= [[XBBBannerView alloc] initWithFrame:CGRectMake(0,44, XBB_Screen_width, 200) imagesNames:arr];
    banner.xbbDelegate = self;
    [self.backgroundScrollView addSubview:banner];
}
- (void)removeBanner
{
    [banner.timer invalidate];
    banner.timer = nil;
    [banner removeFromSuperview];
    banner = nil;
    bannerArrayData = nil;
}

- (void)dealloc
{
    [self removeNotifaction];
}

#pragma mark versiondispose


- (NSString *)getVerisonString {
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    return appInfo[@"CFBundleShortVersionString"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark updateUser

//更新用户头像信息
- (void)updateUserSuccessfulIndex:(NSNotification *)sender{
    UserObj *userObj = [UserObj shareInstance];
    DLog(@"%@",userObj.uid);
    [leftNavigationBotton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, userObj.imgstring]] placeholderImage:[UIImage imageNamed:@"nav1"]];
}


#pragma mark 下单

- (void)addOrder
{
    if (IsLogin)
    {
        AddOrderViewController *diy = [[AddOrderViewController alloc] init];
        [self.navigationController pushViewController:diy animated:YES];
    }
    else
    {
        GoToLogin(self);
    }
}

#pragma mark action

- (IBAction)titleAction:(id)sender
{
    DLog(@"")
}
- (IBAction)leftButtonAction:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}

- (IBAction)rightButtonAction:(id)sender
{
     [self addOrder];
}



@end
