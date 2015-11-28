//
//  PersonLocationViewController.m
//  XBB
//
//  Created by Apple on 15/9/18.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "PersonLocationViewController.h"
#import "XBBAnnotation.h"

@interface PersonLocationViewController () <BMKLocationServiceDelegate, BMKMapViewDelegate> {
    BOOL _isCenter;
}

@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) BMKLocationService *locationService;

@end

@implementation PersonLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.title = @"工作人员位置";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1@icon_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(backOnTouch)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.mapView.zoomLevel = 17;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    self.locationService = [[BMKLocationService alloc] init];
    self.locationService.delegate = self;
    [self.locationService startUserLocationService];
    
    XBBAnnotation *anno = [[XBBAnnotation alloc] init];
    anno.coordinate = self.coordinate;
    anno.title = self.emp_name;
    anno.subtitle = self.emp_num;
    [self.mapView addAnnotation:anno];
    [self.mapView setCenterCoordinate:anno.coordinate animated:YES];
    [self.mapView selectAnnotation:anno animated:YES];
}

- (void)backOnTouch {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    if (_isCenter == NO) {
        [self.mapView updateLocationData:userLocation];
        _isCenter = YES;
        [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    BMKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
    if (!view) {
        view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
        view.image = [UIImage imageNamed:@"xbb_150"];
    }
    return view;
}


@end
