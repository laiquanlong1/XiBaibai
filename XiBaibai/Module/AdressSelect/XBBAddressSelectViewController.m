//
//  XBBAddressSelectViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/12/9.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBAddressSelectViewController.h"
#import "XBBAddressTableViewCell.h"
#import "UserObj.h"
#import "XBBMapViewController.h"

@interface XBBAddressSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation XBBAddressSelectViewController

- (void)initViewDidLoadDatas
{
    if ([[UserObj shareInstance] homeAddress] == nil || [[UserObj shareInstance] companyAddress] == nil) {
        [self fetchAddressFromWeb:nil];
    }
}

- (void)hiddenTableView:(BOOL)hidden
{
    [UIView beginAnimations:@"alphaAniamation" context:nil];
    [UIView setAnimationDuration:0.25];
    if (hidden) {
        self.tableView.alpha = 0;
    }else
    {
        self.tableView.alpha = 1;
    }
    [UIView commitAnimations];
}

#pragma mark datas
- (void)fetchAddressFromWeb:(void (^)())callback {
    [SVProgressHUD show];
    [self hiddenTableView:YES];
    [NetworkHelper postWithAPI:API_AddressSelect parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
        [self hiddenTableView:NO];
        if ([response[@"code"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            NSArray *result = response[@"result"][@"list"];
            for (NSDictionary *temp in result) {
                if ([temp[@"address_type"] integerValue] == 0) {
                    [UserObj shareInstance].homeAddress = temp[@"address"];                    [UserObj shareInstance].homeDetailAddress = temp[@"address_info"];
                    [UserObj shareInstance].homeCoordinate = CLLocationCoordinate2DMake([temp[@"address_lt"] doubleValue], [temp[@"address_lg"] doubleValue]);
                } else if ([temp[@"address_type"] integerValue] == 1) {
                    [UserObj shareInstance].companyAddress = temp[@"address"];
                    [UserObj shareInstance].companyDetailAddress = temp[@"address_info"];
                    [UserObj shareInstance].companyCoordinate = CLLocationCoordinate2DMake([temp[@"address_lt"] doubleValue], [temp[@"address_lg"] doubleValue]);
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}


#pragma mark action

- (IBAction)backViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60.;
    }
    return 120.;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return 1;
 
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adressCell" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        XBBAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adressCell_2" forIndexPath:indexPath];
        if (indexPath.section == 1) {
            
            cell.headImageView.image = [UIImage imageNamed:@"家庭5"];
            cell.addressLabel.text = [[UserObj shareInstance] homeAddress];
            cell.labelHeadView.image = [UIImage imageNamed:@"备注5"];
            cell.labelLabel.text = [[UserObj shareInstance] homeDetailAddress];
            
            
        }else if (indexPath.section == 2) {
            cell.headImageView.image = [UIImage imageNamed:@"公司5"];
            cell.addressLabel.text = [[UserObj shareInstance] companyAddress];
            cell.labelHeadView.image = [UIImage imageNamed:@"备注5"];
            cell.labelLabel.text = [[UserObj shareInstance] companyDetailAddress];
        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        XBBMapViewController *map = [[XBBMapViewController alloc] init];
        map.superController = NSStringFromClass([self class]);
        map.selectAddress = ^(BOOL model){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [NSThread sleepForTimeInterval:0.01];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (model) {
                        XBBAddressModel *model = [[XBBAddressModel alloc] init];
                        model.address = [[UserObj shareInstance] currentAddress];
                        model.remarkAddress = [[UserObj shareInstance] currentAddressDetail];
                        model.coordinate = [[UserObj shareInstance] currentCoordinate];
                        self.selectAddressBlock(model);
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }

                });
                
            });
            
        };
        [self presentViewController:map animated:YES completion:^{
        }];
    }
    if (indexPath.section == 1) {
        if ([[UserObj shareInstance] homeAddress].length > 0) {
            XBBAddressModel *model = [[XBBAddressModel alloc] init];
            model.address = [[UserObj shareInstance] homeAddress];
            model.remarkAddress = [[UserObj shareInstance] homeDetailAddress];
            model.coordinate = [[UserObj shareInstance] homeCoordinate];
            self.selectAddressBlock(model);
        }
         [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (indexPath.section == 2) {
        if ([[UserObj shareInstance] homeAddress].length > 0) {
            XBBAddressModel *model = [[XBBAddressModel alloc] init];
            model.address = [[UserObj shareInstance] companyAddress];
            model.remarkAddress = [[UserObj shareInstance] companyDetailAddress];
            model.coordinate = [[UserObj shareInstance] companyCoordinate];
            self.selectAddressBlock(model);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}



#pragma mark UI

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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"Navigation"];
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



- (void)initUI
{
    [self setNavigationBarControl];
    self.tableView.backgroundColor = XBB_Bg_Color;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)dismisController:(id)sender
{
    DLog(@"")
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
