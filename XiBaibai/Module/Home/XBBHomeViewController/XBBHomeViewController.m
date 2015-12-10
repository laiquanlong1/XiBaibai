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
#import "XBBHomeFacialTableViewCell.h"
#import "XBBHomeFacialOneTableViewCell.h"
#import "XBBProObject.h"

static NSString *identifier_facial = @"facial_cell";
static NSString *identifier_diy = @"diy";

@interface XBBHomeViewController ()<XBBBannerViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIView         *headView;
    UIImageView    *leftNavigationBotton;
    UIButton       *titleCityButton;
    XBBBannerView  *banner;
    NSArray        *bannerArrayData;
    UILabel        *areaFirstTitileLabel;
    UILabel        *areaLastTitleLabel;
    
    
    
    
    UILabel        *inSpaNameLabel;
    UILabel        *inSpaPriceLabel;
    UILabel        *oilNameLabel;
    UILabel        *oilPriceLabel;
    
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) NSArray *proArray;
@end

@implementation XBBHomeViewController


#pragma mark featchData

- (void)feachFacialDatas
{
    [NetworkHelper postWithAPI:XBB_Facial_Pro parameter:nil successBlock:^(id response) {
        DLog(@"%@",response)
        if ([response[@"code"] integerValue] == 1) {
            NSArray *resultArray = response[@"result"];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *resultDic in resultArray) {
                XBBProObject *object = [[XBBProObject alloc] init];
                object.p_wash_free = [resultDic[@"p_wash_free"] integerValue];
                object.urlString = resultDic[@"detailurl"];
                object.p_id = resultDic[@"id"];
                object.p_name = resultDic[@"p_name"];
                object.price_1 = [resultDic[@"p_price"] floatValue];
                object.price_2 = [resultDic[@"p_price2"]floatValue];
                object.sort = [resultDic[@"sort"]integerValue];
                [arr addObject:object];
            }
            self.proArray = arr;
            [self alphaToOne];
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取美容信息网络错误"];
    }];
}


- (void)feachProDatas
{
    [NetworkHelper postWithAPI:XBB_Index_Pro parameter:nil successBlock:^(id response) {
        if (response == nil) {
            return ;
        }
        
        if ([response[@"code"] integerValue] == 1) {
        
            NSMutableArray *arr = [NSMutableArray array];
            NSArray *proArray = response[@"result"];
            for (NSDictionary *proDic in proArray) {
                XBBProObject *object = [[XBBProObject alloc] init];
                object.p_id = proDic[@"id"];
                object.p_name = proDic[@"p_name"];
                object.p_info = proDic[@"p_info"];
                object.price_1 = [proDic[@"p_price"] floatValue];
                object.price_2 = [proDic[@"p_price2"] floatValue];
                object.imageURL = proDic[@"thumb_url"];
                object.urlString = proDic[@"detailurl"];
                [arr addObject:object];
            }
            self.dataSource = arr;
//            [self.tableView reloadData];
            [self feachFacialDatas];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
        DLog(@"%@",response);
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"产品信息获取失败"];
    }];
}

- (void)feachDatas
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self feachProDatas];
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
                
                
                
                [NetworkHelper postWithAPI:XBB_Car_select parameter:@{@"uid":[UserObj shareInstance].uid} successBlock:^(id response) {
                    if ([response[@"code"] integerValue] == 1) {
                        NSArray *resultArray = response[@"result"];
                        for (NSDictionary *carDic in resultArray) {
                            if ([carDic[@"default"] integerValue] == 1) {
                                [UserObj shareInstance].c_id = carDic[@"id"];
                            }
                        }
                    }else
                    {
                        [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                    }
                    
                    
                    DLog(@"%@",response)
                } failBlock:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"获取车辆信息失败"];
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
    
    
//    if (banner == nil) {
//        [self feachBannerData];
//    }
//    if (self.dataSource == nil) {
//        [self feachDatas];
//    }
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

- (void)alphaToZone
{
    self.tableView.alpha = 0.;
}

- (void)alphaToOne
{
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.alpha = 1.;
    }];
    
}

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
    self.tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBHomeFacialTableViewCell" bundle:nil] forCellReuseIdentifier:identifier_diy];
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBHomeFacialOneTableViewCell" bundle:nil] forCellReuseIdentifier:identifier_facial];
    self.tableView.alpha = 0;
    [self alphaToZone];
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
//    [self alphaToOne];
}
- (void)removeBanner
{
    [banner.timer invalidate];
    banner.timer = nil;
    [banner removeFromSuperview];
    banner = nil;
    bannerArrayData = nil;
}


#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
           return 243.;
        }
            break;
        case 1:
        {
            return 43.;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return 200.;
        }
            break;
        case 1:
        {
            return 135.;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
        {
            if (headView) {
                return headView;
            }
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
            
            UIView *backGou = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height+button.frame.origin.y+10., XBB_Screen_width, 210.-(button.frame.size.height+button.frame.origin.y+10.))];
            backGou.backgroundColor = [UIColor colorWithRed:241./255. green:242/255. blue:243/255. alpha:1.];
            [headView addSubview:backGou];
            UIImage *linImage = [UIImage imageNamed:@"xbb_line_index"];
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,button.frame.size.height+button.frame.origin.y+20., XBB_Screen_width, linImage.size.height)];
            lineImageView.image = linImage;
            [headView addSubview:lineImageView];
            
            
            areaFirstTitileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height+button.frame.origin.y+20., XBB_Screen_width, 40.)];
            areaFirstTitileLabel.backgroundColor = XBB_Bg_Color;
            [headView addSubview:areaFirstTitileLabel];
            
            [areaFirstTitileLabel setFont:[UIFont systemFontOfSize:15.]];
            areaFirstTitileLabel.text = @"      深度美容";
            [areaFirstTitileLabel setTextColor:XBB_NavBar_Color];
            
            return headView;

        }
            break;
        case 1:
        {
            
            UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XBB_Screen_width, 44.)];
            back.backgroundColor = [UIColor colorWithRed:241./255. green:242/255. blue:243/255. alpha:1.];
            areaLastTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0., XBB_Screen_width, 40.)];
            NSString *format = @"      DIY组合    需要选择洗车哦";
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:format];
            [string addAttributes:@{NSForegroundColorAttributeName:XBB_NavBar_Color,NSFontAttributeName:[UIFont systemFontOfSize:15.]} range:NSMakeRange(0, [format length]-9)];
            [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.],NSForegroundColorAttributeName:XBB_NavBar_Color} range:NSMakeRange([format length]-9,9)];
            areaLastTitleLabel.attributedText = string;
            areaLastTitleLabel.backgroundColor = [UIColor whiteColor];
            [back addSubview:areaLastTitleLabel];
            
            return back;
        }
            break;
            
        default:
            break;
    }
    return nil;
  }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return self.dataSource.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
- (IBAction)inSPAButtonAction:(id)sender
{
    UIButton *button = sender;
    XBBProObject *object = self.proArray[button.tag];
    object.type = 2;
    WebViewController *web = [[WebViewController alloc] init];
    web.urlString = object.urlString;
    web.navigationTitle = object.p_name;
    web.proObject = object;
    [self.navigationController pushViewController:web animated:YES];
//    [self presentViewController:web animated:YES completion:nil];

    DLog(@"%ld",button.tag)
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            
            XBBHomeFacialOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_facial];
            if (cell == nil) {
                cell = [[XBBHomeFacialOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_diy];
            }
            
            for (int i = 0;i < self.proArray.count;i ++) {
                XBBProObject *object = self.proArray[i];
                switch (object.sort) {
                    case 1:
                    {
                        cell.inSPAButton.tag = i;
                        cell.inSPANameLabel.text = object.p_name;
                        NSString *string =[NSString stringWithFormat:@"%.2f 起",object.price_1];
                        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:string];
                        [attrS addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.]} range:NSMakeRange([string length]-1, 1)];
                        cell.inSPAPriceLabel.attributedText = attrS;
                    }
                        break;
                    case 2:
                    {
                        NSString *string =[NSString stringWithFormat:@"%.2f 起",object.price_1];
                        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:string];
                        [attrS addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.]} range:NSMakeRange([string length]-1, 1)];
                        cell.crystalOilPriceLabel.attributedText = attrS;
                        cell.crysalButton.tag = i;
                        cell.crystalOilNameLabel.text = object.p_name;
                    }
                        break;
                    case 3:
                    {
                        cell.engineButton.tag = i;
                        cell.engineNameLabel.text = object.p_name;
                        NSString *string =[NSString stringWithFormat:@"%.2f 起",object.price_1];
                        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:string];
                        [attrS addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.]} range:NSMakeRange([string length]-1, 1)];
                        cell.enginePriceLabel.attributedText = attrS;

                    }
                        break;
                    case 4:
                    {
                        cell.cuirButton.tag = i;
                        cell.cuirNameLabel.text = object.p_name;
                        NSString *string =[NSString stringWithFormat:@"%.2f 起",object.price_1];
                        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:string];
                        [attrS addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.]} range:NSMakeRange([string length]-1, 1)];
                        cell.cuirPriceLabel.attributedText = attrS;

                    }
                        break;
                    case 5:
                    {
                        cell.naturalButton.tag = i;
                        cell.naturalNameLabel.text = object.p_name;
                        NSString *string =[NSString stringWithFormat:@"%.2f 起",object.price_1];
                        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:string];
                        [attrS addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.]} range:NSMakeRange([string length]-1, 1)];
                        
                        cell.naturalPriceLabel.attributedText = attrS;

                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
          
  
            
            [cell.inSPAButton addTarget:self action:@selector(inSPAButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.crysalButton addTarget:self action:@selector(inSPAButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.naturalButton addTarget:self action:@selector(inSPAButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.engineButton addTarget:self action:@selector(inSPAButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.cuirButton addTarget:self action:@selector(inSPAButtonAction:) forControlEvents:UIControlEventTouchUpInside];

            return cell;
        }
            break;
        case 1:
        {
            XBBHomeFacialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_diy];
            if (cell == nil) {
                cell = [[XBBHomeFacialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_diy];
            }
            XBBProObject *object = self.dataSource[indexPath.row];
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",ImgDomain,object.imageURL]] placeholderImage:nil];
            cell.pInfoLabel.text = object.p_info;
            cell.pNameLabel.text = object.p_name;
            cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",object.price_1];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        XBBProObject *object = self.dataSource[indexPath.row];
        object.type = 1;
        WebViewController *web = [[WebViewController alloc] init];
        web.navigationTitle = object.p_name;
        web.urlString = object.urlString;
        web.proObject = object;
         [self.navigationController pushViewController:web animated:YES];
//        [self presentViewController:web animated:YES completion:nil];
    }
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
        diy.navigationTitle = @"一键洗车";
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
//        [self presentViewController:map animated:YES completion:nil];
    [self.navigationController pushViewController:map animated:YES];
    return;
    
}



@end
