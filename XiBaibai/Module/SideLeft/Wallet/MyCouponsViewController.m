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
#import "CouponsUseRuleViewController.h"
#import "AddOrderViewController.h"
#import "MyWallViewController.h"

@interface MyCouponsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tbView;
    UIImageView *imgViewguize;
}
@property (strong, nonatomic) NSMutableArray *couDoneArr;

@property (nonatomic, copy) NSDictionary *couponselectDic;

@end

@implementation MyCouponsViewController

- (void)initView{
    self.view.backgroundColor = kUIColorFromRGB(0xf6f5fa);
    self.title = @"我的优惠券";
    //返回
    UIImageView * img_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_back.png"]];
    img_view.layer.masksToBounds=YES;
    img_view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fanhui)];
    [img_view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:img_view];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"使用规则" style:UIBarButtonItemStyleBordered target:self action:@selector(guize)];
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xFFFFFF);
    
    tbView=[UITableView new];
    tbView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    tbView.dataSource=self;
    tbView.delegate=self;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbView];
    
    // 2.集成刷新控件
    [self setupRefresh];
}

- (void)guize{

    [self couponsUseRule];
}
- (void)setupRefresh
{
    self.view.backgroundColor = [UIColor whiteColor];
    WS(weakSelf)
    tbView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf fetchYouhuiFromWeb:^{
            [tbView.header endRefreshing];
            [tbView.footer resetNoMoreData];
        }];
    }];
    /*
    tbView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf fetchYouhuiFromWeb:^{
            [tbView.footer endRefreshing];
        }];
    }];
     */
}

- (void)couponsUseRule
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CouponsUseRule" ofType:@"txt"];
    NSURL *url = [NSURL fileURLWithPath:path];
    CouponsUseRuleViewController *vc = [[CouponsUseRuleViewController alloc] init];
    vc.url = url;
    vc.titleNav = @"优惠券使用规则";
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)fetchYouhuiFromWeb:(void (^)())callback {
    [SVProgressHUD show];
    
    [NetworkHelper postWithAPI:YouhuiSelect_API parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
//        <#code#>
//    } failBlock:<#^(NSError *error)fail#>]
//    
//    
//    [NetworkHelper getWithAPI:YouhuiSelect_API parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
        if (callback)
            callback();
        self.couDoneArr = [NSMutableArray array];
        NSLog(@"dic%@",response);
        if ([response[@"code"] integerValue] == 1) {
            for (NSDictionary *temp in response[@"result"]) {
                
                if ([temp[@"state"] integerValue] == 0) {
                    
//                [MyCouponsModel setupReplacedKeyFromPropertyName:^NSDictionary *{
//                    return @{@"couponsId": @"id"};
//                }];
//                MyCouponsModel *model = [MyCouponsModel objectWithKeyValues:temp];
                
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
        [tbView reloadData];
    } failBlock:^(NSError *error) {
        if (callback)
            callback();
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self fetchYouhuiFromWeb:nil];
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
//    MyCouponsModel *model = self.couDoneArr[indexPath.row];
    NSDictionary *dic = self.couDoneArr[indexPath.row];
//    cell.labFuhao.text = @"￥";
    cell.labMoney.text =  dic[@"coupons_price"];//model.coupons_price;
    cell.labTitle.text = dic[@"coupons_name"];//model.coupons_name;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY.MM.dd HH:mm";
    cell.labValtime.text = [NSString stringWithFormat:@"有效期至%@",dic[@"expired_time"]];
    cell.labRemark.text = dic[@"coupons_remark"]; //model.coupons_remark;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.couponselectDic) {
        self.couponselectDic = nil;
    }
    
    NSDictionary *dic = self.couDoneArr[indexPath.row];
    self.couponselectDic = dic;
  
   NSArray *controllers = self.navigationController.viewControllers;
    for (int i = 0; i < controllers.count; i++) {
        UIViewController *vc =  controllers[i];
        if ([vc isKindOfClass:[AddOrderViewController class]]) {
            self.couponsBlock(dic);
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        if ([vc isKindOfClass:[MyWallViewController class]]) {
            [vc removeFromParentViewController];
            AddOrderViewController *addOrder = [[AddOrderViewController alloc] init];
//            addOrder.selectCouponWashDic = dic;
            [self.navigationController pushViewController:addOrder animated:YES];
            return;
        }
    }
}

@end
