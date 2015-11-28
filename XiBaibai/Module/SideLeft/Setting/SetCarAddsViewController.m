//
//  SetCarAddsViewController.m
//  XBB
//
//  Created by mazi on 15/9/4.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "SetCarAddsViewController.h"
#import <BaiduMapAPI/BMKMapView.h>
#include "UserObj.h"

@interface SetCarAddsViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    BMKMapView *mapset;
    UIImageView *imgViewCurrent;
//    BMKLocationService *_locService;
    BMKUserLocation *bmlocation;
    BMKPoiSearch *search;
    BMKGeoCodeSearch *_geoCodeSearch;//地里编码
    UIView *myLocationView;//当前位置显示
    UILabel *labNowLoaction;
    //初始化逆地理编码类
    BMKReverseGeoCodeOption *reverseGeoCodeOption;

    NSString *address_chose;//选择的地址
    NSString *location_lg;
    NSString *location_lt;
}

@property (strong, nonatomic) BMKLocationService *locService;

@end

@implementation SetCarAddsViewController

- (void)initMapView{
    mapset= [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    mapset.zoomLevel=17;
    mapset.delegate=self;
//    mapset.rotateEnabled=NO;
//    mapset.buildingsEnabled=YES;
//    mapset.userTrackingMode=BMKUserTrackingModeNone;
//    mapset.showsUserLocation=NO;
    mapset.showsUserLocation = YES;
    mapset.userTrackingMode=BMKUserTrackingModeFollow;
//    //设置定位精确度，默认：kCLLocationAccuracyBest
//    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
//    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
//    [BMKLocationService setLocationDistanceFilter:100.f];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
//    _locService = [MapHelper locationService];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
//    mapset = [MapHelper mapView];
    [self.view addSubview:mapset];
    
    //初始化逆地理编码类
    reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
}

- (void)initSearch{
    search = [[BMKPoiSearch alloc] init];
    
    //初始化地理编码类
    //注意：必须初始化地理编码类
    _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
}
- (void)initView{
    self.view.backgroundColor = kUIColorFromRGB(0xf6f5fa);
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"设置地址";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    title.font = [UIFont boldSystemFontOfSize:20];
//    self.navigationItem.titleView = title;
    self.title = @"设置地址";
    //返回
    UIImageView * img_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_back.png"]];
    img_view.layer.masksToBounds=YES;
    img_view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fanhui)];
    [img_view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:img_view];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(okAdds)];
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xFFFFFF);
    //左边快速定位
    UIView *locationView=[[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.view.bounds)-190, 50, 150)];
    //  locationView.backgroundColor=[UIColor blueColor];
    
//    UIImageView *imgView_home=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 40, 40)];
//    imgView_home.image=[UIImage imageNamed:@"map_fast_1.png"];
//    [locationView addSubview:imgView_home];
//    
//    UIImageView *imgView_comp=[[UIImageView alloc] initWithFrame:CGRectMake(0, 55, 40, 40)];
//    imgView_comp.image=[UIImage imageNamed:@"map_fast_2.png"];
//    [locationView addSubview:imgView_comp];
    
    UIImageView *imgView_here=[[UIImageView alloc] initWithFrame:CGRectMake(0, 105, 40, 40)];
    imgView_here.image=[UIImage imageNamed:@"map_fast_3.png"];
    imgView_here.userInteractionEnabled=YES;
    UITapGestureRecognizer *here_tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(here)];
    [imgView_here addGestureRecognizer:here_tap];
    [locationView addSubview:imgView_here];
    
    [self.view addSubview:locationView];

}
- (void)initMylocationView{
    myLocationView=[[UIView alloc] init];
    myLocationView.backgroundColor=kUIColorFromRGB(0xFFFFFF);
    [myLocationView.layer setMasksToBounds:YES];
    [myLocationView.layer setCornerRadius:10.0];
    [self.view addSubview:myLocationView];
    
    imgViewCurrent=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mark"]];
    //    imgViewCurrent.frame=CGRectMake(187.5, 333.5, 22, 34);
    //    imgViewCurrent.image=[UIImage imageNamed:@"mark.png"];
    [self.view addSubview:imgViewCurrent];
    [imgViewCurrent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(mapset);
    }];


    
//    UILabel *labMylocation=[[UILabel alloc] initWithFrame:CGRectMake(80, 15, 100, 20)];
//    labMylocation.textAlignment=NSTextAlignmentCenter;
//    labMylocation.text=@"我的位置  >";
//    [myLocationView addSubview:labMylocation];
    
    labNowLoaction = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 260, 20)];
    labNowLoaction.textAlignment=NSTextAlignmentCenter;
    [labNowLoaction setTextColor:[UIColor lightGrayColor]];
    labNowLoaction.font =[UIFont systemFontOfSize:14];
    labNowLoaction.numberOfLines = 2;
    [myLocationView addSubview:labNowLoaction];
    [labNowLoaction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self.view bringSubviewToFront:imgViewCurrent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initMapView];
    [self initSearch];
    [self initView];
    [self initMylocationView];
    [mapset setCenterCoordinate:_locService.userLocation.location.coordinate animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mapset viewWillAppear];
    mapset.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate=self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"释放");
    [super viewWillDisappear:animated];
    [mapset viewWillDisappear];
    mapset.delegate = nil; // 不用时，置nil
    _locService.delegate=nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)okAdds{
    if (!address_chose || !location_lg || !location_lt) {
        [SVProgressHUD showErrorWithStatus:@"暂未获取到您的位置信息"];
        return;
    }
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:AddUser_address_API parameter:@{@"uid":[UserObj shareInstance].uid,
                                                               @"address":address_chose,
                                                               @"address_lg":location_lg,
                                                               @"address_lt":location_lt,
                                                               @"address_type":[NSString stringWithFormat:@"%ld",self.num]}
                  successBlock:^(id response) {
                      if ([response[@"code"] integerValue] == 1) {
                          [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                              [self.delegate setNowLocation:address_chose withNum:self.num];
                              [self.navigationController popViewControllerAnimated:YES];
                          });
                      } else {
                          [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                      }
                  } failBlock:^(NSError *error) {
                      [SVProgressHUD showErrorWithStatus:@"添加失败"];
                  }];
    
}

- (void)here{
    [_locService startUserLocationService];
    [mapset setCenterCoordinate:_locService.userLocation.location.coordinate animated:YES];
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"%@", error);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    bmlocation=userLocation;
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [mapset updateLocationData:userLocation];
}


/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"地址编码结果    %@",result.address);
    labNowLoaction.text=result.address;
    address_chose=result.address;
    location_lg = [NSString stringWithFormat:@"%lf",result.location.longitude];
    location_lt = [NSString stringWithFormat:@"%lf",result.location.latitude];
}

/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    myLocationView.hidden=YES;
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    myLocationView.hidden=NO;
    //将大头针坐标转化为地理坐标
    CGPoint point=[mapset convertCoordinate:mapset.centerCoordinate toPointToView:mapset];
    [myLocationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(260, 70));
        make.left.mas_equalTo(point.x - 130);
        make.top.mas_equalTo(point.y - 90);
    }];
    // - (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view;
    //[map convertPoint:imgViewCurrent.center toCoordinateFromView:map];
    //需要逆地理编码的坐标位置
    reverseGeoCodeOption.reverseGeoPoint = [mapset convertPoint:imgViewCurrent.center toCoordinateFromView:mapset];
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
