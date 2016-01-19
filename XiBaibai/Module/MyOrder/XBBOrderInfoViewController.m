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
#import "XBBOrderInfoTwoTableViewCell.h"
#import "XBBOrderInfoOneCell.h"
#import "RechargeHelper.h"
#import "XBBOrderInfoCommentTableViewCell.h"
#import "MyOrderViewController.h"
#import "CommentTableViewCell.h"
#import "StarView.h"
#import "XBBCommentViewController.h"
#import "XBBSelectStateView.h"
#import "XBBOrderStateTableViewCell.h"


@interface XBBOrderInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,XBBSelectStateViewDelegate>
{
    NSInteger state;
    UIView *backView;
    float coupon_price;
    float total_price;
    float actually_price;
    UIButton *backButton;
    NSString *empPhone;
    XBBSelectStateView *_selectStateView;
    UIImageView *backlineImageView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *prolist;
@property (nonatomic, strong) NSDictionary *washimgDic;
@property (nonatomic, strong) MyOrderModel *feathModel;


@property (nonatomic, strong) NSMutableArray *onsectionArray; // pros
@property (nonatomic, strong) NSMutableArray *twoSectionArray; // message
@property (nonatomic, strong) NSMutableArray *empArrays; //emp
@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, strong) NSMutableArray *timesArray; // 时间轴数组




@end

static NSString *titleCell = @"titleCell";
static NSString *orderInfo = @"orderInfo";
static NSString *mycomment = @"mycomment";
static NSString *hascomment = @"hascomment";
static NSString *stateCell = @"cell_1";

@implementation XBBOrderInfoViewController

- (void)agoTableView
{
    [self addTableView];
    [self initTabView];
    if (self.isPayBack) {
        state = 1;
    }
    if (state==0) {
         self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y, XBB_Screen_width, self.tableView.frame.size.height - 66.);
        backView.alpha = 1;
    }
   
    
}

#pragma datas

- (void)fetchTimeState
{
    [NetworkHelper postWithAPI:API_TimeAxis parameter:@{@"orderid":self.orderid} successBlock:^(id response) {
        DLog(@"%@",response)
        if ([response[@"code"] integerValue] == 1) {
            self.timesArray = [response[@"result"] mutableCopy];
        }else
        {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error description]];
    }];
}


- (void)feathOrderInfo
{
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:OrderSelect_detail_API parameter:@{@"uid":[[UserObj shareInstance] uid],@"orderid":self.orderid} successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            if (response[@"result"]) {
//                DLog(@"%@",response)
                [MyOrderModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"order_id": @"id"};
                }];
                MyOrderModel *model = [MyOrderModel objectWithKeyValues:response[@"result"]];
                self.feathModel = model;
                total_price = model.totalprice;
                coupon_price = model.coupons_price;
                // 获取产品数组
                NSArray *proArray = response[@"result"][@"prolist"];
//                DLog(@"%@   %ld",proArray,proArray.count)
                state = [response[@"result"][@"order_state"] integerValue];
                
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
                
                // 区域1
                NSMutableArray *arr_0 = [NSMutableArray array];
                XBBOrder *order = [[XBBOrder alloc] init];
                order.title = @"订单内容";
                [arr_0 addObject:order];
                
                NSMutableArray *oo_o = [NSMutableArray array];
                total_price = 0;
                for (NSDictionary *dic in proArray) {
                    XBBOrder *ooo = [[XBBOrder alloc] init];
                    ooo.title = dic[@"p_name"];
                    ooo.price = [dic[@"price"] floatValue];
                    total_price += ooo.price;
                    ooo.xbbid = dic[@"id"];
                    [arr_0 addObject:ooo];
                    [oo_o addObject:ooo];
                }
                self.prolist = oo_o;
                
                XBBOrder *endOrder = [[XBBOrder alloc] init];
                endOrder.title = @"合计";
                endOrder.price = total_price;
                
                [arr_0 addObject:endOrder];
                self.onsectionArray = arr_0;
                if (coupon_price > 0) {
                    XBBOrder *endOrder_2 = [[XBBOrder alloc] init];
                    endOrder_2.title = @"优惠金额";
                    endOrder_2.price = -coupon_price;
                    [arr_0 addObject:endOrder_2];
                    self.onsectionArray = arr_0;
                }
               
                XBBOrder *endOrder_1 = [[XBBOrder alloc] init];
                if (state == 0) {
                    endOrder_1.title = @"应支付";
                }else
                {
                    endOrder_1.title = @"实际支付";
                }
                if (state == 0) {
                    endOrder_1.price = [model.total_price floatValue]; //actually_price;
                    actually_price = [model.total_price floatValue];

                }else
                {
                    endOrder_1.price = (float)model.pay_num; //actually_price;
                    actually_price = (float)model.pay_num;
                }
                
                [arr_0 addObject:endOrder_1];
                self.onsectionArray = arr_0;
                
                if (state == 3 || state == 4 || state == 5 || state == 6) {
                    
                    NSMutableArray *oper = [NSMutableArray array];
                    XBBOrder *one = [[XBBOrder alloc] init];
                    one.title = @"操作信息";
                    [oper addObject:one];
                    
                    XBBOrder *name = [[XBBOrder alloc] init];
                    name.title = [NSString stringWithFormat:@"技师名字:    %@",model.emp_name?model.emp_name:@"_ _"];
                    name.empPhone = model.emp_iphone;
                    empPhone = model.emp_iphone;
                    [oper addObject:name];
                    self.empArrays = oper;
                }
                
                // 区域2
                NSMutableArray *arr_1 = [NSMutableArray array];
                XBBOrder *order_1 = [[XBBOrder alloc] init];
                order_1.title = @"订单信息";
                [arr_1 addObject:order_1];
                
                XBBOrder *order_1_1 = [[XBBOrder alloc] init];
                order_1_1.title = [NSString stringWithFormat: @"服务时间:    %@",model.servicetime?model.servicetime:@""];
                [arr_1 addObject:order_1_1];
                
                XBBOrder *order_1_2 = [[XBBOrder alloc] init];
                order_1_2.title = [NSString stringWithFormat:@"订单号码:    %@",model.order_num?model.order_num:@""];
                [arr_1 addObject:order_1_2];
                
                XBBOrder *order_1_4 = [[XBBOrder alloc] init];
                order_1_4.title =[NSString stringWithFormat:@"下单时间:    %@", model.p_order_time? model.p_order_time:@""];
                [arr_1 addObject:order_1_4];
                
                if (state != 0) {
                    XBBOrder *order_1_5 = [[XBBOrder alloc] init];
                    order_1_5.title =[NSString stringWithFormat:@"支付方式:    %@", model.pay_type?model.pay_type:@""];
                    [arr_1 addObject:order_1_5];

                }
                XBBOrder *order_1_3 = [[XBBOrder alloc] init];
                order_1_3.title = [NSString stringWithFormat:@"车主名称:    %@",model.uname?model.uname:@""];
                [arr_1 addObject:order_1_3];
                
                XBBOrder *order_1_6 = [[XBBOrder alloc] init];
                order_1_6.title = [NSString stringWithFormat:@"车辆信息:    %@",model.carinfo?model.carinfo:@""];
                [arr_1 addObject:order_1_6];
                
                XBBOrder *order_1_9 = [[XBBOrder alloc] init];
                order_1_9.title = [NSString stringWithFormat:@"车       牌:    %@",model.c_plate_num?model.c_plate_num:@""];
                [arr_1 addObject:order_1_9];
                
                
                XBBOrder *order_1_7 = [[XBBOrder alloc] init];
                order_1_7.title = [NSString stringWithFormat:@"车       型:    %@",model.cartype?model.cartype:@""];
                [arr_1 addObject:order_1_7];
                
                XBBOrder *order_1_8 = [[XBBOrder alloc] init];
                order_1_8.title = [NSString stringWithFormat:@"车辆位置:    %@",model.location?model.location:@""];
                [arr_1 addObject:order_1_8];
                
                self.twoSectionArray = arr_1;

                NSMutableArray *conA = [NSMutableArray array];
                
                
                if (state == 5) {
                    XBBOrder *oder = [[XBBOrder alloc] init];
                    oder.title = @"未评价";
                    [conA addObject:oder];
                    XBBOrder *oder_1 = [[XBBOrder alloc] init];
                    oder_1.title = @"添加评论";
                    [conA addObject:oder_1];
                }else if (state == 6)
                {
                    XBBOrder *oder = [[XBBOrder alloc] init];
                    oder.title = @"我的评价";
                    [conA addObject:oder];
                    
                    XBBOrder *oder_1 = [[XBBOrder alloc] init];
                    oder_1.title = model.user_evaluate;
                    oder_1.star_num = model.order_star;
                    [conA addObject:oder_1];
                    
                    
                }
               self.commentArray = conA;

                [self agoTableView];

                [self.tableView reloadData];
            }
            [SVProgressHUD dismiss];
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

- (void)initUIWithStateNoPay
{
    backView.alpha = 1;
}

- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)upData:(id)sender
{
    [self feathOrderInfo];
    [self fetchTimeState];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self upData:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOfPay:) name:NotificationRecharge object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upData:) name:NotificationOrderListUpdate object:nil] ;
    [self initUI];
}

- (void)initUI
{
    [self setNavigationBarControl];

}

- (void)initTabView
{
    if (self.isPayBack == NO) {
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, XBB_Screen_height-66., XBB_Screen_width, 44.)];
        backView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:backView];
        UIImage *image = [UIImage imageNamed:@"确定"];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20., 0, XBB_Screen_width-40., 44.)];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:@"去支付" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(toPay:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        [self.view bringSubviewToFront:backView];
        backView.alpha = 0.;
    }
    
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
    
    backButton = [[UIButton alloc] init];
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
    
    if (self.isPayBack) {
        backButton.alpha = 0;
    }
    
}
- (void)addTableView
{
    if (!self.isPayBack) {
        _selectStateView = [[XBBSelectStateView alloc] initWithFrame:CGRectMake(0, 64, XBB_Screen_width, 44) withStates:@[@"订单详情",@"订单状态"]];
        _selectStateView.delegate = self;
        [self.view addSubview:_selectStateView];
         self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+47, XBB_Screen_width, XBB_Screen_height-64-47) style:UITableViewStyleGrouped];
        [self.tableView setContentInset:UIEdgeInsetsMake(-40, 0,-30, 0)];
        backlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 0, 3, self.tableView.bounds.size.height)];
        [backlineImageView setContentMode:UIViewContentModeScaleAspectFit];
        [backlineImageView setImage:[UIImage imageNamed:@"xbb_orderStateLine"]];
        UIView *ba = [[UIView alloc] initWithFrame:self.view.bounds];
        self.tableView.backgroundView = ba;
        [self.tableView.backgroundView addSubview:backlineImageView];
    }else
    {
         self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XBB_Screen_width, XBB_Screen_height-64)];
    }
   
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = XBB_Bg_Color;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = XBB_separatorColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBOrderInfoOneCell" bundle:nil] forCellReuseIdentifier:titleCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBOrderInfoTwoTableViewCell" bundle:nil] forCellReuseIdentifier:orderInfo];
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBOrderInfoCommentTableViewCell" bundle:nil] forCellReuseIdentifier:mycomment];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:hascomment];
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBOrderStateTableViewCell" bundle:nil] forCellReuseIdentifier:stateCell];
}
#pragma mark SelectIndexDelegate
- (void)changeSelectIndex:(NSUInteger)index
{
    [self.tableView reloadData];
    DLog(@"%ld   %ld",index,_selectStateView.selectIndex)
}
#pragma mark action

- (IBAction)toBackAction:(id)sender
{
    DLog(@"succesd")
    if (self.pageController == 1) {
        MyOrderViewController *order =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyOrderViewController"];
        order.isBackController = YES;
        [self.navigationController pushViewController:order animated:YES];
    }else  {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self callPhone:empPhone];
    }
}
- (void)callPhone:(NSString *)number
{
    
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@",number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}
- (IBAction)toCallPhone:(id)sender
{
    if (empPhone != NULL) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"联系技师" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"%@",empPhone] otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }
    
}
- (void)handleOfPay:(NSNotification *)sender {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RechargeResultObject *result = sender.object;
        if (result.isSuccessful) {
            self.isPayBack = YES;
            backButton.alpha = 0;
            [self feathOrderInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOrderListUpdate object:@"orderInfo"];
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    });
}

- (IBAction)toCommentButtonAction:(id)sender
{
    XBBCommentViewController *comment = [[XBBCommentViewController alloc] init];
    comment.orderId = self.orderid;
    [self presentViewController:comment animated:YES completion:nil];
}

- (IBAction)toPay:(id)sender
{
    [RechargeHelper setAliPayNotifyURLString:[NSString stringWithFormat:@"%@?recharge_type=%@", Notify_AlipayCallback_Url, @"1"]];
    double price = actually_price;
    [[RechargeHelper defaultRechargeHelper] payAliWithMoney:price orderNO:self.orderNum productTitle:self.orderName  productDescription:self.orderName];
}
- (IBAction)backViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark tableViewDelegate



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    if (self.isPayBack) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = XBB_Bg_Color;
        return view;
    }
    if (_selectStateView.selectIndex == 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = XBB_Bg_Color;
        return view;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = XBB_Bg_Color;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isPayBack) {
        return 6.0;
    }
    if (_selectStateView.selectIndex == 0) {
        return 6.0;
    }
    return 6.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.isPayBack) {
        if (section == 1) {
            return 66.;
        }
    }
    if (_selectStateView.selectIndex == 0) {
        
        
        
        return 0;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.isPayBack) {
        if (section == 1) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XBB_Screen_width, 60.)];
            UIImage *image = [UIImage imageNamed:@"确定"];
            UIButton *bacButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 66/2-10, XBB_Screen_width-40., 44.)];
            [view addSubview:bacButton];
            [bacButton setBackgroundImage:image forState:UIControlStateNormal];
            [bacButton setTitle:@"确定" forState:UIControlStateNormal];
            [bacButton addTarget:self action:@selector(toBackAction:) forControlEvents:UIControlEventTouchUpInside];
            return view;
        }
    }

    if (_selectStateView.selectIndex == 0) {
        
        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isPayBack) {
          return 44.;
   
    }
    if (_selectStateView.selectIndex == 0) {
        if ((state == 5|| state == 6) && indexPath.section == 3 && indexPath.row == 1) {
            
            if (state == 6) {
                return 150;
            }
            return 80;
        }
        return 44.;
    }else if (_selectStateView.selectIndex == 1)
    {
        return 100.;
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    if (self.isPayBack) {
        
        return 2;
    }
    
    if (_selectStateView.selectIndex == 0) {
         self.tableView.separatorColor = XBB_separatorColor;
        self.tableView.backgroundView.alpha = 0;
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

        
        if (state == 3 || state == 4) {
            return 3;
        }else if (state == 5 || state == 6){
            return 4;
        }
        else
        {
            return 2;
        }
    }else if (_selectStateView.selectIndex == 1){
        self.tableView.separatorColor =  [UIColor clearColor];
        self.tableView.backgroundView.alpha = 1;
        return 1;
    }
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isPayBack) {
        switch (section) {
            case 0:
                return self.twoSectionArray.count;
                break;
            case 1:
                return self.onsectionArray.count;
                break;
            default:
                break;
        }
    }
    
    if (_selectStateView.selectIndex == 0) {
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
        if (state == 3 || state == 4) {
            switch (section) {
                case 0:
                {
                    return self.onsectionArray.count;
                }
                    break;
                case 1:
                {
                    return self.empArrays.count;
                }
                    break;
                case 2:
                {
                    return self.twoSectionArray.count;
                }
                    break;
                    
                default:
                    break;
            }
        }else if(state == 5 || state == 6){
            switch (section) {
                case 0:
                {
                    return self.onsectionArray.count;
                }
                    break;
                case 1:
                {
                    return self.empArrays.count;
                }
                    break;
                case 2:
                {
                    return self.twoSectionArray.count;
                }
                    break;
                    
                case 3:
                {
                    return self.commentArray.count;
                }
                    break;
                    
                default:
                    break;
            }
        }else
        {
            switch (section) {
                case 0:
                {
                    return self.onsectionArray.count;
                }
                    break;
                case 1:
                {
                    return self.twoSectionArray.count;
                }
                    break;
                    
                default:
                    break;
            }
        }
    }else if (_selectStateView.selectIndex == 1){
        return self.timesArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_selectStateView.selectIndex == 0 || self.isPayBack) {
        
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
        XBBOrder *order = nil;
        
        if (self.isPayBack) {
            switch (indexPath.section) {
                case 0:
                {
                    order = self.twoSectionArray[indexPath.row];
                }
                    break;
                case 1:
                {
                    order = self.onsectionArray[indexPath.row];
                }
                    break;
                default:
                    break;
            }
            
        }else{
            
            
            switch (indexPath.section) {
                case 0:
                {
                    order = self.onsectionArray[indexPath.row];
                }
                    break;
                case 1:
                {
                    if (state == 0 || state == 1 || state == 2 || state == 7) {
                        order = self.twoSectionArray[indexPath.row];
                    }else
                    {
                        order = self.empArrays[indexPath.row];
                    }
                }
                    break;
                case 2:
                {
                    if (state == 0 || state == 1 || state == 2 || state == 7) {
                        
                    }else
                    {
                        order = self.twoSectionArray[indexPath.row];
                    }
                }
                    break;
                case 3:
                {
                    order = self.commentArray[indexPath.row];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        if (indexPath.row == 0) {
            XBBOrderInfoOneCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCell];
            if (cell== nil) {
                cell = [[XBBOrderInfoOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCell];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = order.title;
            return cell;
            
        }else
        {
            
            
            if (indexPath.section == 3 && state == 5) {
                XBBOrderInfoCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mycomment];
                if (cell == nil) {
                    cell = [[XBBOrderInfoCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mycomment];
                }
                [cell.toCommentButton addTarget:self action:@selector(toCommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.toCommentButton setTitle:order.title forState:UIControlStateNormal];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else if (indexPath.section == 3 && state == 6) {
                CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hascomment];
                if (cell == nil) {
                    cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hascomment];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                StarView *star = [StarView starView];
                DLog(@"%ld",order.star_num)
                star.score =order.star_num; //(double)order.star_num;
                [cell.commentStar addSubview:star];
                cell.commentContent.text = order.title;
                return cell;
            }
            
            
            XBBOrderInfoTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfo];
            if (cell == nil) {
                cell = [[XBBOrderInfoTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderInfo];
            }
            cell.phoneButton.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.priceLabel setFont:[UIFont systemFontOfSize:14.]];
            
            
            if (self.isPayBack) {
                if (indexPath.section != 0) {
                    cell.titLabel.hidden = YES;
                    cell.twoTitleLabel.hidden = NO;
                    cell.priceLabel.hidden = NO;
                    cell.twoTitleLabel.text = order.title;
                    cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",order.price];
                    [cell.twoTitleLabel setTextColor:[UIColor darkGrayColor]];
                    [cell.priceLabel setTextColor:[UIColor darkGrayColor]];
                    if ([order.title isEqualToString:@"优惠金额"]) {
                        //                    [cell.twoTitleLabel setTextColor:[UIColor orangeColor]];
                        [cell.priceLabel setTextColor:[UIColor orangeColor]];
                    }
                    if ([order.title isEqualToString:@"实际支付"] || [order.title isEqualToString:@"应支付"]) {
                        [cell.priceLabel setFont:[UIFont systemFontOfSize:18.]];
                        [cell.priceLabel setTextColor:[UIColor redColor]];
                    }
                    
                    
                    
                }else
                {
                    
                    cell.phoneButton.hidden = YES;
                    if (indexPath.section == 1 && (state == 3 || state == 4 || state == 6 || state == 5)) {
                        cell.phoneButton.hidden = NO;
                        [cell.phoneButton addTarget:self action:@selector(toCallPhone:) forControlEvents:UIControlEventTouchUpInside];
                    }else
                    {
                        cell.phoneButton.hidden = YES;
                    }
                    
                    [cell.twoTitleLabel setTextColor:[UIColor darkGrayColor]];
                    [cell.priceLabel setTextColor:[UIColor darkGrayColor]];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titLabel.hidden = YES;
                    cell.twoTitleLabel.hidden = NO;
                    cell.priceLabel.hidden = YES;
                    cell.twoTitleLabel.text = order.title;
                    
                }
                
            }else
            {
                
                if (indexPath.section == 0) {
                    cell.titLabel.hidden = YES;
                    cell.twoTitleLabel.hidden = NO;
                    cell.priceLabel.hidden = NO;
                    cell.twoTitleLabel.text = order.title;
                    cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",order.price];
                    [cell.twoTitleLabel setTextColor:[UIColor darkGrayColor]];
                    [cell.priceLabel setTextColor:[UIColor darkGrayColor]];
                    if ([order.title isEqualToString:@"优惠金额"]) {
                        //                    [cell.twoTitleLabel setTextColor:[UIColor orangeColor]];
                        [cell.priceLabel setTextColor:[UIColor orangeColor]];
                    }
                    if ([order.title isEqualToString:@"实际支付"] || [order.title isEqualToString:@"应支付"]) {
                        [cell.priceLabel setFont:[UIFont systemFontOfSize:18.]];
                        [cell.priceLabel setTextColor:[UIColor redColor]];
                    }
                }else
                {
                    
                    cell.phoneButton.hidden = YES;
                    if (indexPath.section == 1 && (state == 3 || state == 4 || state == 6 || state == 5)) {
                        cell.phoneButton.hidden = NO;
                        [cell.phoneButton addTarget:self action:@selector(toCallPhone:) forControlEvents:UIControlEventTouchUpInside];
                    }else
                    {
                        cell.phoneButton.hidden = YES;
                    }
                    
                    [cell.twoTitleLabel setTextColor:[UIColor darkGrayColor]];
                    [cell.priceLabel setTextColor:[UIColor darkGrayColor]];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titLabel.hidden = YES;
                    cell.twoTitleLabel.hidden = NO;
                    cell.priceLabel.hidden = YES;
                    cell.twoTitleLabel.text = order.title;
                    
                }
                
            }
            
            
            return cell;
        }

    }else if (_selectStateView.selectIndex == 1){
        XBBOrderStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stateCell];
        if (cell == nil) {
            cell = [[XBBOrderStateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stateCell];
           
        }
        
        NSDictionary *dic = self.timesArray[indexPath.row];
        if ([[self.timesArray lastObject] isEqualToDictionary:dic]) {
            cell.bgimageView.image = [UIImage imageNamed:@"xbb_currentField"];
            cell.pointImageView.image = [UIImage imageNamed:@"xbb_current"];
        }else
        {
          
            cell.bgimageView.image = [UIImage imageNamed:@"xbb_oldField"];
            cell.pointImageView.image = [UIImage imageNamed:@"xbb_old"];
        }
        cell.mainTitleLabel.text = dic[@"msg"];
        cell.timeLabel.text = dic[@"time"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }

    return nil;
}

@end
