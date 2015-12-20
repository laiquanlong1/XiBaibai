//
//  SetCarAddsInfoViewController.m
//  XBB
//
//  Created by mazi on 15/9/4.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "SetCarAddsInfoViewController.h"
#import "UserObj.h"

@interface SetCarAddsInfoViewController ()<UITextViewDelegate>{
    UITextView *txtView;
    UIAlertView *alert;
}

@property (strong,nonatomic) UILabel *placeholderLabel;

@end

@implementation SetCarAddsInfoViewController

- (void)initView{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"设置详细地址";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = title;
    //返回
    UIImageView * img_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_back.png"]];
    img_view.layer.masksToBounds=YES;
    img_view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fanhui)];
    [img_view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:img_view];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(okAdds)];
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xFFFFFF);
    
    //详细地址内容
    txtView = [[UITextView alloc] init];
    txtView.delegate = self;//设置它的委托方法
    txtView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    txtView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    txtView.selectedRange=NSMakeRange(0,-100) ;   //起始位置
    txtView.font = [UIFont systemFontOfSize:15];
  
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    txtView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.view addSubview:txtView];
    [txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(71);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    
    self.placeholderLabel = [UILabel new];
    self.placeholderLabel.text = @"请输入详细位置";
    self.placeholderLabel.textColor = kUIColorFromRGB(0xd1d1d1);
    self.placeholderLabel.font = [UIFont systemFontOfSize:14.0];
    [txtView addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(txtView.mas_top).mas_offset(8);
        make.left.mas_equalTo(txtView.mas_left).mas_offset(5);
    }];
    if (self.addressD) {
        txtView.text = self.addressD;
        self.placeholderLabel.hidden = YES;
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
    //    if (self.isHomeControllerto) {
    //        [rightButton setTitle:@"下单" forState:UIControlStateNormal];
    //    }else
        {
            [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        }
    
        [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14.]];
        [self.xbbNavigationBar addSubview:rightButton];
        [rightButton addTarget:self action:@selector(okAdds) forControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)backViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    [self setNavigationBarControl];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *textView = object;
    textView.contentOffset = (CGPoint){.x = 0,.y = 0};
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)okAdds{
    if (!txtView.text.length) {
//        alert = [CustamViewController createAlertViewTitleStr:@"请输入内容" withMsg:nil widthDelegate:self withCancelBtn:nil withbtns:nil];
//        [alert show];
//        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1];
        [SVProgressHUD showErrorWithStatus:@"请输入地址"];
    } else {
        [SVProgressHUD show];
        [NetworkHelper postWithAPI:AddUser_address_API parameter:@{@"uid":[UserObj shareInstance].uid,
                                                                   @"address_info":txtView.text,
                                                                   @"address_type":[NSString stringWithFormat:@"%ld",self.num]}
                      successBlock:^(id response) {
                          if ([response[@"code"] integerValue] == 1) {
                              [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                  [self.delegate setAddsInfo:txtView.text withNum:self.num];
                                  [self.navigationController popViewControllerAnimated:YES];
                              });
                          } else {
                              [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                          }
                      } failBlock:^(NSError *error) {
                          [SVProgressHUD showErrorWithStatus:@"添加失败"];
                      }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)dismiss:(id)sender {
   
    [alert dismissWithClickedButtonIndex:0 animated:YES];
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
