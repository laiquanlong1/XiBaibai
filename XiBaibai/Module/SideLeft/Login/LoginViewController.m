//
//  LoginViewController.m
//  XBB
//
//  Created by Daniel on 15/9/9.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPwdViewController.h"
#import "UserObj.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UIImageView   *_bgImageView;
    UIScrollView  *_controlScrollView; // 控件层
    UIImageView   *_iconsImageView; // 图标
    UITextField   *_selectField; //  选择的文本框
}

// 动画
@property(nonatomic,strong) NSTimer *animationTimer;

@property (strong,nonatomic) UITextField *txtLogin;
@property (strong,nonatomic) UITextField *txtPWD;

@end

@implementation LoginViewController

#pragma mark 视图展示区
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [self setUpUIS]; // 设置ui
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)setUpUIS
{
    [self setNavigation];
    [self setUpBgImageView];
    [self setUpControlLayer];
    [self startAnimation];
//    [self backButton];
}

- (void)setNavigation
{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)setUpBgImageView
{
    UIImage *bgimage = nil;
    if (XBB_IsIphone4s) {
        bgimage = [UIImage imageNamed:@"xbb_login_bg_4s"];
    }else if (XBB_IsIphone6_6s) {
        bgimage = [UIImage imageNamed:@"xbb_login_bg_6_6s"];
    }else {
        bgimage = [UIImage imageNamed:@"xbb_login_bg_5_5s"];
    }
    _bgImageView = [[UIImageView alloc] initWithImage:bgimage];
    [self.view addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(XBB_Screen_width);
        make.height.mas_equalTo(XBB_Screen_height);
        make.center.mas_equalTo(self.view);
    }];
}

- (void)setUpControlLayer
{
    _controlScrollView = [[UIScrollView alloc] init];
    _controlScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_controlScrollView];
    [_controlScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(XBB_Screen_width);
        make.height.mas_equalTo(XBB_Screen_height);
        make.center.mas_equalTo(self.view);
    }];
  
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptoloseFristResponse:)];
    [_controlScrollView addGestureRecognizer:tap];
    [self setUpIconsUI];
    [self setUpControlArea];
}

- (void)setUpIconsUI
{
    UIImage *_iconsImage =  nil;
    if (XBB_IsIphone6_6s) {
        _iconsImage = [UIImage imageNamed:@"xbb_login_icons_6_6s"];
    }else{
        _iconsImage = [UIImage imageNamed:@"xbb_login_icons_4_5"];
    }
    _iconsImageView = [[UIImageView alloc] initWithImage:_iconsImage];
    
    _iconsImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
    _iconsImageView.layer.shadowOpacity = 0.5;
    _iconsImageView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    _iconsImageView.layer.masksToBounds = YES;
    
    [_controlScrollView addSubview:_iconsImageView];
    [_iconsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_controlScrollView);
        make.top.mas_equalTo(_controlScrollView.mas_topMargin).mas_offset(XBB_Size_w_h(133.f));
    }];
    _iconsImageView.transform = CGAffineTransformScale(_iconsImageView.transform, 0.1, 0.1);
  
    _iconsImageView.alpha = 0;
    
    [UIView animateKeyframesWithDuration:.2 delay:.1 options:0 animations:^{
       _iconsImageView.transform = CGAffineTransformScale(_iconsImageView.transform, 9., 9.);
        _iconsImageView.alpha = 1.;
    } completion:nil];
}

- (void)setUpControlArea
{
    /**
     * @brief 手机号输入框
     **/
    UIImage *phonelineImage = nil;
    if (XBB_IsIphone6_6s) {
        phonelineImage = [UIImage imageNamed:@"XBBLoginLine_6"];
    }else
    {
        phonelineImage = [UIImage imageNamed:@"XBBLoginLine"];
    }
    UIImageView *phoneLine = [[UIImageView alloc] initWithImage:phonelineImage];
    [_controlScrollView addSubview:phoneLine];
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_controlScrollView);
        make.top.mas_equalTo(_iconsImageView.mas_bottomMargin).mas_offset(XBB_Size_w_h(145.f));
    }];

    UIImage *phoneIconImage = nil;
    if (XBB_IsIphone6_6s) {
        phoneIconImage = [UIImage imageNamed:@"xbb_phone"];
    }else
    {
        phoneIconImage = [UIImage imageNamed:@"xbb_phone6"];
    }
    
    UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:phoneIconImage];
    [_controlScrollView addSubview:phoneIcon];
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneLine).mas_offset(-(phoneIconImage.size.height+10));
        make.leading.mas_equalTo(phoneLine.mas_leading).mas_offset(15.f);
    }];
    
    self.txtLogin = [[UITextField alloc] init];
    self.txtLogin.tintColor = [UIColor whiteColor];
    self.txtLogin.textColor = [UIColor whiteColor];
    self.txtLogin.keyboardAppearance = UIKeyboardAppearanceLight;
    
    self.txtLogin.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:kUIColorFromRGB_alpha(0xdddddd,0.6f),NSFontAttributeName:XBB_Prompt_Font}];
    self.txtLogin.clearButtonMode = UITextFieldViewModeAlways;
    self.txtLogin.keyboardType = UIKeyboardTypeNumberPad;
    self.txtLogin.delegate = self;
    [_controlScrollView addSubview:self.txtLogin];
    [self.txtLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIcon.mas_rightMargin).mas_offset(25.);
        make.centerY.mas_equalTo(phoneIcon).mas_offset(5);
        make.width.mas_equalTo(phoneLine.frame.size.width - phoneIcon.frame.size.width - 5.);
        make.height.mas_equalTo(44.);
    }];

    /**
     * @brief 密码输入框
     **/
    UIImage *pwdlineImage = nil;
    if (XBB_IsIphone6_6s) {
        pwdlineImage = [UIImage imageNamed:@"XBBLoginLine_6"];
    }else
    {
        pwdlineImage = [UIImage imageNamed:@"XBBLoginLine"];
    }
    UIImageView *pwdImageView = [[UIImageView alloc] initWithImage:pwdlineImage];
    [_controlScrollView addSubview:pwdImageView];
    [pwdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_controlScrollView);
        make.top.mas_equalTo(phoneLine.mas_bottomMargin).mas_offset(65.);
    }];
    
    UIImage *pwdIconImage = nil;
    if (XBB_IsIphone6_6s) {
        pwdIconImage = [UIImage imageNamed:@"xbb_pwd_Icons"];
    }else
    {
        pwdIconImage = [UIImage imageNamed:@"xbb_pwd_Icons6"];
    }
    
    UIImageView *pwdIcon = [[UIImageView alloc] initWithImage:pwdIconImage];
    [_controlScrollView addSubview:pwdIcon];
    [pwdIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pwdImageView).mas_offset(-(pwdIconImage.size.height+10));
        make.leading.mas_equalTo(phoneLine.mas_leading).mas_offset(15.f);
    }];
    
    self.txtPWD = [[UITextField alloc] initWithFrame:CGRectMake(10, 51, CGRectGetWidth(self.view.bounds)-20, 50)];
    [self.txtPWD setSecureTextEntry:YES];
    self.txtPWD.tintColor = [UIColor whiteColor];
    self.txtPWD.textColor = [UIColor whiteColor];
    self.txtPWD.delegate = self;
    self.txtPWD.clearButtonMode = UITextFieldViewModeAlways;
    self.txtPWD.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:kUIColorFromRGB_alpha(0xdddddd,0.6f),NSFontAttributeName:XBB_Prompt_Font}];
    [_controlScrollView addSubview:self.txtPWD];
    [self.txtPWD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.txtLogin);
        make.height.mas_equalTo(self.txtLogin);
        make.centerX.mas_equalTo(self.txtLogin);
        make.centerY.mas_equalTo(pwdIcon).mas_offset(5.);
    }];

    
    /**
     * @brief 忘记密码
     **/
    UIImage *forgetImge = nil;
    if (XBB_IsIphone6_6s) {
        forgetImge = [UIImage imageNamed:@"xbb_forget_pwd_icon6"];
    }else
    {
        forgetImge = [UIImage imageNamed:@"xbb_forget_pwd_icon"];
    }
    UIImageView *forgetImageView = [[UIImageView alloc] initWithImage:forgetImge];
    [_controlScrollView addSubview:forgetImageView];
    [forgetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pwdImageView.mas_bottomMargin).mas_offset(20);
        make.right.mas_equalTo(pwdImageView.mas_rightMargin).mas_offset(-50);
    }];
    
    UILabel *forgetLabel = [[UILabel alloc] init];
    forgetLabel.backgroundColor = [UIColor clearColor];
    forgetLabel.textColor = [UIColor whiteColor];
    forgetLabel.text = @"忘记密码";
    [forgetLabel setFont:[UIFont systemFontOfSize:11.]];
    [_controlScrollView addSubview:forgetLabel];
    forgetLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *forgetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPwd:)];
    [forgetLabel addGestureRecognizer:forgetTap];
    [forgetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(forgetImageView.mas_rightMargin).mas_offset(15);
        make.centerY.mas_equalTo(forgetImageView);
        make.right.mas_equalTo(pwdImageView.mas_rightMargin).mas_offset(5);
    }];
    
    
    
    /**
     * @brief 登录
     **/
    
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    UIImage *loginNoselectImage = nil;
    if (XBB_IsIphone6_6s) {
        loginNoselectImage = [UIImage imageNamed:@"xbb_noSelect_login6"];
    }else
    {
        loginNoselectImage = [UIImage imageNamed:@"xbb_noSelect_login"];
    }
    UIImage *imageLoginSelect = nil;
    if (XBB_IsIphone6_6s) {
        imageLoginSelect = [UIImage imageNamed:@"xbb_login_select6"];

    }else
    {
        imageLoginSelect = [UIImage imageNamed:@"xbb_login_select"];

    }
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [loginButton setBackgroundImage:loginNoselectImage forState:UIControlStateNormal];
    [loginButton setBackgroundImage:imageLoginSelect forState:UIControlStateHighlighted];
    [_controlScrollView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(pwdImageView.mas_bottomMargin).mas_offset(150.);
    }];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     * @brief 注册
     **/
    UIButton *registerButton = [[UIButton alloc] init];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [registerButton addTarget:self action:@selector(rigisters) forControlEvents:UIControlEventTouchUpInside];
    UIImage *registerButtonNoselectImage = nil;
    if (XBB_IsIphone6_6s) {
        registerButtonNoselectImage = [UIImage imageNamed:@"xbb_noSelect_login6"];
    }else
    {
        registerButtonNoselectImage = [UIImage imageNamed:@"xbb_noSelect_login"];
    }
    
    UIImage *imageregisterButtonSelect = nil;
    if (XBB_IsIphone6_6s) {
        imageregisterButtonSelect = [UIImage imageNamed:@"xbb_login_select6"];
        
    }else
    {
        imageregisterButtonSelect = [UIImage imageNamed:@"xbb_login_select"];
        
    }
    
    [registerButton setBackgroundImage:registerButtonNoselectImage forState:UIControlStateNormal];
    [registerButton setBackgroundImage:imageregisterButtonSelect forState:UIControlStateHighlighted];
    [_controlScrollView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(loginButton.mas_bottomMargin).mas_offset(25.);
    }];
    
    _controlScrollView.contentSize = CGSizeMake(0, 567.);
}

#pragma mark anction

- (IBAction)setRootController:(id)sender
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyNavigationController"] leftDrawerViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeftSideBarViewController"]];
        drawerController.maximumLeftDrawerWidth = 240.;
        drawerController.showsShadow = NO;
        drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
        drawerController.shouldStretchDrawer = NO;
        self.view.window.rootViewController = drawerController;
    }];
    
    
}
- (IBAction)taptoloseFristResponse:(id)sender
{
    if ([self.txtLogin isFirstResponder]) {
        [self.txtLogin resignFirstResponder];
    }
    if ([self.txtPWD isFirstResponder]) {
        [self.txtPWD resignFirstResponder];
    }
}
- (IBAction)keyboardWillShowNotification:(id)sender
{
    if (XBB_IsIphone4s) {
        [UIView beginAnimations:@"contentOffset" context:nil];
        [UIView setAnimationDuration:0.3f];
        CGRect frame = self.view.frame;
        if ([_selectField isEqual:self.txtLogin]) {
            _controlScrollView.contentOffset = CGPointMake(0, 20);
        }else
        {
            _controlScrollView.contentOffset = CGPointMake(0, 60);
        }
        
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}
- (IBAction)keyboardWillHideNotification:(id)sender
{
    [UIView beginAnimations:@"contentOffset" context:nil];
    [UIView setAnimationDuration:0.3f];
    _controlScrollView.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
}

- (void)login{
    [self.txtLogin resignFirstResponder];
    [self.txtPWD resignFirstResponder];
    if (self.haveConnection == NO) {
        [SVProgressHUD showErrorWithStatus:@"请检查您的网络"];
        return;
    }
    
    if ([self.txtLogin.text length] == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if ([self.txtPWD.text length] == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return;
    }
    [SVProgressHUD show];
    if ([self.txtLogin.text length] == 11) {
        if ([self.txtPWD.text length] >= 6) {
            [NetworkHelper postWithAPI:Login_API parameter:@{@"iphone":self.txtLogin.text,@"pwd":self.txtPWD.text} successBlock:^(id response) {
                DLog(@"%@",response)
                if ([response[@"code"] integerValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                    NSUserDefaults *isLogin = [NSUserDefaults standardUserDefaults];
                    [isLogin setObject:[[response objectForKey:@"result"] objectForKey:@"iphone"] forKey:@"iphone"];
                    [isLogin setObject:[[response objectForKey:@"result"] objectForKey:@"id"] forKey:@"userid"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccessful object:nil];
                    [UserObj shareInstance].uid = [[response objectForKey:@"result"] objectForKey:@"id"];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [NSThread sleepForTimeInterval:0.5];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setRootController:nil];
                        });
                    });
                } else {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
            } failBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"登录失败"];
            }];
        }else{
            [SVProgressHUD showInfoWithStatus:@"密码长度不正确"];
        }
    }else{
        [SVProgressHUD showInfoWithStatus:@"账户不是手机号"];
    }
}

#pragma 忘记密码
- (void) forgetPwd:(id)sender{
    if (self.haveConnection == NO) {
        [SVProgressHUD showErrorWithStatus:@"请检查您的网络"];
        return;
    }
    ForgetPwdViewController *forgetPwdVC = [[ForgetPwdViewController alloc] init];
    [self presentViewController:forgetPwdVC animated:YES completion:nil];
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}
#pragma mark 注册
- (void)rigisters{
    if (self.haveConnection == NO) {
        [SVProgressHUD showErrorWithStatus:@"请检查您的网络"];
        return;
    }
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self presentViewController:registerVC animated:YES completion:nil];
//    [self.navigationController pushViewController:registerVC animated:YES];
}


- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _selectField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *string_1 = [textField.text stringByAppendingString:string];
    
    if ([textField isEqual:self.txtLogin]) {
        if ([string_1 length]>11) {
            return NO;
        }
    }
    if ([textField isEqual:self.txtPWD]) {
        if ([string_1 length]>16.) {
            return NO;
        }
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Animation

- (void)startAnimation
{
    // 先创建两个
    [self creatAnimationImageView];
    [self creatAnimationImageView];
    
    //  然后下面的用定时器，随机一个时间添加一个出来
    CGFloat duration = [self getRandomTimeWithMin:3 max:10];
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(creatAnimationImageView) userInfo:nil repeats:YES];
}

// 创建一个imageView，并且开始动画,透明度慢慢变成1,然后随机移动位置 ，然后透明度再变成0，然后移除出视图
- (UIImageView *)creatAnimationImageView
{
    // 得到一个随机图片
    UIImage *image = [self getRandomImage];
    CGPoint point = [self getRandomPoint];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    imageView.center = point;
    imageView.alpha = 0;
    // 将imageView插入到背景图上
    [self.view insertSubview:imageView aboveSubview:_bgImageView];
    
    // 开始动画
    [UIView animateWithDuration:[self getRandomTimeWithMin:2 max:4] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.alpha = 0.6;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:[self getRandomTimeWithMin:6 max:20] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            imageView.center = [self getRandomPoint];
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:[self getRandomTimeWithMin:2 max:4] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                imageView.alpha = 0;
            }completion:^(BOOL finished) {
                [imageView removeFromSuperview];
            }];
        }];
    }];
    
    return imageView;
}

// 取一个随机的图片
- (UIImage *)getRandomImage
{
    NSInteger index = arc4random()%5 + 1;
    NSString *imageString = [NSString stringWithFormat:@"login_%d", (int)index];
    UIImage *image = [UIImage imageNamed:imageString];
    return image;
}

// 取一个随机的坐标，在视图范围之内
- (CGPoint)getRandomPoint
{
    NSInteger width = self.view.frame.size.width;
    NSInteger height = self.view.frame.size.height;
    CGFloat x = arc4random() % width;
    CGFloat y = arc4random() % height;
    CGPoint point = CGPointMake(x, y);
    return point;
}

// 取一个10到20的随机数
- (NSTimeInterval)getRandomTimeWithMin:(NSInteger)min max:(NSInteger)max
{
    NSTimeInterval time = arc4random() % (max - min) + min;
    return time;
}


@end
