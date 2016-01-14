//
//  PayTableViewController.m
//  XBB
//
//  Created by Apple on 15/9/5.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "PayTableViewController.h"
#import "RechargeHelper.h"
#import "UserObj.h"
#import "CarInfo.h"
#import "XBBListHeadLabel.h"
#import "AddOrderTableViewCell.h"
#import "AddOrderDetailTableViewCell.h"
#import "XBBOrderInfoViewController.h"


@interface PayTableViewController () <UIActionSheetDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UIView *barView;
    XBBListHeadLabel *priceTotalTitle;
    float selectAllPrice;
    float coupousPrice;
    BOOL isFirstCom;
}

@property (strong, nonatomic) NSArray *priceArr;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (strong, nonatomic) UIImageView *selectedImgView;
@property (assign, nonatomic) NSInteger payType;//1支付宝
@property (nonatomic, assign) BOOL isDownOrder; // 是否下单
@property (nonatomic, strong) UITableView *tableView;

@end


static NSString *identifier = @"titcell";
static NSString *identifier_2 = @"tit1cell";

@implementation PayTableViewController


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        return;
    }

    NSMutableDictionary *orderDic = [NSMutableDictionary dictionaryWithDictionary:self.dic_prama];
    // 下单时间
    
    NSDate *date = [NSDate date];
    NSString *currentDateStr = [NSString stringWithFormat:@"%lf",[date timeIntervalSince1970]] ;
    [orderDic setObject:currentDateStr?currentDateStr:@"" forKey:@"day"];
    
    if (buttonIndex==0) {
        [SVProgressHUD show];
        [NetworkHelper postWithAPI:OrderInsert_API parameter:orderDic successBlock:^(id response) {
            if ([response[@"code"] integerValue] == 1) {
                self.orderNO = [[response objectForKey:@"result"] objectForKey:@"order_num"];
                self.orderName = response[@"result"][@"order_name"];
                selectAllPrice = [response[@"result"][@"total_price"] doubleValue];
                self.orderId = [NSString stringWithFormat:@"%@", response[@"result"][@"id"]];
                [SVProgressHUD showSuccessWithStatus:@"下单成功"];
                
                if (selectAllPrice == 0) {
                    [SVProgressHUD show];
                    [NetworkHelper postWithAPI:XBB_Zone_Pay parameter:@{@"uid":[[UserObj shareInstance] uid],@"orderid":self.orderId} successBlock:^(id response) {
                        DLog(@"%@",response)
                        
                        if ([response[@"code"] integerValue] == 1) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRecharge object:nil];
                            [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
                        }else
                        {
                            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                        }
                        
                    } failBlock:^(NSError *error) {
                        [SVProgressHUD dismiss];
                    }];
                    return;
                }
                [self toPay];
                self.isDownOrder = YES;
                
            } else {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"下单失败"];
        }];
    }
    
}


#pragma mark views
- (void)addtabview
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64., XBB_Screen_width, XBB_Screen_height-64.-44.)];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddOrderTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:identifier_2];
    
    self.tableView.separatorColor = kUIColorFromRGB(0xdddddd);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


- (void)initUI
{
    
    [self setNavigationBarControl];
    [self addTabBar];
    [self addtabview];
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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"订单支付"];
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
- (void)addTabBar
{
    barView = [[UIView alloc] initWithFrame:CGRectMake(0, XBB_Screen_height-44., XBB_Screen_width, 44.)];
    [self.view addSubview:barView];
    barView.backgroundColor = XBB_Bg_Color;
    barView.layer.borderWidth = 0.5;
    barView.layer.borderColor = XBB_NavBar_Color.CGColor;
    
    priceTotalTitle = [[XBBListHeadLabel alloc] initWithFrame:CGRectMake(0, 0, (XBB_Screen_width/3)*2 , barView.bounds.size.height)];
    [priceTotalTitle setTextColor:XBB_NavBar_Color];
    [priceTotalTitle setFont:[UIFont boldSystemFontOfSize:16.]];
    [barView addSubview:priceTotalTitle];
    [priceTotalTitle setTextAlignment:NSTextAlignmentCenter];
    [self addAllPrice];
    priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",selectAllPrice>0?selectAllPrice:0.00];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width- XBB_Screen_width/3, 0, XBB_Screen_width/3, barView.bounds.size.height)];
    [button addTarget:self action:@selector(submitPayOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = XBB_NavBar_Color;
    [button setTitle:@"支付订单" forState:UIControlStateNormal];
    [button setTitleColor:XBB_Bg_Color forState:UIControlStateNormal];
    [barView addSubview:button];
    
    
    CGRect frame = self.tableView.frame;
    frame.size.height = XBB_Screen_height - 64 - 44.;
    self.tableView.frame = frame;
    
}




- (void)addAllPrice
{
    selectAllPrice = 0;
    for (NSDictionary *dic in self.pro_Dics) {
        selectAllPrice += [dic[@"p_price"] floatValue];
    }
    if (self.couponprice == 0) {
          priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",selectAllPrice - self.couponprice];
    }else
    {
        NSString *strings = [NSString stringWithFormat:@"已抵扣: ¥%.2f    合计 :¥%.2f",self.couponprice,selectAllPrice - self.couponprice];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strings];
        [str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.],NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, 14)];
        [str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.]} range:NSMakeRange(14, [strings length]-14)];
        priceTotalTitle.attributedText = str;
        
    }
    
    
  
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    isFirstCom = YES;
    _payType = 1;
    [self initUI];
    // 存在订单号
    if (self.orderNO && self.orderId) {
        [NetworkHelper postWithAPI:OrderSelect_detail_API parameter:@{@"orderid":self.orderId} successBlock:^(id response) {
            if ([response[@"code"] integerValue] == 1) {
                self.location = response[@"result"][@"location"];
                self.planTime = response[@"result"][@"servicetime"];
                NSArray *proArr = response[@"result"][@"prolist"];
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dci in proArr) {
                    NSDictionary *dic_1 = @{@"p_info":dci[@"p_name"],@"p_price":dci[@"price"]};
                    [arr addObject:dic_1];
                }
                self.pro_Dics = [arr copy];
                [self addAllPrice];
                [self.tableView reloadData];
             
            }else
            {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            self.tableView.alpha = 0;
        }];
    }else
    {
        [self addAllPrice];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOfPay:) name:NotificationRecharge object:nil];
    }
    
    
    self.orderNameLabel.text = self.orderName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", @(selectAllPrice)];
    _selectedImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xbb_168"]];
    if (self.orderNO)
    {
        self.isDownOrder = YES;
    }
    else
    {
        self.isDownOrder = NO;
    }
}

- (void)handleOfPay:(NSNotification *)sender {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RechargeResultObject *result = sender.object;
        
        if (selectAllPrice == 0) {
            XBBOrderInfoViewController *info = [[XBBOrderInfoViewController alloc] init];
            info.isPayBack = YES;
            info.pageController = 1;
            info.navigationTitle = @"支付成功";
            info.orderid = self.orderId;
            [self.navigationController pushViewController:info animated:YES];
            return ;
        }
        
        
        if (result.isSuccessful) {
            if (self.isRecharge == NO){
                XBBOrderInfoViewController *info = [[XBBOrderInfoViewController alloc] init];
                info.isPayBack = YES;
                info.pageController = 1;
                info.navigationTitle = @"支付成功";
                info.orderid = self.orderId;
                [self.navigationController pushViewController:info animated:YES];
            }
            else {
                [SVProgressHUD showSuccessWithStatus:@"充值成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMoneyUpdate object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backViewController:(id)sender {
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:NSClassFromString(@"PayCallbackViewController")]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
        {
            return self.pro_Dics.count+1;
        }
            break;
        case 1:
        {
            return 1;
        }
          
        case 2:
        {
            return 3;
        }
        case 3:
        {
            return 3;
        }
        default:
            break;
    }
    
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AddOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[AddOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.tag = 1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.section) {
            case 0:
            {
                cell.titleLabel.text = @"订单内容";
                cell.headImageView.image = [UIImage imageNamed:@"01我的订单"];
                
                _selectedImgView.alpha = 0;
            }
                break;
                
            case 1:
            {
                cell.titleLabel.text = @"服务时间";
                if ([self.planTime length] == 0 || self.planTime==nil) {
                    cell.detailLabel.text = @"即刻上门";
                }else
                {
                    cell.detailLabel.text = self.planTime;
                }
                cell.headImageView.image = [UIImage imageNamed:@"01时间"];
                _selectedImgView.alpha = 0;
                
            }
                break;

                
            case 2:
            {
                cell.headImageView.image = [UIImage imageNamed:@"car5"];
                cell.titleLabel.text = @"车辆信息";
                _selectedImgView.alpha = 0;
            }
                break;
                
            case 3:
            {
                cell.headImageView.image = [UIImage imageNamed:@"01用户信息"];
                cell.titleLabel.text = @"用户信息";
                _selectedImgView.alpha = 0;
            }
                break;
                
            case 4:
            {
                if (isFirstCom) {
                    isFirstCom = NO;
                    _selectedImgView.frame = CGRectMake(self.view.frame.size.width - 15 - _selectedImgView.frame.size.width, cell.frame.size.height * 0.5 - _selectedImgView.frame.size.height * 0.5, _selectedImgView.frame.size.width, _selectedImgView.frame.size.height);
                    [cell.contentView addSubview:_selectedImgView];
                    _selectedImgView.alpha = 1;
                    _payType = indexPath.row + 1;
                    
                }
                if (_payType == 1) {
                    _selectedImgView.alpha = 1;
                    cell.tag = 2;

                }else
                {
                    _selectedImgView.alpha = 0;
                    cell.tag = 1;
                }
                cell.titleLabel.text = @"支付宝";
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.headImageView.image = [UIImage imageNamed:@"01支付宝"]; 
            }
                break;
            default:
                break;
        }
        if (indexPath.section == 1) {
            cell.detailLabel.hidden = NO;
        }else
        {
            cell.detailLabel.hidden = YES;
        }
        
        cell.indicationImage.hidden = YES;
       
        return cell;
    }
    
    
    AddOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_2];
    
    if (cell == nil) {
        cell = [[AddOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_2];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = 1;
    
    if (indexPath.section == 0) {
        cell.price2Label.hidden = NO;
        cell.titleLabel.hidden = YES;
        cell.priceLabel.hidden = YES;
        cell.selectImageView.hidden = YES;
        cell.addressLabel.hidden = NO;
        
    }else
    {
        cell.price2Label.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.priceLabel.hidden = YES;
        cell.selectImageView.hidden = YES;
        cell.addressLabel.hidden = NO;
    }
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row != 0) {
                if (self.pro_Dics) {
                    NSDictionary *dic = self.pro_Dics[(indexPath.row-1)];
                    DLog(@"%@",dic);
                    cell.addressLabel.text = dic[@"p_info"];
                    NSString *string = dic[@"p_price"];
                    DLog(@"%@",string);
                    cell.price2Label.text = [NSString stringWithFormat:@"¥ %.2f" ,[dic[@"p_price"] floatValue]];
                }
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 1:
                {
                    MyCarModel *model = [[UserObj shareInstance] carModel];
                    cell.addressLabel.text = [NSString stringWithFormat:@"%@  %@  %@  %@",model.c_brand?model.c_brand:@"",model.typeString?model.typeString :@"",model.c_plate_num?model.c_plate_num:@"",model.c_color?model.c_color:@""];
                    
                    
                }
                    break;
                case 2:
                {
                    cell.addressLabel.text = self.location;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 3:
        {
            switch (indexPath.row) {
                case 1:
                {
                    cell.addressLabel.text = [[UserObj shareInstance] uname];
                }
                    break;
                case 2:
                {
                    cell.addressLabel.text = [[UserObj shareInstance] iphone];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
            
        default:
            break;
    }
    
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
    } else if (indexPath.section == 4) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        _selectedImgView.frame = CGRectMake(self.view.frame.size.width - 15 - _selectedImgView.frame.size.width, cell.frame.size.height * 0.5 - _selectedImgView.frame.size.height * 0.5, _selectedImgView.frame.size.width, _selectedImgView.frame.size.height);
        [cell.contentView addSubview:_selectedImgView];
        if (cell.tag == 1) {
            cell.tag = 2;
            _selectedImgView.alpha = 1;
            _payType = indexPath.row + 1;
            
        }else
        {
            _selectedImgView.alpha = 0;
            _payType = 0;
            cell.tag = 1;
        }
        
        if (indexPath.row == 0) {
        } else {
            [SVProgressHUD showErrorWithStatus:@"暂未开通"];
        }
    }
}

- (IBAction)submitPayOnTouch:(id)sender {
    
    if (self.isDownOrder) {
        if (_payType == 1) {
            [self toPay];
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
        }
    }
    else
    {
        if (_payType == 1) {
            
            UIActionSheet *actionSh = [[UIActionSheet alloc] initWithTitle:@"确认支付" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [actionSh showInView:self.view];

        } else {
            [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
        }
    }
}

- (void)toPay
{
    if (self.isDownOrder) {
        if (self.isRecharge == NO) {
            [RechargeHelper setAliPayNotifyURLString:[NSString stringWithFormat:@"%@?recharge_type=%@", Notify_AlipayCallback_Url, @"1"]];
            [[RechargeHelper defaultRechargeHelper] payAliWithMoney:selectAllPrice orderNO:self.orderNO productTitle:self.orderName productDescription:self.orderName];
        } else {
            [NetworkHelper postWithAPI:API_Recharge parameter:@{@"uid": [UserObj shareInstance].uid, @"money": [NSString stringWithFormat:@"%.2f",selectAllPrice]} successBlock:^(id response) {
                if ([response[@"code"] integerValue] == 1) {
                    NSString *orderNO = [[response objectForKey:@"result"] objectForKey:@"recharge_num"];
                    NSString *orderName = response[@"result"][@"recharge_name"];
                    double price = [response[@"result"][@"recharge_price"] doubleValue];
                    [[RechargeHelper defaultRechargeHelper] payAliWithMoney:price orderNO:orderNO productTitle:orderName productDescription:orderName];
                } else {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
            } failBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"充值失败"];
            }];
        }
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:1.];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.isRecharge == NO) {
                    [RechargeHelper setAliPayNotifyURLString:[NSString stringWithFormat:@"%@?recharge_type=%@", Notify_AlipayCallback_Url, @"1"]];
                    double price = selectAllPrice;
                    [[RechargeHelper defaultRechargeHelper] payAliWithMoney:price orderNO:self.orderNO productTitle:self.orderName productDescription:self.orderName];
                } else {
                    [NetworkHelper postWithAPI:API_Recharge parameter:@{@"uid": [UserObj shareInstance].uid, @"money": self.priceLabel.text} successBlock:^(id response) {
                        if ([response[@"code"] integerValue] == 1) {
                            NSString *orderNO = [[response objectForKey:@"result"] objectForKey:@"recharge_num"];
                            NSString *orderName = response[@"result"][@"recharge_name"];
                            double price = [response[@"result"][@"recharge_price"] doubleValue];
                            
                            [[RechargeHelper defaultRechargeHelper] payAliWithMoney:price orderNO:orderNO productTitle:orderName productDescription:orderName];
                        } else {
                            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                        }
                    } failBlock:^(NSError *error) {
                        [SVProgressHUD showErrorWithStatus:@"充值失败"];
                    }];
                }
                
            });
        });
    }
    
}





@end
