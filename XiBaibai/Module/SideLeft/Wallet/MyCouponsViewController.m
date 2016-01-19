//
//  MyCouponsViewController.m
//  XBB
//
//  Created by Daniel on 15/9/2.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "MyCouponsViewController.h"
#import "MyCouponsTableViewCell.h"
#import "MyCouponsModel.h"
#import "UserObj.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WebViewController.h"
#import "AddOrderViewController.h"
#import "MyWallViewController.h"
#import "XBBScanViewController.h"


@interface MyCouponsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tbView;
    UIImageView *imgViewguize;
    XBBNotDataView *noDataView;
    NSString *ruleURL;
    UIButton  *_ruleButton;
}
@property (strong, nonatomic) NSMutableArray *couDoneArr;

@property (nonatomic, copy) NSDictionary *couponselectDic;

@end

@implementation MyCouponsViewController


- (void)backViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"我的优惠券"];
    [titelLabel setFont:XBB_NavBar_Font];
    [titelLabel setTextAlignment:NSTextAlignmentCenter];
    [self.xbbNavigationBar addSubview:titelLabel];
    [titelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30.);
        make.centerY.mas_equalTo(self.xbbNavigationBar).mas_offset(10.f);
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(XBB_Screen_width-100);
    }];
    if (!self.isAddoder) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width-100, 30, 100, 30)];
        [button setTitle:@"扫一扫" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pushPanViewController:) forControlEvents:UIControlEventTouchUpInside];
        [self.xbbNavigationBar addSubview:button];
    }
   
}

- (IBAction)pushPanViewController:(id)sender
{
    XBBScanViewController *scan = [[XBBScanViewController alloc] init];
    [self.navigationController pushViewController:scan animated:YES];
}

- (void)initView{
    tbView = [UITableView new];
    tbView.frame = CGRectMake(0, 65, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64);
    tbView.dataSource=self;
    tbView.delegate=self;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbView];
    // 2.集成刷新控件
    [self setupRefresh];
    [self setNavigationBarControl];
    
}

- (void)guize{

    [self couponsUseRule];
}
- (void)setupRefresh
{
    self.view.backgroundColor = XBB_Bg_Color;
   
    WS(weakSelf)
    tbView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf fetchYouhuiFromWeb:^{
            if (self.couDoneArr.count == 0 || self.couDoneArr == nil) {
                tbView.alpha = 0;
                noDataView.alpha = 1;
            }else
            {
                tbView.alpha = 1;
                noDataView.alpha = 0;
            }
            [tbView.header endRefreshing];
            [tbView.footer resetNoMoreData];
        }];
    }];
}

- (void)couponsUseRule
{
    NSString *path = ruleURL; //[[NSBundle mainBundle] pathForResource:@"CouponsUseRule" ofType:@"txt"];

    WebViewController *vc = [[WebViewController alloc] init];
    vc.urlString = path;
    vc.navigationTitle = @"优惠券使用规则";
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (void)fetchYouhuiFromWeb:(void (^)())callback {

    [SVProgressHUD show];
    [NetworkHelper postWithAPI:XBB_Coupons_select parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
        
        self.couDoneArr = [NSMutableArray array];
        if ([response[@"code"] integerValue] == 1) {
            for (NSDictionary *temp in response[@"result"]) {
                if ([temp[@"state"] integerValue] == 0) {
                    ruleURL = temp[@"ruleUrl"];
                    [self.couDoneArr addObject:temp];
                }
                if (self.couDoneArr == 0) {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                    [tbView.footer noticeNoMoreData];
                } else {
                    
                    [SVProgressHUD dismiss];
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"查询失败"];
        }
        if (self.couDoneArr.count > 0) {
            [tbView reloadData];
        }else
        {
            
        }
        
        if (callback)
            callback();
    } failBlock:^(NSError *error) {
        if (callback)
            callback();
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}


- (void)initNoDataUI
{
    noDataView = [[XBBNotDataView alloc] initWithFrame:self.view.bounds withImage:[UIImage imageNamed:@"43我的优惠券无数据"] withString:@"您还没有优惠券信息哦" ];
    [self.view addSubview:noDataView];
    noDataView.alpha = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNoDataUI];
    [self initView];
    tbView.backgroundColor = XBB_Bg_Color;
    [tbView registerNib:[UINib nibWithNibName:@"MyCouponsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.couDoneArr = [NSMutableArray array];
 
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    tbView.alpha = 0;
    [self fetchYouhuiFromWeb:^{
        if (self.couDoneArr.count == 0 || self.couDoneArr == nil) {
            tbView.alpha = 0;
            noDataView.alpha = 1;
        }else
        {
            tbView.alpha = 1;
            noDataView.alpha = 0;
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
}

- (void)viewDidDisappear:(BOOL)animated{
    [imgViewguize removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - tableviewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view  = [[UIView alloc] init];
    _ruleButton = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width- 100, 5, 80, 30)];
    [view addSubview:_ruleButton];
    [_ruleButton setImage:[UIImage imageNamed:@"问号"] forState:UIControlStateNormal];
    [_ruleButton setTintColor:XBB_NavBar_Color];
    [_ruleButton setTitle:@"使用规则" forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(guize) forControlEvents:UIControlEventTouchUpInside];
    [_ruleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_ruleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [_ruleButton.titleLabel setFont:[UIFont systemFontOfSize:10.]];
    
    
    view.backgroundColor = XBB_Bg_Color;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.couDoneArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity = @"cell";
    MyCouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell = [[MyCouponsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    //    cell.labRemark.text = dic[@"coupons_remark"]; //model.coupons_remark;
    NSDictionary *dic = self.couDoneArr[indexPath.row];
  
    NSMutableAttributedString *at = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 元",dic[@"coupons_price"]]];
    [at addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.]} range:NSMakeRange(0, [at length]-1)];
    [at addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.]} range:NSMakeRange([at length]-1, 1)];
    cell.priceLabel.attributedText = at;
    cell.backgroundView.backgroundColor = XBB_Bg_Color;
    cell.backgroundColor = XBB_Bg_Color;
    
//    cell.priceLabel.text =  dic[@"coupons_price"];//model.coupons_price;
    cell.nameLabel.text= dic[@"coupons_name"];//model.coupons_name;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY.MM.dd";
    NSDate *timer = [NSDate dateWithTimeIntervalSince1970:[dic[@"expired_time"] integerValue]];
    NSString *timeString = [fmt stringFromDate:timer];
    
    
    cell.endTimeLabel.text = [NSString stringWithFormat:@"有效期至  %@",timeString];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isAddoder) {
        if (self.couponselectDic) {
            self.couponselectDic = nil;
        }
        NSDictionary *dic = self.couDoneArr[indexPath.row];
        self.couponselectDic = dic;
        MyCouponsModel *model = [[MyCouponsModel alloc] init];
        model.coupons_name = dic[@"coupons_name"];
        model.coupons_price = dic[@"coupons_price"];
        model.coupons_remark = dic[@"coupons_remark"];
        model.effective_time = dic[@"effective_time"];
        model.expired_time = dic[@"expired_time"];
        model.couponsId = dic[@"id"];
        model.number = dic[@"number"];
        model.state = dic[@"state"];
        model.time = dic[@"time"];
        model.type = dic[@"type"];
        model.uid = dic[@"uid"];
        self.couponsBlock(model);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
