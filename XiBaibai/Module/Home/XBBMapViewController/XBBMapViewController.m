//
//  IndexViewController.m
//  XBB
//
//  Created by Daniel on 15/8/4.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "XBBMapViewController.h"
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
#import "AddOrderViewController.h"


@interface XBBMapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate,UIScrollViewDelegate,UIAlertViewDelegate,BMKOverlay ,BMKSuggestionSearchDelegate,UITextFieldDelegate,BMKPoiSearchDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    /**
     * @brief 百度地图相关信息
     * @detail 百度地图相关信息
     **/
    BMKUserLocation *bmlocation;  // 位置信息
    BOOL floag;
    BMKMapView *map; //百度地图
    BMKLocationService *_locService;
    BMKReverseGeoCodeOption *reverseGeoCodeOption;//初始化逆地理编码类
    BMKSuggestionSearch  *_suggestionSearch; // 建议搜索
    
    AppDelegate *mydelegate;//控制控件大小自适应
    
    UIImageView *add;//导航栏设置默认车辆按钮
    UILabel *labCar;//导航栏上得默认车辆
    UIImageView *img_view;//导航栏上得头像
    
    UIImageView *imgViewCurrent;

    BMKPoiSearch *search;
    BMKGeoCodeSearch *_geoCodeSearch;//地里编码
   
    UILabel *labNowLoaction;
    

    NSString *c_plate_num;//导航栏显示的车牌
    NSString *p_id;//得到产品id
    NSString *c_id;//默认车辆
    NSString *address_chose;//选择的地址
    NSString *location_lg;
    NSString *location_lt;
    NSString *total_price;
    
    UILabel *lab;
    UILabel *labHao;
    
    BOOL _alreadyCheckVersionUpdate;
    
    NSString *_downloadAppAddress;
    NSTimer *_checkVersionTimer;
    

    /**
     * @brief 与下单有关的选择项的成员变量
     * @detail 与下单有关的选择项的成员变量
     **/
    UIImageView *imgView_now; // 即刻上门
    UILabel *lab_now;
    UIImageView *imgView_yuyue; // 预约
    UILabel *lab_yuyue;
    UIView *viewxian; // 线
    UIButton *lab_prompt; // 提示
    
    
    
    BMKPolygon *polygon;  // 多形遮罩
//    UIView *_coverView; // 蒙板层
    
    
    UIView *markBackView;
    UIView *markBackControlView;
    UITextView    *textView;
    UIButton *cannelbutton;
    BOOL ismark;
    UILabel *markLabel;
    
    
    BOOL isSearch;
    UITextField  *searchField;
    UIView *seachBar;
    UITableView *searchTableView;
    UIImageView *searchImageView;
    UIButton *searchCannelButton;
    
    int  currentPage;
    
}

// 底部滚动条 背景
@property (strong, nonatomic) UIView *bottomBackgroundView, *selectedBackgroundView;
// 底部滚动条
@property (strong, nonatomic) UIScrollView *contentScl;

@property (nonatomic, strong) UIButton *presentAreabutton; // 选择显示隐藏服务区域（两个状态0：选择状态，1:不选择呈现服务区域）


@property (assign, nonatomic) int selectedIndex;
@property (copy, nonatomic)   NSString *cityName;

@property (nonatomic, copy) NSDictionary *dicCoordinates;

@property (nonatomic, copy) NSDictionary *defaultCarDic;

@property (nonatomic, copy) NSArray *searchArray;


@end

@implementation XBBMapViewController

- (void)hiddenSearchBar:(BOOL)isHidden
{
    
    if (isSearch) {
      
    }
    
    [UIView beginAnimations:@"hiddenSearchBar" context:nil];
    [UIView setAnimationDuration:0.3];
    
    if (isHidden) {
        searchTableView.alpha = 0;
        seachBar.frame = CGRectMake(20., 65+10, XBB_Screen_width - 40., 44.);
        self.xbbNavigationBar.alpha = 1.;
        searchImageView.userInteractionEnabled = NO;
         searchCannelButton.alpha = 0;
    
    }else
    {
        searchField.text = @"";
        self.searchArray = nil;
        [searchTableView reloadData];
        searchTableView.alpha = 0.7;
        CGRect frame = seachBar.frame;
        frame.origin.y = 20.;
        frame.origin.x = 0.;
        frame.size.width = XBB_Screen_width;
        
        CGRect frame_one = searchCannelButton.frame;
        frame_one.origin.x = XBB_Screen_width - 80.;
        searchCannelButton.frame = frame_one;
          searchCannelButton.alpha = 1;
        seachBar.frame = frame;
        self.xbbNavigationBar.alpha = 0.;
         searchImageView.userInteractionEnabled = YES;
    }
    [UIView setAnimationDelay:0.];
    [UIView commitAnimations];
    
}
- (IBAction)cannel:(id)sender
{
    [searchField resignFirstResponder];
    [self hiddenSearchBar:YES];
}

- (void)addAddressSeachBar
{
  
    seachBar = [[UIView alloc] initWithFrame:CGRectMake(20., 65+10, XBB_Screen_width - 40., 44.)];
    seachBar.layer.cornerRadius = 5.;
    seachBar.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    seachBar.layer.borderWidth = 0.5;
    seachBar.layer.masksToBounds = YES;
    seachBar.backgroundColor = [UIColor whiteColor];
    
    
    searchCannelButton = [[UIButton alloc] initWithFrame:CGRectMake(seachBar.bounds.size.width - 80, 0, 80, seachBar.bounds.size.height)];
    [searchCannelButton.titleLabel setFont:[UIFont systemFontOfSize:14.]];
    [searchCannelButton setTitle:@"取消" forState:UIControlStateNormal];
    [searchCannelButton setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
    [seachBar addSubview:searchCannelButton];
    [searchCannelButton addTarget:self action:@selector(cannel:) forControlEvents:UIControlEventTouchUpInside];
    searchCannelButton.alpha = 0;
    

    [self.view addSubview:seachBar];
    UIImage *seachImage = [UIImage imageNamed:@"搜索"];
    searchImageView= [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(seachBar.bounds)/2-seachImage.size.height/2, seachImage.size.width, seachImage.size.height)];
    searchImageView.image = seachImage;
    UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSeach:)];
    [searchImageView addGestureRecognizer:tap_1];
    
    [seachBar addSubview:searchImageView];
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(searchImageView.frame.origin.x+searchImageView.frame.size.width+10, 0, seachBar.bounds.size.width - (searchImageView.frame.origin.x+searchImageView.frame.size.width+10), 44.)];
    searchField.backgroundColor = [UIColor clearColor];
    searchField.font = [UIFont systemFontOfSize:13.];
    searchField.textColor = [UIColor grayColor];
    searchField.delegate = self;
    [seachBar addSubview:searchField];
    
    searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, XBB_Screen_width, XBB_Screen_height - 65)];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.userInteractionEnabled = YES;
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:searchTableView];
    searchTableView.alpha  = 0;
    [self hiddenSearchBar:YES];
}

- (void)hiddenMarkViews:(BOOL)hidden
{
    if (hidden) {
        [UIView animateWithDuration:0.25 animations:^{
            markBackView.alpha = 0;
            cannelbutton.transform = CGAffineTransformRotate(cannelbutton.transform, -M_PI);
            
        }];
        
    }else
    {
        [UIView animateWithDuration:0.25 animations:^{
            markBackView.alpha = 0.7;
            cannelbutton.transform = CGAffineTransformRotate(cannelbutton.transform, M_PI);
        }];
        
    }
}



#pragma mark NetAbserver
- (void)changeNetStatusHaveDisconnection
{
}
- (void)changeNetStatusHaveConnection
{
}
#pragma mark 区域展示
- (void)addPresentAreButtonCreate
{
    _presentAreabutton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, self.view.bounds.size.height - 100, 40, 40)];
    [_presentAreabutton setBackgroundImage:[UIImage imageNamed:@"xbb_801"] forState:UIControlStateNormal];
    [self.view addSubview:_presentAreabutton];
    _presentAreabutton.tag = 0; // 默认未选择状态
    [_presentAreabutton addTarget:self action:@selector(presentArea:) forControlEvents:UIControlEventTouchUpInside];
    
}
// 呈现区域事件
- (void)presentArea:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            _presentAreabutton.tag = 1;
            [_presentAreabutton setImage:[UIImage imageNamed:@"xbb_802"] forState:UIControlStateNormal];
            [self drawServerAreaLayerCover]; // 添加蒙板
        
        }
            break;
        case 1:
        {
            _presentAreabutton.tag = 0;
              [_presentAreabutton setImage:[UIImage imageNamed:@"xbb_801"] forState:UIControlStateNormal];
            [self removeServerAreaCover]; // 删除蒙板
            
        }
            break;
        default:
            break;
    }
}
// 添加服务区域蒙板
- (void)drawServerAreaLayerCover
{
    if (self.dicCoordinates) {
        NSArray *arr = [self.dicCoordinates allKeys];
        if ([arr count] > 0) {
            for (NSString *key in arr) {
                if ([key isEqualToString:@"circle"]) {
                    NSArray *circles = [self.dicCoordinates objectForKey:@"circle"];
                    for (NSDictionary *dic in circles) {
                        BMKCircle *circle = nil;
                        // 添加圆形覆盖物
                        if (circle == nil) {
                            CLLocationCoordinate2D coor;
                            coor.latitude = [[dic objectForKey:@"server_lat"] floatValue];
                            coor.longitude = [[dic objectForKey:@"server_lng"] floatValue];
                            circle = [BMKCircle circleWithCenterCoordinate:coor radius:[[dic objectForKey:@"radius"] doubleValue]];
                        }
                        [map addOverlay:circle];
                        
                    }
                    
                }else if ([key isEqualToString:@"muilt"]) {
                    // 获取到第一层字典
                    NSDictionary *dic = [self.dicCoordinates objectForKey:@"muilt"];
                    NSArray *arr = [dic allKeys]; // 获取到数据条数
                    for (NSString *key in arr) {
                        NSArray *coordinates = [dic objectForKey:key]; // 获取到数组
                        
                        int count = (int)[coordinates count];
                        if (count>7 || count<4) {
                            return;
                        }
                        switch (count) {
                            case 4:
                            {
                                BMKPolygon *pll = nil;
                                CLLocationCoordinate2D coors[4] = {0};
                                for (int i = 0; i < [coordinates count]; i ++) {
                                    coors[i].latitude = [[(NSDictionary *)coordinates[i] objectForKey:@"server_lat"] floatValue];
                                    coors[i].longitude = [[(NSDictionary *)coordinates[i] objectForKey:@"server_lng"] floatValue];
                                }
                                pll = [BMKPolygon polygonWithCoordinates:coors count:4];
                                [map addOverlay:pll];
                                
                            }
                                break;
                                
                            case 5:
                            {
                                BMKPolygon *pll = nil;
                                CLLocationCoordinate2D coors[5] = {0};
                                for (int i = 0; i < [coordinates count]; i ++) {
                                    coors[i].latitude = [[(NSDictionary *)coordinates[i] objectForKey:@"server_lat"] floatValue];
                                    coors[i].longitude = [[(NSDictionary *)coordinates[i] objectForKey:@"server_lng"] floatValue];
                                }
                                pll = [BMKPolygon polygonWithCoordinates:coors count:5];
                                [map addOverlay:pll];
                            }
                                break;
                                
                            case 6:
                            {
                                BMKPolygon *pll = nil;
                                CLLocationCoordinate2D coors[6] = {0};
                                for (int i = 0; i < [coordinates count]; i ++) {
                                    coors[i].latitude = [[(NSDictionary *)coordinates[i] objectForKey:@"server_lat"] floatValue];
                                    coors[i].longitude = [[(NSDictionary *)coordinates[i] objectForKey:@"server_lng"] floatValue];
                                }
                                pll = [BMKPolygon polygonWithCoordinates:coors count:6];
                                [map addOverlay:pll];
                            }
                                break;
                                
                                
                            case 7:
                            {
                                BMKPolygon *pll = nil;
                                CLLocationCoordinate2D coors[7] = {0};
                                for (int i = 0; i < [coordinates count]; i ++) {
                                    coors[i].latitude = [[(NSDictionary *)coordinates[i] objectForKey:@"server_lat"] floatValue];
                                    coors[i].longitude = [[(NSDictionary *)coordinates[i] objectForKey:@"server_lng"] floatValue];
                                }
                                pll = [BMKPolygon polygonWithCoordinates:coors count:7];
                                [map addOverlay:pll];
                            }
                                break;
                                
                                
                            default:
                                break;
                        }
                    }
                }
            }
            
        }
    }
}
// 删除蒙板区域
- (void)removeServerAreaCover
{
    [map removeOverlays:[map overlays]];
}



#pragma mark view


- (void)tempViewControllerPushFunction
{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(200, 300, 50, 50)];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
  
}
- (void)toPush:(BOOL)isServerTime
{

    AddOrderViewController *diy = [[AddOrderViewController alloc] init];
    [self.navigationController pushViewController:diy animated:YES];
}



- (void)setNavigationBarControl
{
    self.showNavigation = YES;
    UIImage *leftImage = [UIImage imageNamed:@"back_xbb"];
    if (XBB_IsIphone6_6s) {
        leftImage = [UIImage imageNamed:@"back_xbb6"];
    }
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.userInteractionEnabled = YES;
    [backButton addTarget:self action:@selector(backViewController:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:leftImage forState:UIControlStateNormal];
    [self.xbbNavigationBar addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.centerY.mas_equalTo(self.xbbNavigationBar).mas_offset(9.f);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *titelLabel = [[UILabel alloc] init];
    [titelLabel setTextColor:[UIColor whiteColor]];
    [titelLabel setBackgroundColor:[UIColor clearColor]];
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"地图"];
    [titelLabel setFont:XBB_NavBar_Font];
    [titelLabel setTextAlignment:NSTextAlignmentCenter];
    [self.xbbNavigationBar addSubview:titelLabel];
    [titelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30.);
        make.centerY.mas_equalTo(self.xbbNavigationBar).mas_offset(10.f);
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(XBB_Screen_width-100);
    }];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width - 55., 28, 50, 30)];
    if (self.isHomeControllerto) {
        [rightButton setTitle:@"下单" forState:UIControlStateNormal];
    }else
    {
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14.]];
    [self.xbbNavigationBar addSubview:rightButton];
    [rightButton addTarget:self action:@selector(sureCommit:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark view disposed
//- (void)featchAableArea
//{
//    [NetworkHelper postWithAPI:Lat_Long parameter:nil successBlock:^(id response) {
//        DLog(@"%@",response);
//        if (response) {
//            NSDictionary *dic = [(NSDictionary*)response objectForKey:@"result"];
//            self.dicCoordinates = dic;
//        }
//        
//    } failBlock:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"获取可服务区域失败"];
//    }];
//
//}

- (void)initData
{
//    [self featchAableArea];
    [UserObj shareInstance].currentAddressDetail = @"";
}
- (void)initAll
{
    bmlocation = [[BMKUserLocation alloc] init];  // 百度地图位置
    [self initSearch]; // 初始化搜索
}


- (void)initUI
{
    [self initMapView];
    [self setNavigationBarControl];
    [self initView];
//    [self addPresentAreButtonCreate]; // 添加区域button
    [self initMylocationView]; // 初始化我的位置视图
    [self addAddressSeachBar];
    [self addMarkView];
   
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initData];
    [self initAll];
    [self initUI];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self initData];
}

- (void)keyboardWillShow
{
    if (ismark) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = markBackControlView.frame;
            
            if (XBB_IsIphone4s) {
                frame.origin.y = -60;
                cannelbutton.transform = CGAffineTransformRotate(cannelbutton.transform,M_PI);
            }
            else
            {
                frame.origin.y = -100;
                cannelbutton.transform = CGAffineTransformRotate(cannelbutton.transform, M_PI);
            }
            
            markBackControlView.frame = frame;
        }];
    }
    if (isSearch) {
        [self hiddenSearchBar:NO];
    }
}
- (void)keyboardWillHide
{
    if (ismark) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = markBackControlView.frame;
            frame.origin.y = 0.;
            cannelbutton.transform = CGAffineTransformRotate(cannelbutton.transform,-M_PI);
            markBackControlView.frame = frame;
        }];
        
    }
    if (isSearch) {
        [self hiddenSearchBar:YES];
        isSearch = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
//    [self.navigationController.navigationBar setHidden:NO];
    
    
    [map viewWillAppear];
    map.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate=self;
    if (![self.view.subviews containsObject:map]) {
        [self.view addSubview:map];
        [self.view sendSubviewToBack:map];
    }
    search.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [map viewWillDisappear];
    map.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _suggestionSearch.delegate = nil;
    search.delegate = nil;
    
    
}


- (void)initView{
    

    //左边快速定位
    UIView *locationView=[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.view.bounds)-180, 50, 140)];
    
    if (self.isHomeControllerto) {
        /**
         * @brief 家庭住址
         **/
        UIButton *homeLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        homeLocationBtn.frame = CGRectMake(0, 0, 30, 30);
        [homeLocationBtn setImage:[UIImage imageNamed:@"xbb_808"] forState:UIControlStateNormal];
        [homeLocationBtn addTarget:self action:@selector(moveToHomeLocation) forControlEvents:UIControlEventTouchUpInside];
        [locationView addSubview:homeLocationBtn];
        
        
        /**
         * @brief 公司地址按钮
         **/
        UIButton *companyLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        companyLocationBtn.frame = CGRectMake(0, 45, 30, 30);
        [companyLocationBtn setImage:[UIImage imageNamed:@"xbb_807"] forState:UIControlStateNormal];
        [companyLocationBtn addTarget:self action:@selector(moveToCompanyLocation) forControlEvents:UIControlEventTouchUpInside];
        [locationView addSubview:companyLocationBtn];
    }
   
    
    /**
     * @brief 当前位置按钮
     **/
    UIButton *currentLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    currentLocationBtn.frame = CGRectMake(0, 90, 30, 30);
    [currentLocationBtn setImage:[UIImage imageNamed:@"map_fast_3"] forState:UIControlStateNormal];
    [currentLocationBtn addTarget:self action:@selector(here) forControlEvents:UIControlEventTouchUpInside];
    [locationView addSubview:currentLocationBtn];
    [self.view addSubview:locationView];
    [self.view bringSubviewToFront:locationView];
}




#pragma mark MKMap
/**
 * @brief 检索
 * @detail 检索
 **/
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray *arr = result.ptList;
    for (NSValue *st in arr) {
    }
    
}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        circleView.lineWidth = 1.0;
        return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.lineWidth = 5.0;
        
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        
//        polygonView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        polygonView.lineWidth =1.0;
        polygonView.lineDash = (overlay == polygon);
        return polygonView;
    }
    if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
        return groundView;
    }
    if ([overlay isKindOfClass:[BMKArcline class]]) {
        BMKArclineView *arclineView = [[BMKArclineView alloc] initWithArcline:overlay];
        arclineView.strokeColor = [UIColor blueColor];
        arclineView.lineDash = YES;
        arclineView.lineWidth = 6.0;
        return arclineView;
    }
    return nil;
}

- (void)initMapView{
    map= [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))]; // 初始化地图
    map.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toucheMap:)];
    [map addGestureRecognizer:tap];
    map.baiduHeatMapEnabled = NO;
    map.zoomLevel=18; // 设置地图比例
    map.delegate=self; // 地图代理
    map.showsUserLocation=YES; // 显示定位图层
    
    [BMKLocationService setLocationDesiredAccuracy:0.5];
    [BMKLocationService setLocationDistanceFilter:1];

    _locService = [[BMKLocationService alloc]init]; // 初始化BMKLocationService
    _locService.delegate = self;
    
    //启动LocationService
    [_locService startUserLocationService];
    [self.view addSubview:map];
    
    
    //初始化逆地理编码类
    reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    
    
    _suggestionSearch = [[BMKSuggestionSearch alloc] init];
    _suggestionSearch.delegate = self;
}

- (void)initSearch{
    //注意：必须初始化地理编码类
    _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    search = [[BMKPoiSearch alloc] init];
    search.delegate = self;
}

#pragma mark 开通城市


- (BOOL)hasOpenServerCityWithCityName:(NSString *)nameString
{
    NSArray *arr = @[@"成都市",@"重庆市"];
    for (NSString *name in arr)
        if ([name isEqualToString:nameString]) return YES;
    return NO;
}
- (void)setWindStyleWithopenCity:(BOOL)isopenCity
{
    if (isopenCity)
    {
        [UIView animateWithDuration:0.25 animations:^{
            imgView_now.alpha = 1;
            lab_now.alpha = 1;
            imgView_yuyue.alpha = 1;
            lab_yuyue.alpha = 1;
            //        viewxian.alpha = 1;
            lab_prompt.alpha = 0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            imgView_now.alpha = 0;
            lab_now.alpha = 0;
            imgView_yuyue.alpha = 0;
            lab_yuyue.alpha = 0;
            //        viewxian.alpha = 0;
            lab_prompt.alpha = 1;
            [lab_prompt setTitle:@"点击申请开通此城市" forState:UIControlStateNormal];
            lab_prompt.userInteractionEnabled = YES;
            
        }];
    }
}



- (void)initMylocationView{

    imgViewCurrent=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"泡泡"]];
    [self.view addSubview:imgViewCurrent];
    [imgViewCurrent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(map);
        make.centerY.mas_equalTo(map).mas_offset(-60.);
        make.width.mas_equalTo(XBB_Screen_width-160.);
        make.height.mas_equalTo(120.);
        
    }];
    
    UIButton *labMylocation = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, XBB_Screen_width-160, 20)];
    [labMylocation.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [labMylocation setTitle:@"选择位置" forState:UIControlStateNormal];
    [labMylocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [labMylocation.titleLabel setFont:[UIFont systemFontOfSize:16]];
    labMylocation.userInteractionEnabled = YES;
//    [labMylocation addTarget:self action:@selector(toPOISerch:) forControlEvents:UIControlEventTouchUpInside];
    [imgViewCurrent addSubview:labMylocation];
    labNowLoaction = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, XBB_Screen_width-169, 40)];
    labNowLoaction.textAlignment=NSTextAlignmentCenter;
    [labNowLoaction setTextColor:[UIColor lightGrayColor]];
    labNowLoaction.font =[UIFont systemFontOfSize:14.0];
    labNowLoaction.numberOfLines = 2;
    
    [self.view bringSubviewToFront:imgViewCurrent];
    [imgViewCurrent addSubview:labNowLoaction];
    
    imgViewCurrent.userInteractionEnabled = YES;
    

    UIImage *maekButtonimage = [UIImage imageNamed:@"备注"];
    UIButton *markButton = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width - 160 - 10 - maekButtonimage.size.width , labNowLoaction.frame.origin.y+labNowLoaction.frame.size.height +5, maekButtonimage.size.width, maekButtonimage.size.height)];
    
//    markButton.backgroundColor = [UIColor blackColor];
    [markButton setBackgroundImage:maekButtonimage forState:UIControlStateNormal];
    [markButton setTitle:@"备注" forState:UIControlStateNormal];
    [markButton.titleLabel setFont:[UIFont systemFontOfSize:12.]];
    [markButton addTarget:self action:@selector(markAction:) forControlEvents:UIControlEventTouchUpInside];
    [imgViewCurrent addSubview:markButton];
    
    markLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, markButton.frame.origin.y, XBB_Screen_width-174-markButton.frame.size.width, markButton.frame.size.height)];
    markLabel.font = [UIFont systemFontOfSize:14.0];
    markLabel.textColor = [UIColor lightGrayColor];
    [markLabel setTextAlignment:NSTextAlignmentCenter];
    [imgViewCurrent addSubview:markLabel];
    
    imgViewCurrent.alpha = 0;
    
}



#pragma mark datas

- (void)initViewWillAppearDatas
{
    if (([[UserObj shareInstance] homeAddress].length== 0 ||[[UserObj shareInstance] homeAddress]==nil) && ([[UserObj shareInstance] companyAddress].length== 0||[[UserObj shareInstance] companyAddress]==nil)) {
        [self fetchAddressFromWeb:nil];
    }
}

- (void)fetchAddressFromWeb:(void (^)())callback {
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:API_AddressSelect parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            NSArray *result = response[@"result"][@"list"];
            for (NSDictionary *temp in result) {
                if ([temp[@"address_type"] integerValue] == 0) {
                    [UserObj shareInstance].homeAddress = temp[@"address"];                    [UserObj shareInstance].homeDetailAddress = temp[@"address_info"];
                    [UserObj shareInstance].homeCoordinate = CLLocationCoordinate2DMake([temp[@"address_lt"] doubleValue], [temp[@"address_lg"] doubleValue]);
                } else if ([temp[@"address_type"] integerValue] == 1) {
                    
                    
                    [UserObj shareInstance].companyAddress = temp[@"address"];
                    [UserObj shareInstance].companyDetailAddress = temp[@"address_info"];
                    [UserObj shareInstance].companyCoordinate = CLLocationCoordinate2DMake([temp[@"address_lt"] doubleValue], [temp[@"address_lg"] doubleValue]);
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}



//- (void)initData{
//    NSUserDefaults *isLogin = [NSUserDefaults standardUserDefaults];
//    NSString *userid = [isLogin objectForKey:@"userid"];
//    [UserObj shareInstance].uid = userid;
//    if (IsLogin) {
//        //请求个人头像
//        NSMutableDictionary *dicMine=[NSMutableDictionary dictionary];
//        [dicMine setObject:[UserObj shareInstance].uid forKey:@"uid"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginFailed object:nil];
//        [NetworkHelper postWithAPI:Select_user_API parameter:dicMine successBlock:^(id response) {
//            if ([response[@"code"] integerValue] == 1) {
//                UserObj *user=[UserObj shareInstance];
//                user.ads_id=[[response objectForKey:@"result"] objectForKey:@"ads_id"];
//                user.age=[[response objectForKey:@"result"] objectForKey:@"age"] ;
//                user.c_id=[[response objectForKey:@"result"] objectForKey:@"c_id"] ;
//                user.email=[[response objectForKey:@"result"] objectForKey:@"email"];
//                user.iphone=[[response objectForKey:@"result"] objectForKey:@"iphone"];
//                user.profession=[[response objectForKey:@"result"] objectForKey:@"profession"];
//                user.QQ=[[response objectForKey:@"result"] objectForKey:@"qq"];
//                user.imgstring=[[response objectForKey:@"result"] objectForKey:@"u_img"];
//                user.sex=[[response objectForKey:@"result"] objectForKey:@"sex"];
//                user.uid=[[response objectForKey:@"result"] objectForKey:@"uid"];
//                user.uname=[[response objectForKey:@"result"] objectForKey:@"uname"];
//                user.weixin=[[response objectForKey:@"result"] objectForKey:@"weixin"];
//                user.imgstring = [[response objectForKey:@"result"] objectForKey:@"u_img"];
//                //                [BPush setTag:user.uid withCompleteHandler:^(id result, NSError *error) {
//                //                }];
//                NSString *channelId = [BPush getChannelId];
//                if (channelId)
//                    [NetworkHelper postWithAPI:API_ChannelIdInsert parameter:@{@"uid": user.uid, @"channelid": channelId} successBlock:^(id response) {
//                        if ([response[@"code"] integerValue] == 1) {
//                            NSLog(@"channelid设置成功");
//                        } else {
//                            NSLog(@"channelid设置失败");
//                        }
//                    } failBlock:^(NSError *error) {
//                        NSLog(@"channelid设置失败");
//                    }];
//                //                NSString *channelId = [BPush getChannelId];
//                //                [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
//                //                }];
//                if ([[[response objectForKey:@"result"] objectForKey:@"u_img"] isKindOfClass:[NSNull class]]) {
//                    img_view.image=[UIImage imageNamed:@"nav1.png"];
//                }else{
//                    [img_view sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain,[[response objectForKey:@"result"] objectForKey:@"u_img"]]] placeholderImage:[UIImage imageNamed:@"nav1"]];
//                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccessful object:nil];
//                [self fetchAddressFromWeb:nil];
//            } else {
//                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginFailed object:nil];
//            }
//        } failBlock:^(NSError *error) {
//            //            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginFailed object:nil];
//        }];
//        
//        //请求默认车辆
//        NSMutableDictionary *dicCar=[NSMutableDictionary dictionary];
//        [dicCar setValue:[UserObj shareInstance].uid forKey:@"uid"];
//        [NetworkHelper postWithAPI:car_select parameter:dicCar successBlock:^(id response) {
//            NSLog(@"车辆dics%@",response);
//            if ([response[@"code"] integerValue] == 1) {
//                NSDictionary *result=[response objectForKey:@"result"];
//                NSString *default_id=[result objectForKey:@"default"];
//                NSArray *arrCar=[result objectForKey:@"list"];
//                if (arrCar.count == 0) {
//                    labCar.frame = CGRectMake(8, 10, 100, 13);
//                    add.hidden = NO;
//                    labCar.text = @"默认车辆";
//                }else
//                {
//                    for (NSDictionary *dic in arrCar) {
//                        if ([default_id isEqualToString:[dic objectForKey:@"id"]]) {
//                            
//                            self.defaultCarDic = dic;
//                            labCar.text=[dic objectForKey:@"c_plate_num"];
//                            add.hidden=YES;
//                            labCar.center = CGPointMake(labCar.superview.frame.size.width * 0.5, labCar.center.y);
//                        }
//                    }
//                }
//            } else {
//                labCar.frame = CGRectMake(8, 10, 100, 13);
//                add.hidden = NO;
//                labCar.text = @"默认车辆";
//            }
//        } failBlock:^(NSError *error) {
//            
//        }];
//        
//    }else{
//        labCar.text = @"默认车辆";
//        img_view.image=[UIImage imageNamed:@"nav1.png"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginFailed object:nil];
//    }
//}




- (void)checkVerison {
    [NetworkHelper postWithAPI:API_VersionUpdate parameter:@{@"version_type": @"2"} successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            NSString *currentVersionStr = [self getVerisonString];
            NSString *serverVersionStr = response[@"result"][@"versionname"];
            _downloadAppAddress = response[@"result"][@"downloadaddress"];
            if ([currentVersionStr compare:serverVersionStr] == NSOrderedAscending) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"检测到新版本“%@”，请更新版本！", serverVersionStr] delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"更新", nil];
                alert.tag = 99;
                [alert show];
            }
            [_checkVersionTimer invalidate];
        }
    } failBlock:^(NSError *error) {
        
    }];
}

- (NSString *)getVerisonString {
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    return appInfo[@"CFBundleShortVersionString"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//更新用户头像信息
- (void)updateUserSuccessfulIndex:(NSNotification *)sender{
    UserObj *userInfo = [UserObj shareInstance];
    [img_view sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, userInfo.imgstring]] placeholderImage:[UIImage imageNamed:@"nav1"]];
   
}

//添加默认车辆
- (void)addcar{
    if (IsLogin){
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyCarTableViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

//
//#pragma mark 即刻上门
////即刻上门
//- (void)addOrderNow{
//    if (IsLogin)
//    {
//        // 定位失败
//        if (!location_lg || !location_lt) {
//            [SVProgressHUD showErrorWithStatus:@"定位失败"];
//            return;
//        }
//        // 设置默认车辆
//        UserObj *user=[UserObj shareInstance];
//        if ([user.c_id integerValue]== 0 ||[user.c_id integerValue] == 1 ) {
//            UIAlertView *alert = [CustamViewController createAlertViewTitleStr:@"请设置默认车辆" withMsg:nil widthDelegate:self withCancelBtn:@"取消" withbtns:@"去设置"];
//            [alert show];
//            return;
//        }
//        
//        [self toPush:NO]; // 下单
//    }
//    else
//    {
//        GoToLogin(self);
//    }
//}

#pragma 没有订单或者车辆时alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 99) {
        if (buttonIndex) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadAppAddress]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                exit(0);
            });
        } else {
            exit(0);
        }
        return;
    }
    if ([alertView.title isEqualToString:@"请设置默认车辆"]) {
        if (buttonIndex == 1) {
            MyCarTableViewController *carTableVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyCarTableViewController"];
            [self.navigationController pushViewController:carTableVC animated:YES];
        }
    }
    
    if ([alertView.title isEqualToString:@"设置车辆"]) {
        if (buttonIndex == 1) {
            MyCarTableViewController *myCar = [[MyCarTableViewController alloc] init];
            [self.navigationController pushViewController:myCar animated:YES];
        }
    }
    
}



#pragma mark 设置定位

- (void)here {
    if (bmlocation.location.coordinate.latitude == 0) {
        [SVProgressHUD showErrorWithStatus:@"请检查您的定位设置"];
        return;
    }
    [map setCenterCoordinate:bmlocation.location.coordinate animated:YES];
}

- (void)moveToHomeLocation {

        map.userTrackingMode = BMKUserTrackingModeNone;
        [map setCenterCoordinate:[UserObj shareInstance].homeCoordinate animated:YES];
    
}

- (void)moveToCompanyLocation {

        map.userTrackingMode = BMKUserTrackingModeNone;
        [map setCenterCoordinate:[UserObj shareInstance].companyCoordinate animated:YES];
    
}

/**
 * @brief 处理位置坐标更新
 * @pram
 **/
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
    bmlocation=userLocation;
    [map updateLocationData:userLocation];
    [UserObj shareInstance].currentCoordinate = userLocation.location.coordinate;
    [map setCenterCoordinate:userLocation.location.coordinate animated:YES];
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    DLog(@"%@",result.address)
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    self.cityName = result.addressDetail.city;
    /**
     * @brief 设置开通城市
     * @detail 设置开通城市
     **/
    [self setWindStyleWithopenCity:[self hasOpenServerCityWithCityName:self.cityName]];
    labNowLoaction.text=result.address;
    if (imgViewCurrent.alpha < 1) {
        [UIView beginAnimations:@"imageAlpha" context:nil];
        [UIView setAnimationDuration:0.25];
        imgViewCurrent.alpha = 1.;
        [UIView commitAnimations];
    }
    
    address_chose=result.address;
    [UserObj shareInstance].currentAddress = result.address;
    location_lg = [NSString stringWithFormat:@"%lf",result.location.longitude];
    location_lt = [NSString stringWithFormat:@"%lf",result.location.latitude];
}

/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
//    myLocationView.hidden=YES;
//     imgViewCurrent.hidden = YES;
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    //需要逆地理编码的坐标位置
    reverseGeoCodeOption.reverseGeoPoint = [map convertPoint:imgViewCurrent.center toCoordinateFromView:map];
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
}


#pragma mark textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    isSearch = YES;
    [self hiddenSearchBar:NO];
    
    return YES;
}
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    self.searchArray = poiResult.poiInfoList;
    [searchTableView reloadData];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *string_one = [textField.text stringByReplacingCharactersInRange:range withString:string];

     self.searchArray = nil;
    BMKCitySearchOption *op = [[BMKCitySearchOption alloc] init];
    op.pageIndex = 0;
    op.pageCapacity = 10;
    op.keyword = string_one;
    op.city = self.cityName;
    BOOL flag =  [search poiSearchInCity:op];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
    return YES;
}



#pragma mark action

- (IBAction)toSeach:(id)sender
{
    self.searchArray = nil;
    BMKCitySearchOption *op = [[BMKCitySearchOption alloc] init];
    op.pageIndex = 0;
    op.pageCapacity = 10;
    op.keyword = searchField.text;
    op.city = self.cityName;
    BOOL flag =  [search poiSearchInCity:op];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}





- (IBAction)backViewController:(id)sender{
    if ([self.superController isEqualToString:@"XBBAddressSelectViewController"]) {
        self.selectAddress(NO);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)sureCommit:(id)sender
{
    
    
    if (IsLogin)
    {
        if ([[UserObj shareInstance] carModel] != nil) {
            DLog(@"")
            if ([self.superController isEqualToString:@"XBBAddressSelectViewController"]) {
                self.selectAddress(YES);
                [self.navigationController popViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else
            {
                AddOrderViewController *order = [[AddOrderViewController alloc] init];
                order.hasLocation = YES;
                [self.navigationController pushViewController:order animated:YES];
            }
            

        }else
        {
            UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"设置车辆" message:@"您还没有设置默认车辆哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alrt show];
            return;
        }
    }
    
    
    //
  }




#pragma mark Mark

- (void)addMarkView
{
    markBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XBB_Screen_width, XBB_Screen_height)];
    markBackView.backgroundColor = [UIColor blackColor];
    markBackView.alpha = 0.8;
    [self.view addSubview:markBackView];
    
    
    
    markBackControlView = [[UIView alloc] initWithFrame:markBackView.bounds];
    [markBackView addSubview:markBackControlView];
    textView = [[UITextView alloc] initWithFrame:CGRectMake(20., XBB_Screen_height - 400., XBB_Screen_width-40., 200.)];
    
    textView.layer.cornerRadius = 5;
    [textView setFont:[UIFont systemFontOfSize:15.]];
    textView.layer.masksToBounds = YES;
    [markBackControlView addSubview:textView];
    
    UIImage *buttonImage = [UIImage imageNamed:@"X"];
    cannelbutton = [[UIButton alloc] initWithFrame:CGRectMake(textView.frame.size.width + textView.frame.origin.x -30.-buttonImage.size.width, textView.frame.origin.y - buttonImage.size.height/2, buttonImage.size.width, buttonImage.size.height)];
    [cannelbutton setImage:buttonImage forState:UIControlStateNormal];
    [cannelbutton addTarget:self action:@selector(toClose) forControlEvents:UIControlEventTouchUpInside];
    [markBackControlView addSubview:cannelbutton];
    
    UIImage *image = [UIImage imageNamed:@"确定"];
    UIButton *markButton = [[UIButton alloc] initWithFrame:CGRectMake(20., XBB_Screen_height - 150., XBB_Screen_width-40., 44.)];
    [markButton setTitle:@"提交" forState:UIControlStateNormal];
    [markButton addTarget:self action:@selector(smitMark) forControlEvents:UIControlEventTouchUpInside];
    [markButton setBackgroundImage:image forState:UIControlStateNormal];
    [markBackControlView addSubview:markButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMarkControl:)];
    [markBackControlView addGestureRecognizer:tap];
    markBackView.alpha = 0;
    [self hiddenMarkViews:YES];
    
}

- (IBAction)toucheMap:(id)sender
{
    ismark = NO;
    [textView resignFirstResponder];
    [searchField resignFirstResponder];
}

- (void)toClose
{
    ismark = NO;
    [textView resignFirstResponder];
    [self hiddenMarkViews:YES];
}
- (void)smitMark
{
    ismark = NO;
    [textView resignFirstResponder];
    markLabel.text = textView.text;
    [UserObj shareInstance].currentAddressDetail = textView.text;
    [self hiddenMarkViews:YES];
}


- (IBAction)tapMarkControl:(id)sender
{
    [textView resignFirstResponder];
    [searchField resignFirstResponder];
}

- (IBAction)markAction:(id)sender
{
    ismark = YES;
    [textView becomeFirstResponder];
    textView.text = [UserObj shareInstance].currentAddressDetail;
    [self hiddenMarkViews:NO];
}



#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    BMKPoiInfo *info = self.searchArray[indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    cell.textLabel.text = info.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BMKPoiInfo *info = self.searchArray[indexPath.row];
    map.userTrackingMode = BMKUserTrackingModeNone;
    [map setCenterCoordinate:info.pt animated:YES];
    [self hiddenSearchBar:YES];
    [searchField resignFirstResponder];
    
}







///**
// * @brief 选择左边按钮
// * @detail 选择左边按钮打开左抽屉视图
// **/
//- (void)clickLeftButton{
//
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//
//    }];
//}



//
//- (IBAction)toTouchAppleButton:(id)sender
//{
//    if (self.haveConnection == NO) {
//        [SVProgressHUD showErrorWithStatus:@"检查您的网络啊"];
//    }
//    if ([address_chose length]==0 || [location_lg length] == 0 || [location_lt length]==0) {
//        return;
//    }
//    [NetworkHelper postWithAPI:Applyopen parameter:@{@"uid":[UserObj shareInstance].uid,@"address":address_chose,@"latitude":location_lt,@"longitude":location_lg} successBlock:^(id response) {
//        if (response) {
//            NSDictionary *dicResponse = response;
//            switch ([dicResponse[@"code"] integerValue]) {
//                case 1:
//                {
//                    [SVProgressHUD showSuccessWithStatus:dicResponse[@"msg"]];
//                    [lab_prompt setTitle:@"已收到您的申请" forState:UIControlStateNormal];
//                    lab_prompt.userInteractionEnabled = NO;
//                }
//                    break;
//
//                default:
//                {
//                    [SVProgressHUD showErrorWithStatus:dicResponse[@"msg"]];
//                }
//                    break;
//            }
//        }
//    } failBlock:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络错误"];
//    }];
//}


@end
