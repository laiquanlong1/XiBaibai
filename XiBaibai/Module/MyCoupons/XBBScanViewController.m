//
//  XBBScanViewController.m
//  XiBaibai
//
//  Created by xbb01 on 16/1/14.
//  Copyright © 2016年 Mingle. All rights reserved.
//

#import "XBBScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XBBbBarcodeViewController.h"
#import "UserObj.h"

@interface XBBScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *capturetureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (nonatomic, strong) UIImageView *captureImageView;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIView      *scanPanView;
@property (nonatomic, strong) NSTimer     *timer;

@property (nonatomic, strong) UILabel *promtLabel;

@property (nonatomic, strong) UIButton *inputCodeButton;


@end

@implementation XBBScanViewController



#pragma mark back

- (IBAction)backViewController:(id)sender
{
    [self.timer invalidate];
    [_capturetureSession stopRunning];
    [self.navigationController popViewControllerAnimated:YES];
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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"二维码/优惠券"];
    [titelLabel setFont:XBB_NavBar_Font];
    [titelLabel setTextAlignment:NSTextAlignmentCenter];
    [self.xbbNavigationBar addSubview:titelLabel];
    [titelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30.);
        make.centerY.mas_equalTo(self.xbbNavigationBar).mas_offset(10.f);
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(XBB_Screen_width-100);
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:112./255 green:112/255. blue:112./255. alpha:1];
    [self setNavigationBarControl];
    _capturetureSession = nil;
    [self initViewS];

    // Do any additional setup after loading the view.
}


- (BOOL)initViewS
{
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        DLog(@"%@",[error debugDescription])
        return NO;
    }
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    _capturetureSession = [[AVCaptureSession alloc] init];
    [_capturetureSession addInput:input];
    [_capturetureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_capturetureSession];
    [_captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.scanPanView = [[UIView alloc] initWithFrame:CGRectMake(XBB_Screen_width/4, XBB_Screen_height/10+64, XBB_Screen_width/4*2, XBB_Screen_width/4*2)];
    
    
    self.captureImageView = [[UIImageView alloc] initWithFrame:self.scanPanView.bounds];
     [_captureVideoPreviewLayer setFrame:self.view.bounds];
    [self.view.layer addSublayer:_captureVideoPreviewLayer];
    [self.view addSubview:self.scanPanView];
    [self.scanPanView addSubview:self.captureImageView];
    self.captureImageView.image = [UIImage imageNamed:@"扫描框"];
    [captureMetadataOutput setRectOfInterest:CGRectMake((124)/XBB_Screen_height,((ScreenWidth-220)/2)/ScreenWidth,220/XBB_Screen_height,220/ScreenWidth)];
    
    UIImage *image = [UIImage imageNamed:@"扫描条"];
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.scanPanView.bounds.size.width, image.size.height)];
    self.lineImageView.image = image;
    [self.scanPanView addSubview:self.lineImageView];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(lineFreme:) userInfo:nil repeats:YES];
    self.scanPanView.layer.masksToBounds = YES;
    
    self.promtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.scanPanView.frame.origin.y+self.scanPanView.frame.size.height+10, XBB_Screen_width, 30.)];
    [self.view addSubview:self.promtLabel];
    self.promtLabel.text = @"将二维码/条码放入框内，即可自动扫描";
    self.promtLabel.textColor = [UIColor whiteColor];
    [self.promtLabel setTextAlignment:NSTextAlignmentCenter];
    [self.promtLabel setFont:[UIFont systemFontOfSize:14.]];
    
    UIImage *imagebutton = [UIImage imageNamed:@"切换扫码"];
    self.inputCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imagebutton.size.width, imagebutton.size.height)];
    
    [self.inputCodeButton setImage:imagebutton forState:UIControlStateNormal];
    [self.view addSubview:self.inputCodeButton];
    [self.inputCodeButton setTitle:@"切换输入优惠码" forState:UIControlStateNormal];
    [self.inputCodeButton setCenter:CGPointMake(XBB_Screen_width/2, self.promtLabel.frame.origin.y+self.promtLabel.frame.size.height + 30)];
    [self.inputCodeButton setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
    [self.inputCodeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-imagebutton.size.width, 0, 0)];
    
    [self.inputCodeButton addTarget:self action:@selector(toBarCodeViewController:) forControlEvents:UIControlEventTouchUpInside];

    [self.view bringSubviewToFront:self.xbbNavigationBar];
    [_capturetureSession startRunning];
    
    return YES;
}

- (IBAction)toBarCodeViewController:(id)sender
{
    XBBbBarcodeViewController *bar = [[XBBbBarcodeViewController alloc] init];
    [self.navigationController pushViewController:bar animated:YES];
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDate *nowDate = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[nowDate timeIntervalSince1970]];
            NSString *stringURL = [NSString stringWithFormat:@"channel=ios&timeline=%@&uid=%@&url=%@cap123",timeSp,[[UserObj shareInstance] uid],metadataObj.stringValue];
            NSString *ne =  [stringURL md5];
            [NetworkHelper postWithAPI:ZbarPtoP parameter:@{@"sign":ne,@"channel":@"ios",@"timeline":timeSp,@"uid":[UserObj shareInstance].uid,@"url":metadataObj.stringValue} successBlock:^(id response) {
                if ([response[@"code"] integerValue] == 1) {
                    [self.timer invalidate];
                    [_capturetureSession stopRunning];
                    [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
               
            } failBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:[error description]];
            }];
        });
        
        
    }
}


- (IBAction)lineFreme:(id)sender
{
    CGRect frame = self.lineImageView.frame;
    if (frame.origin.y > self.scanPanView.bounds.size.height) {
        frame.origin.y = 0;
    }
    frame.origin.y += 1;
    self.lineImageView.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
