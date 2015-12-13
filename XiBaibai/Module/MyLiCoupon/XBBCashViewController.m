//
//  XBBCashViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/12/12.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBCashViewController.h"
#import "UserObj.h"

@interface XBBCashViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITextField *textFeild;
@end

@implementation XBBCashViewController
- (void)initUI
{
    self.sureButton.layer.cornerRadius = 5;
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.backgroundColor = XBB_NavBar_Color;

    [self setNavigationBarControl];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rerere:)]];
    [self initUI];
    
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)sure:(id)sender {
    [self.textFeild resignFirstResponder];
    
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:XBB_exchangeCoupons parameter:@{@"uid":[[UserObj shareInstance] uid],@"exchnum":self.textFeild.text?self.textFeild.text:@""} successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[@"code"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)rerere:(id)sender {
    [self.textFeild resignFirstResponder];
}

- (IBAction)guize:(id)sender {
    
}

- (void)backViewController:(id)sender
{
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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"banner"];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
