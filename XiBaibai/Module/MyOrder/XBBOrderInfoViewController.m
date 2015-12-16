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

@interface XBBOrderInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSInteger state;
    UIView *backView;
    float coupon_price;
    float total_price;
    float actually_price;
    UIButton *backButton;
    
    NSString *empPhone;
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *prolist;
@property (nonatomic, strong) NSDictionary *washimgDic;
@property (nonatomic, strong) MyOrderModel *feathModel;


@property (nonatomic, strong) NSMutableArray *onsectionArray; // pros
@property (nonatomic, strong) NSMutableArray *twoSectionArray; // message
@property (nonatomic, strong) NSMutableArray *empArrays; //emp
@property (nonatomic, strong) NSMutableArray *commentArray;




@end

static NSString *titleCell = @"titleCell";
static NSString *orderInfo = @"orderInfo";
//static NSString *oprationMessage = @"opreationMessage";
//static NSString *orderContent = @"orderContent";
static NSString *mycomment = @"mycomment";

@implementation XBBOrderInfoViewController

- (void)agoTableView
{
    [self addTableView];
    [self initTabView];
    if (state==0) {
         self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y, XBB_Screen_width, self.tableView.frame.size.height - 66.);
        backView.alpha = 1;
    }
   
    
}

#pragma datas
- (void)feathOrderInfo
{
    [NetworkHelper postWithAPI:OrderSelect_detail_API parameter:@{@"uid":[[UserObj shareInstance] uid],@"orderid":self.orderid} successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            if (response[@"result"]) {
                
                [MyOrderModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"order_id": @"id"};
                }];
                MyOrderModel *model = [MyOrderModel objectWithKeyValues:response[@"result"]];
                self.feathModel = model;
                total_price = model.totalprice;
                coupon_price = model.coupons_price;
           DLog(@"%@",response)
                // 获取产品数组
                NSArray *proArray = response[@"result"][@"prolist"];
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
                
                XBBOrder *endOrder_2 = [[XBBOrder alloc] init];
                endOrder_2.title = @"优惠金额";
                endOrder_2.price = -coupon_price;
                [arr_0 addObject:endOrder_2];
                self.onsectionArray = arr_0;
                
                actually_price = total_price - coupon_price;
                XBBOrder *endOrder_1 = [[XBBOrder alloc] init];
                endOrder_1.title = @"实际支付";
                endOrder_1.price = actually_price;
                [arr_0 addObject:endOrder_1];
                self.onsectionArray = arr_0;
                
                if (state == 3 || state == 4 || state == 5 || state == 6) {
                    
                    NSMutableArray *oper = [NSMutableArray array];
                    XBBOrder *one = [[XBBOrder alloc] init];
                    one.title = @"操作信息";
                    [oper addObject:one];
                    
                    XBBOrder *name = [[XBBOrder alloc] init];
                    name.title = [NSString stringWithFormat:@"技师名字:    %@",model.emp_name];
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
                order_1_1.title = [NSString stringWithFormat: @"服务时间:    %@",model.servicetime];
                [arr_1 addObject:order_1_1];
                
                XBBOrder *order_1_2 = [[XBBOrder alloc] init];
                order_1_2.title = [NSString stringWithFormat:@"订单号码:    %@",model.order_num];
                [arr_1 addObject:order_1_2];
                
                XBBOrder *order_1_4 = [[XBBOrder alloc] init];
                order_1_4.title =[NSString stringWithFormat:@"订单时间:    %@", model.p_order_time];
                [arr_1 addObject:order_1_4];
                
                if (state != 0) {
                    XBBOrder *order_1_5 = [[XBBOrder alloc] init];
                    order_1_5.title =[NSString stringWithFormat:@"支付方式:    %@", model.pay_type];
                    [arr_1 addObject:order_1_5];

                }
                XBBOrder *order_1_3 = [[XBBOrder alloc] init];
                order_1_3.title = [NSString stringWithFormat:@"车主名称:    %@",model.uname];
                [arr_1 addObject:order_1_3];
                
                XBBOrder *order_1_6 = [[XBBOrder alloc] init];
                order_1_6.title = [NSString stringWithFormat:@"车辆信息:    %@",model.carinfo];
                [arr_1 addObject:order_1_6];
                
                XBBOrder *order_1_9 = [[XBBOrder alloc] init];
                order_1_9.title = [NSString stringWithFormat:@"车       牌:    %@",model.c_plate_num?model.c_plate_num:@""];
                [arr_1 addObject:order_1_9];
                
                
                XBBOrder *order_1_7 = [[XBBOrder alloc] init];
                order_1_7.title = [NSString stringWithFormat:@"车辆类别:    %@",model.cartype];
                [arr_1 addObject:order_1_7];
                
                XBBOrder *order_1_8 = [[XBBOrder alloc] init];
                order_1_8.title = [NSString stringWithFormat:@"车辆位置:    %@",model.location];
                [arr_1 addObject:order_1_8];
                
                self.twoSectionArray = arr_1;
                
                DLog(@"%@",self.twoSectionArray)
                
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
                    oder.title = @"已评价";
                    [conA addObject:oder];
                    XBBOrder *oder_1 = [[XBBOrder alloc] init];
                    oder_1.title = @"已评论";
                    [conA addObject:oder_1];
                    
                }
               self.commentArray = conA;
              
                
                
                
                [self agoTableView];

                [self.tableView reloadData];
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

- (void)initUIWithStateNoPay
{
    backView.alpha = 1;
}

- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOfPay:) name:NotificationRecharge object:nil];
    [self initUI];
    [self feathOrderInfo];
    
}

- (void)initUI
{
    [self setNavigationBarControl];

}

- (void)initTabView
{
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XBB_Screen_width, XBB_Screen_height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = XBB_Bg_Color;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = XBB_separatorColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBOrderInfoOneCell" bundle:nil] forCellReuseIdentifier:titleCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBOrderInfoTwoTableViewCell" bundle:nil] forCellReuseIdentifier:orderInfo];
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBOrderInfoCommentTableViewCell" bundle:nil] forCellReuseIdentifier:mycomment];
}

#pragma mark action

- (IBAction)toBackAction:(id)sender
{
    DLog(@"succesd")
    if (self.pageController == 1) {
        MyOrderViewController *order =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyOrderViewController"];
        order.isBackController = YES;
        [self.navigationController pushViewController:order animated:YES];
    }else if (self.pageController == 2) {
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"联系技师" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"%@",empPhone] otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}
- (void)handleOfPay:(NSNotification *)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RechargeResultObject *result = sender.object;
        if (result.isSuccessful) {
            
            self.isPayBack = YES;
            backButton.alpha = 0;
            [self feathOrderInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOrderListUpdate object:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    });
}

- (IBAction)toCommentButtonAction:(id)sender
{
    
}

- (IBAction)toPay:(id)sender
{
    [RechargeHelper setAliPayNotifyURLString:[NSString stringWithFormat:@"%@?recharge_type=%@", Notify_AlipayCallback_Url, @"1"]];
    [[RechargeHelper defaultRechargeHelper] payAliWithMoney:actually_price orderNO:self.feathModel.order_num productTitle:self.feathModel.order_name  productDescription:self.feathModel.order_name];
}
- (IBAction)backViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.isPayBack) {
        if (section == 1) {
            return 66.;
        }
        
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.isPayBack) {
        if (section == 1) {
       
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XBB_Screen_width, 60.)];
        UIImage *image = [UIImage imageNamed:@"确定"];
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 66/2-10, XBB_Screen_width-40., 44.)];
        [view addSubview:backButton];
        [backButton setBackgroundImage:image forState:UIControlStateNormal];
        [backButton setTitle:@"确定" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(toBackAction:) forControlEvents:UIControlEventTouchUpInside];
        return view;
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (state == 5 && indexPath.section == 3 && indexPath.row == 1) {
        return 80;
    }
    return 44.;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    
    
    if (self.isPayBack) {
        return 2;
    }
    
    
    if (state == 3 || state == 4) {
        return 3;
    }else if (state == 5 || state == 6){
        return 4;
    }
    else
    {
         return 2;
    }
    
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
                [cell.twoTitleLabel setTextColor:[UIColor blackColor]];
                [cell.priceLabel setTextColor:[UIColor blackColor]];
                if ([order.title isEqualToString:@"优惠金额"]) {
                    [cell.twoTitleLabel setTextColor:[UIColor orangeColor]];
                    [cell.priceLabel setTextColor:[UIColor orangeColor]];
                }
                if ([order.title isEqualToString:@"实际支付"]) {
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
                
                [cell.twoTitleLabel setTextColor:[UIColor blackColor]];
                [cell.priceLabel setTextColor:[UIColor blackColor]];
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
                [cell.twoTitleLabel setTextColor:[UIColor blackColor]];
                [cell.priceLabel setTextColor:[UIColor blackColor]];
                if ([order.title isEqualToString:@"优惠金额"]) {
                    [cell.twoTitleLabel setTextColor:[UIColor orangeColor]];
                    [cell.priceLabel setTextColor:[UIColor orangeColor]];
                }
                if ([order.title isEqualToString:@"实际支付"]) {
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
                
                [cell.twoTitleLabel setTextColor:[UIColor blackColor]];
                [cell.priceLabel setTextColor:[UIColor blackColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.titLabel.hidden = YES;
                cell.twoTitleLabel.hidden = NO;
                cell.priceLabel.hidden = YES;
                cell.twoTitleLabel.text = order.title;
                
            }

        }
        
        
        
        
        
        
        
        
        return cell;
    }
    
    
    
    
    
//    
//    
//    if (state == 3 || state == 4) {
//        switch (indexPath.section) {
//            case 0:
//            {
//                XBBOrder *order = self.onsectionArray[indexPath.row];
//                if (indexPath.row == 0) {
//                    XBBOrderInfoOneCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCell];
//                    if (cell== nil) {
//                        cell = [[XBBOrderInfoOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCell];
//                    }
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell.titleLabel.text = order.title;
//                    return cell;
//                }else{
//                    
//                    XBBOrderInfoTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfo];
//                    if (cell == nil) {
//                        cell = [[XBBOrderInfoTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderInfo];
//                    }
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell.titLabel.hidden = YES;
//                    cell.twoTitleLabel.hidden = NO;
//                    cell.priceLabel.hidden = NO;
//                    cell.twoTitleLabel.text = order.title;
//                    cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",order.price];
//                    [cell.twoTitleLabel setTextColor:[UIColor blackColor]];
//                    [cell.priceLabel setTextColor:[UIColor blackColor]];
//                    if ([order.title isEqualToString:@"优惠金额"]) {
//                        [cell.twoTitleLabel setTextColor:[UIColor orangeColor]];
//                        [cell.priceLabel setTextColor:[UIColor orangeColor]];
//                    }
//                    
//                    
//                    return cell;
//                    
//                    
//                }
//            }
//                break;
//                
//                
//            case 1:
//            case 2:
//            {
//                 XBBOrder *order = self.twoSectionArray[indexPath.row];
//                if (indexPath.section == 1) {
//                    order = self.empArrays[indexPath.row];
//                }else
//                {
//                  
//                }
//                
//                
//                if (indexPath.row == 0) {
//                    XBBOrderInfoOneCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCell];
//                    if (cell== nil) {
//                        cell = [[XBBOrderInfoOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCell];
//                    }
//                    
//                    cell.titleLabel.text = order.title;
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    return cell;
//                }else{
//                    
//                    XBBOrderInfoTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfo];
//                    if (cell == nil) {
//                        cell = [[XBBOrderInfoTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderInfo];
//                    }
//                    [cell.twoTitleLabel setTextColor:[UIColor blackColor]];
//                    [cell.priceLabel setTextColor:[UIColor blackColor]];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell.titLabel.hidden = YES;
//                    cell.twoTitleLabel.hidden = NO;
//                    cell.priceLabel.hidden = YES;
//                    cell.twoTitleLabel.text = order.title;
//
//                    return cell;
//                    
//                    
//                }
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//    }else
//    {
//        switch (indexPath.section) {
//            case 0:
//            {
//                XBBOrder *order = self.onsectionArray[indexPath.row];
//                if (indexPath.row == 0) {
//                    XBBOrderInfoOneCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCell];
//                    if (cell== nil) {
//                        cell = [[XBBOrderInfoOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCell];
//                    }
//                    
//                    cell.titleLabel.text = order.title;
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    return cell;
//                }else{
//                    
//                    XBBOrderInfoTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfo];
//                    if (cell == nil) {
//                        cell = [[XBBOrderInfoTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderInfo];
//                    }
//                    cell.titLabel.hidden = YES;
//                    cell.twoTitleLabel.hidden = NO;
//                    cell.priceLabel.hidden = NO;
//                    cell.twoTitleLabel.text = order.title;
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",order.price];
//                    [cell.twoTitleLabel setTextColor:[UIColor blackColor]];
//                    [cell.priceLabel setTextColor:[UIColor blackColor]];
//                    
//                    if ([order.title isEqualToString:@"优惠金额"]) {
//                        [cell.twoTitleLabel setTextColor:[UIColor orangeColor]];
//                        [cell.priceLabel setTextColor:[UIColor orangeColor]];
//                    }
//                    
//                    return cell;
//                    
//                    
//                }
//            }
//                break;
//            case 1:
//            {
//                XBBOrder *order = self.twoSectionArray[indexPath.row];
//                
//                if (indexPath.row == 0) {
//                    XBBOrderInfoOneCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCell];
//                    if (cell== nil) {
//                        cell = [[XBBOrderInfoOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCell];
//                    }
//                    
//                    cell.titleLabel.text = order.title;
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    return cell;
//                }else{
//                    
//                    XBBOrderInfoTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfo];
//                    if (cell == nil) {
//                        cell = [[XBBOrderInfoTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderInfo];
//                    }
//                    
//                    [cell.twoTitleLabel setTextColor:[UIColor blackColor]];
//                    [cell.priceLabel setTextColor:[UIColor blackColor]];
//                    cell.titLabel.hidden = YES;
//                    cell.twoTitleLabel.hidden = NO;
//                    cell.priceLabel.hidden = YES;
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell.twoTitleLabel.text = order.title;
//                    
//                    return cell;
//                    
//                    
//                }
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }
    return nil;
}

@end
