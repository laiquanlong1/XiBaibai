//
//  XBBAddressViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/12/14.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBAddressViewController.h"
#import "XBBAddressHomeTableViewCell.h"
#import "UserObj.h"
#import "SetCarAddsViewController.h"
#import "SetCarAddsInfoViewController.h"


@interface XBBAddressViewController () <UITableViewDataSource, UITableViewDelegate,SetCarAddsViewControllerDelegate,SetCarAddsInfoViewControllerDelegate>
{
    UILabel  *nofoundLabel;
}
@property (nonatomic, strong) UITableView *tableView;
@end

static NSString *identifi = @"cell";
@implementation XBBAddressViewController



- (void)fetchAddressFromWeb:(void (^)())callback {
    [SVProgressHUD show];
    
    [UserObj shareInstance].homeAddress = nil;
    [UserObj shareInstance].homeDetailAddress = nil;
    [UserObj shareInstance].companyAddress = nil;
    [UserObj shareInstance].companyDetailAddress = nil;
    
    [NetworkHelper postWithAPI:API_AddressSelect parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
        
        if ([response[@"code"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            NSArray *result = response[@"result"][@"list"];
            for (NSDictionary *temp in result) {
                if ([temp[@"address_type"] integerValue] == 0) {
                    //家
                    [UserObj shareInstance].homeAddress = temp[@"address"];
                    [UserObj shareInstance].homeDetailAddress = temp[@"address_info"];
                    [UserObj shareInstance].homeCoordinate = CLLocationCoordinate2DMake([temp[@"address_lt"] doubleValue], [temp[@"address_lg"] doubleValue]);
                } else if ([temp[@"address_type"] integerValue] == 1) {
                    //公司
                    [UserObj shareInstance].companyAddress = temp[@"address"];
                    [UserObj shareInstance].companyDetailAddress = temp[@"address_info"];
                    [UserObj shareInstance].companyCoordinate = CLLocationCoordinate2DMake([temp[@"address_lt"] doubleValue], [temp[@"address_lg"] doubleValue]);
                }
            }
            
            if (callback) {
                callback();
            }
        } else {
            if (callback) {
                callback();
            }
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failBlock:^(NSError *error) {
        if (callback) {
            callback();
        }
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"常用地址"];
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

- (IBAction)backViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)hiddenTableView:(BOOL)hidden
{
    if (hidden) {
        self.tableView.alpha = 0;
    }else
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.alpha = 1.;
        }];
    }
}


- (void)regisCell
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XBB_Screen_width, XBB_Screen_height-64)];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = XBB_Bg_Color;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = XBB_Bg_Color;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = XBB_HeadEdge;
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBAddressHomeTableViewCell" bundle:nil] forCellReuseIdentifier:identifi];
    [self hiddenTableView:YES];
}

- (void)inirUI
{
    [self setNavigationBarControl];
    [self regisCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self inirUI];
    [self fetchAddressFromWeb:^{
        [self.tableView reloadData];
        [self hiddenTableView:NO];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 200.;
    }
    return 6.;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = XBB_Bg_Color;
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBBAddressHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (cell == nil) {
        cell = [[XBBAddressHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cell.headImageView.image = [UIImage imageNamed:@"家庭5"];
                cell.contentLabel.text = [[UserObj shareInstance] homeAddress];
            }else if (indexPath.row == 1) {
                 cell.headImageView.image = [UIImage imageNamed:@"备注5"];
                cell.contentLabel.text = [[UserObj shareInstance] homeDetailAddress];

            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                 cell.headImageView.image = [UIImage imageNamed:@"公司5"];
                cell.contentLabel.text = [[UserObj shareInstance] companyAddress];

            }else if (indexPath.row == 1) {
                 cell.headImageView.image = [UIImage imageNamed:@"备注5"];
                cell.contentLabel.text = [[UserObj shareInstance] companyDetailAddress];

            }
            
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SetCarAddsViewController *setcaraddVC = [[SetCarAddsViewController alloc] init];
    SetCarAddsInfoViewController *setcaraddsInfoVC = [[SetCarAddsInfoViewController alloc] init];
    XBBAddressHomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    setcaraddsInfoVC.navigationTitle = @"备注";
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                setcaraddVC.delegate = self;
                setcaraddVC.num = 0;
                [self.navigationController pushViewController:setcaraddVC animated:YES];
                break;
            case 1:
                setcaraddsInfoVC.delegate = self;
                setcaraddsInfoVC.num =0;
                setcaraddsInfoVC.addressD = cell.contentLabel.text;
                [self.navigationController pushViewController:setcaraddsInfoVC animated:YES];
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                setcaraddVC.delegate = self;
                setcaraddVC.num = 1;
                [self.navigationController pushViewController:setcaraddVC animated:YES];
                break;
            case 1:
                setcaraddsInfoVC.delegate = self;
                setcaraddsInfoVC.num = 1;
                setcaraddsInfoVC.addressD = cell.contentLabel.text;
                [self.navigationController pushViewController:setcaraddsInfoVC animated:YES];
                break;
            default:
                break;
        }
    }
}

- (void)setNowLocation:(NSString *)strLocation withNum:(NSInteger )num;
{
    if (num == 0) {
        [UserObj shareInstance].homeAddress = strLocation;
        [UserObj shareInstance].homeDetailAddress = @"";
    }else
    {
        [UserObj shareInstance].companyAddress = strLocation;
        [UserObj shareInstance].companyDetailAddress = @"";
    }
    [self.tableView reloadData];
}
- (void)setAddsInfo:(NSString *)AddsInfo withNum:(NSInteger )num
{
    if (num == 0) {
        [UserObj shareInstance].homeDetailAddress = AddsInfo;
    }else
    {
        [UserObj shareInstance].companyDetailAddress = AddsInfo;
    }
    [self.tableView reloadData];
    
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
