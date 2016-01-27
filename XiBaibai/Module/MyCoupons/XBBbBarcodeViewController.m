//
//  XBBbBarcodeViewController.m
//  XiBaibai
//
//  Created by xbb01 on 16/1/14.
//  Copyright © 2016年 Mingle. All rights reserved.
//

#import "XBBbBarcodeViewController.h"
#import "MyCouponsViewController.h"
#import "UserObj.h"
@interface XBBbBarcodeViewController ()<UITextFieldDelegate>
{
    UILabel *titleLabel;
    UITextField   *inputTextField;
    UIButton      *changeButton;
    UIButton      *sureButton;
}


@end

@implementation XBBbBarcodeViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    [self sureButtonAction:nil];
    
    return YES;
}

- (IBAction)backViewController:(id)sender
{
    NSArray * viewControllers = self.navigationController.viewControllers;
    for (id viewController in viewControllers) {
        if ([viewController isKindOfClass:[MyCouponsViewController class]]) {
               [self.navigationController popToViewController:viewController animated:YES];
        }
    }
 
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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"优惠码"];
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
    [self setNavigationBarControl];
    [self initUI];
    
}


- (void)initUI
{
    self.view.backgroundColor = XBB_Bg_Color;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XBB_Screen_width-40, 30.)];
    [self.view addSubview:titleLabel];
    [titleLabel setFont:[UIFont systemFontOfSize:14.]];
    titleLabel.text = @"请输入优惠码";
    inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, XBB_Screen_width-40., 44.)];
    [self.view addSubview:inputTextField];
    inputTextField.returnKeyType = UIReturnKeyDone;
    inputTextField.delegate = self;
    [inputTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    changeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (XBB_Screen_width-40)/2-10, 44.)];
    [self.view addSubview:changeButton];
    sureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (XBB_Screen_width-40)/2-10, 44.)];
    [self.view addSubview:sureButton];
    
    [titleLabel setCenter:CGPointMake(XBB_Screen_width/2, 65 + titleLabel.frame.size.height/2+5)];
    [inputTextField setCenter:CGPointMake(XBB_Screen_width/2, titleLabel.center.y+titleLabel.frame.size.height/2+inputTextField.frame.size.height/2+5)];
    [changeButton setCenter:CGPointMake(20+(XBB_Screen_width-40)/4, inputTextField.center.y+inputTextField.frame.size.height/4  + changeButton.frame.size.height/2+50)];
    [sureButton setCenter:CGPointMake(20+(XBB_Screen_width-40)/4*3, changeButton.center.y)];
    
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.layer.cornerRadius = 2;
    changeButton.layer.cornerRadius = 2.;
    sureButton.layer.cornerRadius = 2.;
    
    [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [changeButton setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
    
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setTitleColor:XBB_NavBar_Color forState:UIControlStateHighlighted];
    
    [changeButton setTitle:@"切换扫码" forState:UIControlStateNormal];
    
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [changeButton addTarget:self action:@selector(changeButtonActin:) forControlEvents:UIControlEventTouchUpInside];
    [sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [changeButton setBackgroundColor:[UIColor whiteColor]];
    [sureButton setBackgroundColor:XBB_NavBar_Color];
    
}
#pragma mark action
- (IBAction)changeButtonActin:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureButtonAction:(id)sender
{
    [inputTextField resignFirstResponder];
    NSDate *nowDate = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[nowDate timeIntervalSince1970]];
    NSString *stringURL = [NSString stringWithFormat:@"exchangecode=%@&timeline=%@&uid=%@cap123",inputTextField.text,timeSp,[[UserObj shareInstance] uid]];
    NSString *ne =  [stringURL md5];
    DLog(@"%@",CouponCode)
    
    [NetworkHelper postWithAPI:CouponCode parameter:@{@"exchangecode":inputTextField.text,@"uid":[[UserObj shareInstance] uid],@"sign":ne,@"timeline":timeSp} successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self backViewController:nil];
            });
        }else
        {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error description]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
