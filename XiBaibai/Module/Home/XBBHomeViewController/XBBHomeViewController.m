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
#import "XBBMapViewController.h"



@interface XBBHomeViewController ()<XBBBannerViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIView         *headView;
    UIImageView    *leftNavigationBotton;
    UIButton       *titleCityButton;
    XBBBannerView  *banner;
    NSArray        *bannerArrayData;
    
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XBBHomeViewController


#pragma mark featchData
- (void)feachDatas
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
    });
}


- (void)initData{
    NSUserDefaults *isLogin = [NSUserDefaults standardUserDefaults];
    NSString *userid = [isLogin objectForKey:@"userid"];
    [UserObj shareInstance].uid = userid;
    if (IsLogin) {
        //请求个人头像
        NSMutableDictionary *dicMine=[NSMutableDictionary dictionary];
        [dicMine setObject:[UserObj shareInstance].uid forKey:@"uid"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginFailed object:nil];
        [NetworkHelper postWithAPI:Select_user_API parameter:dicMine successBlock:^(id response) {
            if ([response[@"code"] integerValue] == 1) {
                UserObj *user=[UserObj shareInstance];
                user.ads_id=[[response objectForKey:@"result"] objectForKey:@"ads_id"];
                user.age=[[response objectForKey:@"result"] objectForKey:@"age"] ;
                user.c_id=[[response objectForKey:@"result"] objectForKey:@"c_id"] ;
                user.email=[[response objectForKey:@"result"] objectForKey:@"email"];
                user.iphone=[[response objectForKey:@"result"] objectForKey:@"iphone"];
                user.profession=[[response objectForKey:@"result"] objectForKey:@"profession"];
                user.QQ=[[response objectForKey:@"result"] objectForKey:@"qq"];
                user.imgstring=[[response objectForKey:@"result"] objectForKey:@"u_img"];
                user.sex=[[response objectForKey:@"result"] objectForKey:@"sex"];
                user.uid=[[response objectForKey:@"result"] objectForKey:@"uid"];
                user.uname=[[response objectForKey:@"result"] objectForKey:@"uname"];
                user.weixin=[[response objectForKey:@"result"] objectForKey:@"weixin"];
                user.imgstring = [[response objectForKey:@"result"] objectForKey:@"u_img"];
                //                [BPush setTag:user.uid withCompleteHandler:^(id result, NSError *error) {
                //                }];
                NSString *channelId = [BPush getChannelId];
                if (channelId)
                    [NetworkHelper postWithAPI:API_ChannelIdInsert parameter:@{@"uid": user.uid, @"channelid": channelId} successBlock:^(id response) {
                        if ([response[@"code"] integerValue] == 1) {
                            NSLog(@"channelid设置成功");
                        } else {
                            NSLog(@"channelid设置失败");
                        }
                    } failBlock:^(NSError *error) {
                        NSLog(@"channelid设置失败");
                    }];
                if ([[[response objectForKey:@"result"] objectForKey:@"u_img"] isKindOfClass:[NSNull class]]) {
                    leftNavigationBotton.image=[UIImage imageNamed:@"nav1.png"];
                }else{
                    [leftNavigationBotton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain,[[response objectForKey:@"result"] objectForKey:@"u_img"]]] placeholderImage:[UIImage imageNamed:@"nav1"]];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccessful object:nil];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginFailed object:nil];
            }
        } failBlock:^(NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginFailed object:nil];
        }];
 
    }else{

        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginFailed object:nil];
    }
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
   DLog(@"")
}
- (void)changeNetStatusHaveConnection
{
   DLog(@"")
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
    [self addTableViewHomes];
    [self feachDatas];
    [self initUI];
    [self addNotification];
 
    
}
- (void)addTableViewHomes
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XBB_Screen_width, XBB_Screen_height-64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 198.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    headView = [[UIView alloc] init];
    headView.backgroundColor = XBB_Bg_Color;
    
    UIImage *image = [UIImage imageNamed:@"xbb_twoBai"];
   
    UIImage *buttonImage = [UIImage imageNamed:@"xbb_One_Button"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    button.center = CGPointMake(XBB_Screen_width/2, XBB_Size_w_h(346.));
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(button.bounds.size.width - image.size.width-XBB_Size_w_h(10), -image.size.height+button.bounds.size.height+XBB_Size_w_h(5), image.size.width, image.size.height)];
    imageV.image = image;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"一键洗车" forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addSubview:imageV];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [headView addSubview:button];
    [button addTarget:self action:@selector(toAddDownOrder:) forControlEvents:UIControlEventTouchUpInside];
    [headView bringSubviewToFront:button];
    return headView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
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
        [self initData];
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
    if (banner != nil) {
        [banner removeFromSuperview];
        banner = nil;
    }
    banner = [[XBBBannerView alloc] initWithFrame:CGRectMake(0,0, XBB_Screen_width, XBB_Size_w_h(300.)) imagesNames:arr];
    banner.xbbDelegate = self;
    [headView insertSubview:banner atIndex:0];
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
    UserObj *userInfo = [UserObj shareInstance];
    [leftNavigationBotton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, userInfo.imgstring]] placeholderImage:[UIImage imageNamed:@"nav1"]];
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
- (IBAction)toAddDownOrder:(id)sender
{
     [self addOrder];
}
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
    
    XBBMapViewController *map = [[XBBMapViewController alloc] init];
    map.navigationTitle = @"地图";
        [self presentViewController:map animated:YES completion:nil];
//    [self.navigationController pushViewController:map animated:YES];
    return;
    
}



@end
