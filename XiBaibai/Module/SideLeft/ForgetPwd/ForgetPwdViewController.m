//
//  ForgetPwdViewController.m
//  XiBaibai
//
//  Created by mazi on 15/9/22.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "ForgetPwdViewController.h"

@interface ForgetPwdViewController ()<UITextFieldDelegate>{
    NSString *respone_code;
    UIScrollView  *_controlScrollView; // 控件层
    UIButton *registerButton;
    BOOL isTimer; //是否在倒计时
    
}

@property (strong, nonatomic) UITextField *txtPhone;
@property (strong, nonatomic) UITextField *txtCode;
@property (strong, nonatomic) UITextField *txtPWD;
@property (strong, nonatomic) UITextField *txtPWDOK;
@property (strong, nonatomic) UIButton *btnsendCode;



@end

@implementation ForgetPwdViewController

#pragma mark dataDispose

- (void)initData
{
    isTimer = NO;
}


#pragma mark ViewDispose

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUIs];
}


- (void)setUpUIs
{
    
    [self setNavigationBarControl];
    [self setUpControlLayer];
    [self.view bringSubviewToFront:self.xbbNavigationBar];
    if (XBB_IsIphone4s) {
        _controlScrollView.contentSize = CGSizeMake(0, 540);
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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"忘记密码"];
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

- (void)setUpControlLayer
{
    
    _controlScrollView = [[UIScrollView alloc] init];
    _controlScrollView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:_controlScrollView belowSubview:self.xbbNavigationBar];
    [_controlScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(XBB_Screen_width);
        make.height.mas_equalTo(XBB_Screen_height);
        make.center.mas_equalTo(self.view);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptoloseFristResponse:)];
    [_controlScrollView addGestureRecognizer:tap];
    [self setUpControlui];
    
}

- (void)setUpControlui
{
    
    self.txtPhone = [self setUpUIWithView:self.xbbNavigationBar  plaorText:@"手机号" space:XBB_Size_w_h(180.f) imageName:@"xbb_register_phone"];
    self.txtPhone.keyboardType = UIKeyboardTypeNumberPad;
    self.txtCode = [self setUpUIWithView:self.txtPhone plaorText:@"验证码" space:XBB_Size_w_h(120.f) imageName:@"xbb_register_verify"];
    self.txtCode.clearButtonMode = UITextFieldViewModeNever;
    self.txtPWD = [self setUpUIWithView:self.txtCode plaorText:@"密码" space:XBB_Size_w_h(120.f) imageName:@"xbb_register_pwd"];
    self.txtPWDOK = [self setUpUIWithView:self.txtPWD plaorText:@"确认密码" space:XBB_Size_w_h(120.f) imageName:@"xbb_register_pwd"];
    [self.txtPWDOK setSecureTextEntry:YES];
    [self.txtPWD setSecureTextEntry:YES];
    self.txtPhone.delegate = self;
    self.txtCode.delegate = self;
    self.txtPWD.delegate = self;
    
    self.btnsendCode = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 30)];
    UIImage *ima = [UIImage imageNamed:@"xbb_code_register"];
    ima = [ima resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.btnsendCode setBackgroundImage:ima forState:UIControlStateNormal];
    [self.btnsendCode.titleLabel setFont:XBB_Prompt_Font];
    [self.btnsendCode setTitleColor:kUIColorFromRGB(0xc6c6c6) forState:UIControlStateNormal];
    [self.btnsendCode addTarget:self action:@selector(sendcode) forControlEvents:UIControlEventTouchUpInside];
    [self.btnsendCode setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_controlScrollView addSubview:self.btnsendCode];
    [self.btnsendCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.txtCode).mas_offset(-5.f);
        make.height.mas_equalTo(30.);
        make.right.mas_equalTo(self.txtCode.mas_right);
        if (XBB_IsIphone4s||XBB_IsIphone5_5s) {
            make.right.mas_equalTo(self.txtCode.mas_right).mas_offset(-15.);
        }
        if (XBB_IsIphone6_6s) {
            make.right.mas_equalTo(self.txtCode.mas_right).mas_offset(-8.);
        }
        
        make.width.mas_equalTo(140);
        
    }];
    
    self.txtCode.userInteractionEnabled = NO;
    self.txtPWD.userInteractionEnabled = NO;
    self.txtPWDOK.userInteractionEnabled = NO;
    
    registerButton= [[UIButton alloc] init];
    [registerButton setTitle:@"重置密码" forState:UIControlStateNormal];
    UIImage *loginNoselectImage = nil;
    if (XBB_IsIphone6_6s) {
        loginNoselectImage = [UIImage imageNamed:@"xbb_register_noSelect6"];
    }else
    {
        loginNoselectImage = [UIImage imageNamed:@"xbb_register_noSelect"];
    }
    loginNoselectImage = [loginNoselectImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    UIImage *imageLoginSelect = nil;
    if (XBB_IsIphone6_6s) {
        imageLoginSelect = [UIImage imageNamed:@"xbb_login_select6"];
        
    }else
    {
        imageLoginSelect = [UIImage imageNamed:@"xbb_login_select"];
        
    }
    imageLoginSelect = [imageLoginSelect resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [registerButton setBackgroundImage:loginNoselectImage forState:UIControlStateNormal];
    [registerButton setBackgroundImage:imageLoginSelect forState:UIControlStateHighlighted];
    [registerButton setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_controlScrollView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.txtPWDOK.mas_bottomMargin).mas_offset(60.);
        make.width.mas_equalTo(XBB_Screen_width-70.);
    }];
    [registerButton addTarget:self action:@selector(registerOK) forControlEvents:UIControlEventTouchUpInside];
}


- (UITextField *)setUpUIWithView:(UIView *)compareView  plaorText:(NSString *)placor space:(CGFloat)space imageName:(NSString *)imageName
{
    UIImage *underLineImage = nil;
    if (XBB_IsIphone6_6s) {
        underLineImage = [UIImage imageNamed:@"xbb_register_line6"];
    }else
    {
        underLineImage = [UIImage imageNamed:@"xbb_register_line"];
    }
    UIImageView *underLine = [[UIImageView alloc] initWithImage:underLineImage];
    [_controlScrollView addSubview:underLine];
    [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_controlScrollView);
        make.top.mas_equalTo(compareView.mas_bottomMargin).mas_offset(space);
        make.width.mas_equalTo(XBB_Screen_width-70.);
    }];
    
    UIImage *phoneIconImage = nil;
    if (XBB_IsIphone6_6s) {
        imageName = [NSString stringWithFormat:@"%@6",imageName];
    }
    phoneIconImage = [UIImage imageNamed:imageName];
    UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:phoneIconImage];
    [_controlScrollView addSubview:phoneIcon];
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(underLine).mas_offset(-(phoneIconImage.size.height+8));
        make.leading.mas_equalTo(underLine.mas_leading).mas_offset(5.f);
    }];
    
    UITextField *textFeild_one = [[UITextField alloc] init];
    textFeild_one.textColor = [UIColor blackColor];
    textFeild_one.keyboardAppearance = UIKeyboardAppearanceLight;
    [textFeild_one setFont:XBB_Prompt_Font];
    
    textFeild_one.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placor attributes:@{NSFontAttributeName:XBB_Prompt_Font, NSForegroundColorAttributeName:kUIColorFromRGB_alpha(0xdddddd,1.f)}];
    textFeild_one.keyboardType = UIKeyboardTypeASCIICapable;
    
    textFeild_one.clearButtonMode = UITextFieldViewModeAlways;
    textFeild_one.delegate = self;
    [_controlScrollView addSubview:textFeild_one];
    [textFeild_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25.).mas_offset(80.);
        make.centerY.mas_equalTo(phoneIcon).mas_offset(0);
        make.width.mas_equalTo(underLine.frame.size.width - 30. - 5.);
        make.height.mas_equalTo(44.);
    }];
    return textFeild_one;
}




#pragma mark actionDispose


- (IBAction)taptoloseFristResponse:(id)sender{
    if ([self.txtPWD isFirstResponder]) {
        [self.txtPWD resignFirstResponder];
    }
    if ([self.txtPhone isFirstResponder]) {
        [self.txtPhone resignFirstResponder];
    }
    if ([self.txtPWDOK isFirstResponder]) {
        
        [self.txtPWDOK resignFirstResponder];
    }
    if ([self.txtCode isFirstResponder]) {
        [self.txtCode resignFirstResponder];
    }
}


// 发送验证码
- (void)sendcode{
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:sendCode_API2 parameter:@{@"iphone":self.txtPhone.text} successBlock:^(id response) {
        
        self.txtCode.userInteractionEnabled = YES;
        self.txtPWD.userInteractionEnabled = YES;
        self.txtPWDOK.userInteractionEnabled = YES;
        [self.btnsendCode setTitleColor:kUIColorFromRGB(0xc6c6c6) forState:UIControlStateNormal];
        if([[response objectForKey:@"code"] integerValue]==3){
            [SVProgressHUD showInfoWithStatus:@"号码已注册"];
        }else if([[response objectForKey:@"code"] integerValue]==4){
            [SVProgressHUD showInfoWithStatus:@"您输入的不是手机号"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            respone_code = [[response objectForKey:@"result"] objectForKey:@"code"];
            NSLog(@"respone+++++%@",[[response objectForKey:@"result"] objectForKey:@"code"]);
            __block int timeout=59; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    isTimer = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.btnsendCode setTitle:@"发送验证码" forState:UIControlStateNormal];
                        [self.btnsendCode setTitleColor:kUIColorFromRGB(0x61b42c) forState:UIControlStateNormal];
                        isTimer = NO;
                        self.btnsendCode.userInteractionEnabled = YES;
                    });
                }else{
                    
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%d秒后重新获取", seconds];
                    isTimer = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        self.btnsendCode.userInteractionEnabled = NO;
                        [self.btnsendCode setTitle:strTime forState:UIControlStateNormal];
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    } failBlock:^(NSError *error) {
        isTimer = NO;
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
        [self.btnsendCode setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.btnsendCode.userInteractionEnabled = YES;
    }];
}

//    else
//    {
//        [SVProgressHUD showInfoWithStatus:@"手机号不正确"];
//    }


- (IBAction)backViewController:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerOK{
    [self.txtCode resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    [self.txtPWD resignFirstResponder];
    [self.txtPWDOK resignFirstResponder];
    [SVProgressHUD  show];
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|7[0-9]|8[0-9])\\d{8}$";

    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self.txtPhone.text] == YES)
        || ([regextestcm evaluateWithObject:self.txtPhone.text] == YES)
        || ([regextestct evaluateWithObject:self.txtPhone.text] == YES)
        || ([regextestcu evaluateWithObject:self.txtPhone.text] == YES))
    {
        
        if ([self.txtCode.text integerValue] ==[respone_code integerValue]) {
            if([self.txtPWD.text length]>=6){
                if([self.txtPWD.text isEqualToString:self.txtPWDOK.text]){
                    [NetworkHelper postWithAPI:Register_API2 parameter:@{@"iphone":self.txtPhone.text,@"pwd":self.txtPWD.text} successBlock:^(id response) {
                        
                        if([[response objectForKey:@"code"] integerValue]==3){
                            [SVProgressHUD showInfoWithStatus:@"号码已注册"];
                        }else{
                            [SVProgressHUD showSuccessWithStatus:@"重置密码成功"];
                            NSLog(@"respone register%@",response);
                            NSUserDefaults *isLogin = [NSUserDefaults standardUserDefaults];
                            [isLogin setObject:[[response objectForKey:@"result"] objectForKey:@"iphone"] forKey:@"iphone"];
                            [isLogin setObject:[[response objectForKey:@"result"] objectForKey:@"uid"] forKey:@"userid"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccessful object:nil];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                        
                    } failBlock:^(NSError *error) {
                        [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                }else{
                    [SVProgressHUD showInfoWithStatus:@"两次密码不一致"];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:@"密码长度不能小于六位"];
            }
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"验证码错误"];
        }
    }else{
        [SVProgressHUD showInfoWithStatus:@"手机号不正确"];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark textFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([textField isEqual:self.txtPhone]) {
        if (isTimer == NO) {
            
            
            if ([s length]>= 11) {
                [self.btnsendCode setTitleColor:kUIColorFromRGB(0x61b42c) forState:UIControlStateNormal];
            }else
            {
                [self.btnsendCode setTitleColor:kUIColorFromRGB(0xc6c6c6) forState:UIControlStateNormal];
            }
        }
        if ([s length]>11) {
            
            return NO;
        }
        
    }
    
    if ([textField isEqual:self.txtPWD]) {
        if ([s length]>16) {
            return NO;
        }
    }
    
    if ([textField isEqual:self.txtCode]) {
        if ([s length]>4) {
            return NO;
        }
    }
    
    if ([textField isEqual:self.txtPWDOK]) {
        if ([s length]>16) {
            return NO;
        }
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (XBB_IsIphone4s) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        if ([textField isEqual:self.txtPWD]) {
            _controlScrollView.contentOffset = CGPointMake(0, 60);
        }else if([textField isEqual:self.txtPWDOK]){
            _controlScrollView.contentOffset = CGPointMake(0, 80);
        }
        [UIView commitAnimations];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (XBB_IsIphone4s) {
        
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        _controlScrollView.contentOffset = CGPointMake(0, 0);
        [UIView commitAnimations];
    }
}
@end
