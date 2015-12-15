//
//  XBBOrderInfoViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/12/15.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBOrderInfoViewController.h"
#import "UserObj.h"
#import "XBBOrder.h"
#import "MyOrderModel.h"
#import <MJExtension.h>



@interface XBBOrderInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger state;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *prolist;
@property (nonatomic, strong) NSDictionary *washimgDic;
@property (nonatomic, strong) MyOrderModel *feathModel;

@end


static NSString *orderInfo = @"orderInfo";
static NSString *oprationMessage = @"opreationMessage";
static NSString *orderContent = @"orderContent";
static NSString *mycomment = @"mycomment";

@implementation XBBOrderInfoViewController
#pragma datas
- (void)feathOrderInfo
{
    [NetworkHelper postWithAPI:OrderSelect_detail_API parameter:@{@"uid":[[UserObj shareInstance] uid],@"orderid":self.orderid} successBlock:^(id response) {
        DLog(@"%@",response)
        
        if ([response[@"code"] integerValue] == 1) {
            if (response[@"result"]) {
                NSArray *proArray = response[@"result"][@"prolist"];
                if (proArray.count > 0) {
                    NSMutableArray *pros = [NSMutableArray array];
                    for (NSDictionary *dic in proArray) {
                        XBBOrder *order = [[XBBOrder alloc] init];
                        order.price = [dic[@"price"] floatValue];
                        order.title = dic[@"p_name"];
                        order.xbbid = dic[@"id"];
                        [pros addObject:order];
                    }
                    self.prolist = pros;
                }
                NSDictionary *washdic = response[@"result"][@"washimg"];
                self.washimgDic = washdic;
                
                
                [MyOrderModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"order_id": @"id"};
                }];
                MyOrderModel *model = [MyOrderModel objectWithKeyValues:response[@"result"]];
                self.feathModel = model;
                state = [response[@"result"][@"order_state"] integerValue];
                [self initDatas];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
        
        
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

#pragma mark UI


/**
 * 0未付款
 * 1派单中
 * 2已派单
 * 3在路上
 * 4进行中
 * 5未评价
 * 6已评价
 * 7已取消
 */

- (void)initDatas
{
    switch (state) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            
        }
            break;
        case 7:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self feathOrderInfo];
    
}

- (void)initUI
{
    [self setNavigationBarControl];
    [self addTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setNavigationBarControl
{
    self.backgroundScrollView.alpha = 0.;
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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"我的订单"];
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
- (void)addTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XBB_Screen_width, XBB_Screen_height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = XBB_Bg_Color;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark action


- (IBAction)backViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}










@end
