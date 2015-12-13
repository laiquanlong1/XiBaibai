//
//  MyLiCouponViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/12/12.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "MyLiCouponViewController.h"
#import "MyLicouponTableViewCell.h"
#import "XBBCashViewController.h"




@interface MyLiCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyLiCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    // Do any additional setup after loading the view.
}
- (void)initUI
{
    [self setNavigationBarControl];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (MyLicouponTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLicouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.nameLabel.text = @"";
    cell.numbelLabel.text = @"";
    
    switch (indexPath.section) {
        case 0:
        {
            cell.nameLabel.text = @"兑换优惠码";
            cell.headImageView.image = [UIImage imageNamed:@"兑换"];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.nameLabel.text = @"优惠券";
                    cell.headImageView.image = [UIImage imageNamed:@"优惠券"];
                }
                    break;
                case 1:
                {
                    cell.nameLabel.text = @"积分";
                    cell.headImageView.image = [UIImage imageNamed:@"积分"];
                }
                    break;
                    
                    
                default:
                    break;
            }
        }
            
        default:
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                XBBCashViewController *cash = [[UIStoryboard storyboardWithName:@"XBBOne" bundle:nil] instantiateViewControllerWithIdentifier:@"XBBCashViewController"];
                cash.navigationTitle = @"兑换优惠码";
                [self.navigationController pushViewController:cash animated:YES];
            }
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
}


@end
