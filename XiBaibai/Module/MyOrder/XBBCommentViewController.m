//
//  XBBCommentViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/12/20.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBCommentViewController.h"
#import "DMLineView.h"
#import "StarView.h"
#import "UserObj.h"

@interface XBBCommentViewController ()<UITextViewDelegate>
{
    UITextView *txtView;
    UILabel    *promptLabel;
    UILabel    *textNumberLabel;
    StarView   *startvView;
    NSInteger   startScore;
}
@end

@implementation XBBCommentViewController

#pragma mark data

- (void)submitCommentDatas:(void(^)(void))complation
{
    
    [SVProgressHUD show];
    DLog(@"%@  %ld  %@",_orderId,startScore,txtView.text)
    [NetworkHelper postWithAPI:API_CommentInsert parameter:@{@"orderid": _orderId, @"evaluate": txtView.text, @"star": @(startScore)} successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"评价成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOrderListUpdate object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"评价失败"];
    }];
}

#pragma mark UI

- (void)initUI
{
    [self setNavigationBarControl];
    [self initView];
}


- (void)initView
{
    UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKey:)];
    [self.backgroundScrollView addGestureRecognizer:tap_1];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, XBB_Screen_width, 44.)];
    backView.backgroundColor = XBB_Forground_Color;
    
    UILabel *titleLsbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 44.)];
    [titleLsbl setFont:XBB_CellTitleFont];
    [backView addSubview:titleLsbl];
    [titleLsbl setTextColor:XBB_CellTitleColor];
    [backView addSubview:titleLsbl];
    titleLsbl.text = @"评分";
    
    
    [self.backgroundScrollView addSubview:backView];
    startvView = [StarView starView];
    startvView.frame = CGRectMake(backView.bounds.size.width - startvView.frame.size.width-20, backView.bounds.size.height/2-startvView.frame.size.height/2 , startvView.frame.size.width, startvView.frame.size.height);
    [backView addSubview:startvView];
    startvView.userInteractionEnabled = YES;
    startvView.starOne.userInteractionEnabled = YES;
    startvView.starOne.tag = 1;
    startvView.starTwo.userInteractionEnabled = YES;
    startvView.starTwo.tag = 2;
    startvView.starThree.userInteractionEnabled = YES;
    startvView.starThree.tag = 3;
    startvView.starFour.userInteractionEnabled = YES;
    startvView.starFour.tag = 4;
    startvView.starFive.userInteractionEnabled = YES;
    startvView.starFive.tag = 5;
    
     [startvView.starOne addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starComment:)]];
    [startvView.starTwo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starComment:)]];
    [startvView.starThree addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starComment:)]];
    [startvView.starFive addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starComment:)]];
    [startvView.starFour addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starComment:)]];
    
    
    
    
    
    
//    DMLineView *line = [[DMLineView alloc] initWithFrame:CGRectMake(0, 108, XBB_Screen_width, 1)];
//    [self.backgroundScrollView addSubview:line];
//    line.lineColor = XBB_separatorColor;
//    line.lineWidth = 1;
////    line.dotted = YES;
////    line.dottedGap = 2;
    UIView *backViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 109, XBB_Screen_width, 150.)];
    [self.backgroundScrollView addSubview:backViewTwo];
    backViewTwo.backgroundColor = XBB_Forground_Color;
    
    
    txtView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, backViewTwo.bounds.size.width-20, backViewTwo.bounds.size.height-10)];
    [backViewTwo addSubview:txtView];
    [txtView setFont:XBB_TXTFont];
    txtView.delegate = self;
    
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, txtView.bounds.size.width-5, 20)];
    [txtView addSubview:promptLabel];
    promptLabel.text = @"请在此输入您宝贵的意见,谢谢~";
    
    [promptLabel setTextColor:XBB_Promat_Color];
    [promptLabel setFont:XBB_TXTFont];
    
    
    textNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, backViewTwo.bounds.size.height - 20, backViewTwo.bounds.size.width-20, 20)];
    [textNumberLabel setFont:XBB_TXTFont];
    [textNumberLabel setTextColor:XBB_Promat_Color];
    [backViewTwo addSubview:textNumberLabel];
    textNumberLabel.text = @"0/500";
    [textNumberLabel setTextAlignment:NSTextAlignmentRight];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, backViewTwo.frame.origin.y+backViewTwo.frame.size.height + 60., XBB_Screen_width - 40., 44.)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [button setImage:[UIImage imageNamed:@"starSureButton"] forState:UIControlStateNormal];
    
    
    [button setContentMode:UIViewContentModeCenter];
    [button setBackgroundImage:[UIImage imageNamed:@"starSureButton"] forState:UIControlStateNormal];
    [self.backgroundScrollView addSubview:button];
    
    [backViewTwo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKey:)]];
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKey:)]];
    
    [button addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];

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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"评价订单"];
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



#pragma mark action
- (IBAction)sureButtonAction:(id)sender
{
    if (startScore == 0) {
        [SVProgressHUD showInfoWithStatus:@"您还没有评定星级,给我们的技师评一下吧~"];
        return;
    }
    if ([txtView.text length] == 0) {
        [SVProgressHUD showInfoWithStatus:@"您还没有输入内容，给点您宝贵的意见吧~"];
        return;
    }
    [self submitCommentDatas:^{
        [SVProgressHUD dismiss];
    
    }];
    
}
- (IBAction)hidenKey:(id)sender
{
    [txtView resignFirstResponder];
}

- (IBAction)starComment:(id)sender
{
    UITapGestureRecognizer *tap = sender;
    UIView *view = tap.view;
    startvView.score = view.tag;
    startScore = view.tag;
}

- (IBAction)backViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark system

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark txtViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    DLog(@"%@",string)
    if ([string length] > 500) {
        [SVProgressHUD showInfoWithStatus:@"超出输入限制"];
        return NO;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    textNumberLabel.text = [NSString stringWithFormat:@"%d/500",[textView.text length]];
    if ([txtView.text length] > 0) {
        promptLabel.alpha = 0;
    }else
    {
        promptLabel.alpha = 1;
    }
}

@end
