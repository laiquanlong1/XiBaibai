//
//  CouponsUseRuleViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/11/17.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "CouponsUseRuleViewController.h"

@interface CouponsUseRuleViewController ()
{
    UITextView *_txtView;
}
@end

@implementation CouponsUseRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavi];
    
    _txtView = [[UITextView alloc] init];
    _txtView.showsHorizontalScrollIndicator = YES;
    _txtView.editable = NO;
    [_txtView setContentSize:CGSizeMake(0, self.view.bounds.size.height+20)];
//    _txtView.userInteractionEnabled = NO;
    [_txtView setFont:[UIFont systemFontOfSize:14.]];
    _txtView.text = [NSString stringWithContentsOfURL:self.url encoding:NSUTF8StringEncoding error:nil];
    [self.view addSubview:_txtView];
    [_txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view);
        make.center.mas_equalTo(self.view);
    }];
    



    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    //导航栏中间
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    UILabel *labtitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 11, 150, 22)];
    labtitle.textColor=[UIColor whiteColor];
    labtitle.textAlignment=NSTextAlignmentCenter;
    labtitle.text= self.titleNav;
    labtitle.font = TITLEFONT;
    [titleView addSubview:labtitle];
    self.navigationItem.titleView=titleView;
    // Do any additional setup after loading the view.
    self.view.backgroundColor=kUIColorFromRGB(0xf4f4f4);
    
    //返回
    UIImageView * img_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_back.png"]];
    img_view.layer.masksToBounds=YES;
    img_view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [img_view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:img_view];
}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
