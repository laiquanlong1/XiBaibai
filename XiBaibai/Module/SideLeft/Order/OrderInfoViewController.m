//
//  OrderInfoViewController.m
//  XBB
//
//  Created by mazi on 15/9/5.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "StarView.h"
#import "DMLineView.h"
#import "PayTableViewController.h"
#import "MyCarModel.h"



@interface OrderInfoViewController (){
    UIView *viewOrderPay;
    UIScrollView *mainScrollView;
}

@property (strong,nonatomic) UILabel *labTitle;
@property (strong,nonatomic) UILabel *labMoney;
@property (strong,nonatomic) UILabel *labTimeX;
@property (strong,nonatomic) UILabel *labAddressX;
@property (strong,nonatomic) UILabel *labModelX;
@property (strong,nonatomic) UILabel *labOrder_numX;
@property (strong,nonatomic) UILabel *labOkPay;

@property (strong,nonatomic) UIImageView *imgHeadView;
@property (strong,nonatomic) UILabel *labName;
@property (strong,nonatomic) UILabel *labNumber;

@property (strong,nonatomic) StarView *starView;
@property (strong,nonatomic) UILabel *labFen;

@property (strong,nonatomic) UIButton *btnAddOrderAgain;




@property (nonatomic, strong) NSDictionary *orderDitailDic;// 订单详细信息字典


@property (nonatomic, strong) NSMutableSet *proSet; // 产品数组

@property (nonatomic, copy) NSDictionary *washWay; // 洗车产品

@end

@implementation OrderInfoViewController

- (void)initView{
    self.view.backgroundColor = kUIColorFromRGB(0xf6f5fa);
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"订单详情";
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
    
//    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    mainScrollView = [UIScrollView new];
    mainScrollView.scrollEnabled = YES;
    mainScrollView.backgroundColor = kUIColorFromRGB(0xf6f5fa);
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *viewInfo = [UIView new];
    viewInfo.layer.borderColor = kUIColorFromRGB(0xd9d9d9).CGColor;
    viewInfo.layer.borderWidth = 0.5;
    viewInfo.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    [mainScrollView addSubview:viewInfo];
    [viewInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.equalTo(mainScrollView);
        make.height.mas_equalTo(mainScrollView);
    }];
    
//    self.orderinfoview = [OrderInfoView initOrderInfoView];
//    [viewInfo addSubview:self.orderinfoview];
    
    UIView *viewOrderInfo = [UIView new];
    [viewInfo addSubview:viewOrderInfo];
    [viewOrderInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(viewInfo.mas_width);
        make.height.mas_equalTo(155);
        make.top.mas_equalTo(viewInfo.mas_top).mas_offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UIImageView *imgViewtitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_45.png"]];
    [viewOrderInfo addSubview:imgViewtitle];
    [imgViewtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(20);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(30);
        
    }];
    
    self.labTitle = [UILabel new];
    self.labTitle.textColor = kUIColorFromRGB(0x1a1a1a);
    self.labTitle.text = @"上门洗车";
    [viewOrderInfo addSubview:self.labTitle];
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(55);
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(20);
    }];
    
    self.labMoney = [UILabel new];
    self.labMoney.text = @"￥30";
    self.labMoney.textColor = kUIColorFromRGB(0xde3635);
    [viewOrderInfo addSubview:self.labMoney];
    [self.labMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(20);
        make.right.mas_equalTo(viewOrderInfo.mas_right).mas_offset(-20);
    }];
    
    DMLineView *lineView = [[DMLineView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.lineWidth = 1;
    lineView.lineColor = kUIColorFromRGB(0xcccccc);
    lineView.dottedGap = 2;
    lineView.dotted = YES;
    [viewOrderInfo addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
        make.right.mas_equalTo(viewOrderInfo.mas_right).mas_offset(-20);
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(50);
        make.height.mas_equalTo(1);
    }];

    
    UILabel *labTime = [UILabel new];
    labTime.font = [UIFont systemFontOfSize:14];
    labTime.textColor = kUIColorFromRGB(0xb7b7b7);
    labTime.text = @"时间：";
    [viewOrderInfo addSubview:labTime];
    [labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(65);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
    }];
    
    self.labTimeX = [UILabel new];
    self.labTimeX.font = [UIFont systemFontOfSize:14];
    self.labTimeX.textColor = kUIColorFromRGB(0x1a1a1a);
    self.labTimeX.text = @"2015年8月26日 13：00-14：00";
    [viewOrderInfo addSubview:self.labTimeX];
    [self.labTimeX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(65);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(65);
    }];
    
    UILabel *labAddress = [UILabel new];
    labAddress.font = [UIFont systemFontOfSize:14];
    labAddress.textColor = kUIColorFromRGB(0xb7b7b7);
    labAddress.text = @"地点：";
    [viewOrderInfo addSubview:labAddress];
    [labAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(95);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
    }];
    
    self.labAddressX = [UILabel new];
    self.labAddressX.font = [UIFont systemFontOfSize:14];
    self.labAddressX.textColor = kUIColorFromRGB(0x1a1a1a);
    self.labAddressX.text = @"四川省成都市高新区天府三街香年广场";
    [viewOrderInfo addSubview:self.labAddressX];
    [self.labAddressX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(95);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(65);
    }];
    
    UILabel *labModel = [UILabel new];
    labModel.font = [UIFont systemFontOfSize:14];
    labModel.textColor = kUIColorFromRGB(0xb7b7b7);
    labModel.text = @"型号：";
    [viewOrderInfo addSubview:labModel];
    [labModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(125);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
    }];
    
    self.labModelX = [UILabel new];
    self.labModelX.font = [UIFont systemFontOfSize:14];
    self.labModelX.textColor = kUIColorFromRGB(0x1a1a1a);
    self.labModelX.text = @"川A07D11 标志508 银灰";
    [viewOrderInfo addSubview:self.labModelX];
    [self.labModelX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(125);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(65);
    }];
    

    DMLineView *lineView2 = [[DMLineView alloc] init];
    lineView2.backgroundColor = [UIColor whiteColor];
    lineView2.lineWidth = 1;
    lineView2.lineColor = kUIColorFromRGB(0xcccccc);
    lineView2.dottedGap = 2;
    lineView2.dotted = YES;
    [viewOrderInfo addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
        make.right.mas_equalTo(viewOrderInfo.mas_right).mas_offset(-20);
        make.bottom.mas_equalTo(viewOrderInfo.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    
    viewOrderPay = [UIView new];
//  viewOrderPay.backgroundColor = [UIColor yellowColor];
    [viewInfo addSubview:viewOrderPay];
    [viewOrderPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(viewInfo.mas_width);
        make.height.mas_equalTo(200);
        make.top.mas_equalTo(viewInfo.mas_top).mas_offset(155);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UILabel *ordernum = [UILabel new];
    ordernum.textColor = kUIColorFromRGB(0xb7b7b7);
    ordernum.text = @"订单编号：";
    ordernum.font = [UIFont systemFontOfSize:14];
    [viewOrderPay addSubview:ordernum];
    [ordernum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderPay.mas_top).mas_offset(15);
        make.left.mas_equalTo(viewOrderPay.mas_left).mas_offset(20);
    }];
    
    self.labOrder_numX = [UILabel new];
    self.labOrder_numX.font = [UIFont systemFontOfSize:14];
    self.labOrder_numX.textColor = kUIColorFromRGB(0x363636);
    self.labOrder_numX.text = @"0012346579";
    [viewOrderPay addSubview:self.labOrder_numX];
    [self.labOrder_numX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderPay.mas_top).mas_offset(15);
        make.left.mas_equalTo(ordernum.mas_right).mas_offset(0);
    }];
    
    self.labOkPay = [UILabel new];
    self.labOkPay.textColor = kUIColorFromRGB(0x191919);
    self.labOkPay.text = [NSString stringWithFormat:@"已支付"];
    self.labOkPay.font = [UIFont systemFontOfSize:14];
    self.labOkPay.textAlignment = NSTextAlignmentRight;
    [viewOrderPay addSubview:self.labOkPay];
    [self.labOkPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderPay.mas_top).mas_offset(15);
        make.right.mas_equalTo(viewOrderPay.mas_right).mas_offset(-20);
    }];
    
    DMLineView *lineView3 = [[DMLineView alloc] init];
    lineView3.backgroundColor = [UIColor whiteColor];
    lineView3.lineWidth = 1;
    lineView3.lineColor = kUIColorFromRGB(0xcccccc);
    lineView3.dottedGap = 2;
    lineView3.dotted = YES;
    [viewOrderPay addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewOrderPay.mas_left).mas_offset(20);
        make.right.mas_equalTo(viewOrderPay.mas_right).mas_offset(-20);
        make.top.mas_equalTo(viewOrderPay.mas_top).mas_offset(45);
        make.height.mas_equalTo(1);
    }];
    
    self.imgHeadView = [UIImageView new];
    [self.imgHeadView.layer setCornerRadius:30];
    [viewOrderPay addSubview:self.imgHeadView];
    self.imgHeadView.image = [UIImage imageNamed:@"xi1.png"];
    [self.imgHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(65);
    }];
    
    self.labName = [UILabel new];
    self.labName.text = @"张师傅";
    self.labName.textColor = kUIColorFromRGB(0x6a6a6a);
    [viewOrderPay addSubview:self.labName];
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderPay.mas_top).mas_offset(75);
        make.left.mas_equalTo(self.imgHeadView.mas_right).mas_equalTo(10);
    }];
    
    self.labNumber = [UILabel new];
    self.labNumber.text = @"00000014";
    self.labNumber.textColor = kUIColorFromRGB(0xb7b7b7);
    [viewOrderPay addSubview:self.labNumber];
    [self.labNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderPay.mas_top).mas_offset(95);
        make.left.mas_equalTo(self.imgHeadView.mas_right).mas_equalTo(10);
    }];
    
    
    self.starView = [StarView starView];
    self.starView.score = 3.5;
    [viewOrderPay addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(viewOrderPay.mas_right).mas_offset(-30);
        make.top.mas_equalTo(viewOrderPay.mas_top).mas_offset(90);
    }];
    
    self.labFen = [UILabel new];
    self.labFen.text = @"￥3.5";
    self.labFen.font = [UIFont systemFontOfSize:15];
    self.labFen.textColor = kUIColorFromRGB(0x7f7f7f);
    [viewOrderPay addSubview:self.labFen];
    [self.labFen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderPay.mas_top).mas_offset(88);
        make.right.mas_equalTo(viewOrderPay.mas_right).mas_offset(-20);
    }];
    
    self.btnAddOrderAgain = [UIButton new];
    self.btnAddOrderAgain.backgroundColor = kUIColorFromRGB(0x25c2a7);
    [self.btnAddOrderAgain setTitle:@"再来一单" forState:UIControlStateNormal];
    [viewOrderPay addSubview:self.btnAddOrderAgain];
    [self.btnAddOrderAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewOrderPay.mas_left).mas_offset(20);
        make.right.mas_equalTo(viewOrderPay.mas_right).mas_offset(-20);
        make.bottom.mas_equalTo(viewOrderPay.mas_bottom).mas_offset(0);
        make.height.mas_offset(50);
    }];
    
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(1);
    }];
    mainScrollView.hidden = YES;
}

// 获取洗车方式
- (void)fetchProSelectWashWay
{
    
    [NetworkHelper postWithAPI:API_Washinfo parameter:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *responseDic = response;
           
                if (responseDic!= nil) {
                    NSDictionary *resultDic = responseDic[@"result"];
                    if (responseDic != nil) {
                        if (_proSet == nil) {_proSet = [NSMutableSet set];}
                        NSArray *arr = resultDic[@"washinfo"];
                        NSString *p_idsString = self.orderDitailDic[@"p_ids"];
                        NSArray *p_idsArray = [p_idsString componentsSeparatedByString:@","];
                        // 列表
            
                        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary *dic = obj;
                            for (NSString *st in p_idsArray) {
                                if ([dic[@"id"] integerValue] == [st integerValue]) {
                                    [_proSet addObject:dic];
                                }
                            }
                        }];
                    }
                }
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取洗车方式网络错误"];
    }];
}

// 获取产品
- (void)fetchProArr
{
    [SVProgressHUD show];  // 展示进度条
    [NetworkHelper postWithAPI:API_SelectWax parameter:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [response copy];
        if (dic) {
            if ([response[@"code"] integerValue] == 1) {
                
                DLog(@"%@",dic);
                
                [SVProgressHUD dismiss];
                // 获取到字典
                NSDictionary *resultDic = dic[@"result"];
               
            
                
                if (!_proSet) {
                    _proSet = [NSMutableSet set]; // 产品数组
                }
                // 产品信息
                if (!self.orderDitailDic) {
                    [SVProgressHUD showErrorWithStatus:@"获取信息失败"];
                    return;
                }
                NSString *p_idsString = self.orderDitailDic[@"p_ids"];
                NSArray *p_idsArray = [p_idsString componentsSeparatedByString:@","];
                
                // 列表
                NSArray *list = resultDic[@"list"];
                [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dic = obj;
                    for (NSString *st in p_idsArray) {
                        if ([dic[@"id"] integerValue] == [st integerValue]) {
                            [_proSet addObject:dic];
                        }
                    }
                }];
                
                // 美容
                NSArray *wax = resultDic[@"wax"][@"result"];
                [wax enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dic = obj;
                    for (NSString *st in p_idsArray) {
                        if ([dic[@"id"] integerValue] == [st integerValue]) {
                            [_proSet addObject:dic];
                        }
                    }
                }];
                
                
                // 不必洗
                NSArray *noWash = resultDic[@"notwash"][@"result"];
                [noWash enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dic = obj;
                    for (NSString *st in p_idsArray) {
                        if ([dic[@"id"] integerValue] == [st integerValue]) {
                            [_proSet addObject:dic];
                        }
                    }
                }];
                
                
                
                [self fetchProSelectWashWay];
                
            } else {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
    
}



- (void)initData{
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:OrderSelect_detail_API parameter:@{@"order_id":self.order_id} successBlock:^(id response) {
        NSLog(@"---%@",response);
        if (response == nil) {
            [SVProgressHUD showErrorWithStatus:@"获取详情失败"];
            return;
        }
        
        if ([response[@"code"] integerValue] == 1) {
            self.orderDitailDic = response[@"result"];
            [self fetchProArr]; // 获取产品信息
            [SVProgressHUD dismiss];
            mainScrollView.hidden = NO;
            NSDictionary *orderDetail = [[NSDictionary alloc] initWithDictionary:[response objectForKey:@"result"]];
            self.labTitle.text = orderDetail[@"order_name"];
//            self.labTimeX.text = orderDetail[@"p_order_time"];
            self.labAddressX.text = orderDetail[@"location"];
            self.labModelX.text = [NSString stringWithFormat:@"%@ %@ %@", orderDetail[@"c_brand"], orderDetail[@"c_color"], orderDetail[@"c_plate_num"]];
            self.labOrder_numX.text = orderDetail[@"order_num"];
            self.labMoney.text = [NSString stringWithFormat:@"￥%@",orderDetail[@"total_price"]];
            self.labOkPay.text = [NSString stringWithFormat:@"已支付"];
            NSString *str=orderDetail[@"p_order_time"];//时间戳
            NSTimeInterval time=[str doubleValue];//+28800因为时差问题要加8小时 == 28800 sec
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            NSLog(@"date:%@",[detaildate description]);
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
            self.labTimeX.text = currentDateStr;
            NSLog(@"。。。。。%ld",[orderDetail[@"order_state"] integerValue]);
            if ([orderDetail[@"order_state"] integerValue]==0 ||
                [orderDetail[@"order_state"] integerValue]==1 ||
                [orderDetail[@"order_state"] integerValue] ==2 ||
                [orderDetail[@"order_state"] integerValue] ==7 ) {
                [viewOrderPay mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(100);
                }];
                [mainScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                    //                 make.edges.equalTo(self.view);
                    make.bottom.mas_equalTo(viewOrderPay.mas_bottom).mas_offset(150);
                }];
                [self.btnAddOrderAgain setTitle:@"进行中" forState:UIControlStateNormal];
                self.btnAddOrderAgain.backgroundColor = kUIColorFromRGB(0xcccccc);
                
                if ([orderDetail[@"order_state"] integerValue]==0 ) {
                    self.labOkPay.text = @"未付款";
                    self.labOkPay.textColor = [UIColor redColor];
                    [self.btnAddOrderAgain setTitle:@"去支付" forState:UIControlStateNormal];
                    [self.btnAddOrderAgain addTarget:self action:@selector(gopay) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.labFen removeFromSuperview];
                [self.starView removeFromSuperview];
                [self.labName removeFromSuperview];
                [self.labNumber removeFromSuperview];
                [self.imgHeadView removeFromSuperview];
                if ([orderDetail[@"order_state"] integerValue]==0 ||
                    [orderDetail[@"order_state"] integerValue]==1 ||
                    [orderDetail[@"order_state"] integerValue] ==2  ){
                    
                    
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            mainScrollView.hidden = YES;
        }
        
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
        mainScrollView.hidden = YES;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fanhui{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:NSClassFromString(@"PayCallbackViewController")]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

//去付款
- (void)gopay{
    
    if (self.orderDitailDic) {
      
        // 获取车类型
        NSInteger cartype = [self.orderDitailDic[@"c_type"] integerValue];

        // 获取车信息
        
        
        MyCarModel *carmodel = [[MyCarModel alloc] init];
        carmodel.c_brand = self.orderDitailDic[@"c_brand"];
        carmodel.c_color = self.orderDitailDic[@"c_color"];
        carmodel.carId = [self.orderDitailDic[@"c_ids"] integerValue];
        carmodel.c_plate_num = self.orderDitailDic[@"c_plate_num"];
        carmodel.c_type = cartype;
        
        
        // 获取产品信息
        NSMutableArray *proArr = [NSMutableArray array];
        if (self.proSet) {
            [self.proSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
                [proArr addObject:obj];
            }];
        }
        
        PayTableViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayTableViewController"];
        viewController.orderNO = self.labOrder_numX.text;
        viewController.price = [[self.labMoney.text substringFromIndex:1] doubleValue];
        viewController.orderName = self.labTitle.text;
        
        viewController.location = self.orderDitailDic[@"location"];
        viewController.carType = cartype;
        viewController.pro_Dics = proArr;
        viewController.carModels =@[ carmodel];
        
        
        [self.navigationController pushViewController:viewController animated:YES];
      
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"获取支付信息失败"];
    }

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
