//
//  MyOrderViewController.m
//  XBB
//
//  Created by Apple on 15/8/30.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "MyOrderViewController.h"
#import "UserObj.h"
#import <MJRefresh.h>
#import "MyOrderModel.h"
#import <MJExtension.h>
#import "MyOrderTableViewCell.h"
#import "OrderInfoViewController.h"
#import "PersonLocationViewController.h"
#import "CommentViewController.h"
#import "MyOrderMouldTableViewCell.h"
#import "XBBOrderObject.h"
#import "PayTableViewController.h"
#import "RechargeHelper.h"
#import "XBBOrderInfoViewController.h"

@interface MyOrderViewController () <UIActionSheetDelegate,UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    NSInteger   page;
    NSInteger   selectTag;
    BOOL isCurrentClass;
    XBBNotDataView *noDataView;
}
@property (nonatomic, strong) UITableView *orderTableView;

@property (weak, nonatomic) IBOutlet UIButton *completionButton;
@property (strong, nonatomic) NSMutableArray *orderArr;


@end

static NSString *identifi = @"cell";

@implementation MyOrderViewController



#pragma mark UI


- (void)regisCell
{
    self.orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XBB_Screen_width, XBB_Screen_height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.orderTableView ];
    self.orderTableView .backgroundView = nil;
    self.orderTableView .backgroundColor = XBB_Bg_Color;
    self.orderTableView .dataSource = self;
    self.orderTableView .delegate = self;
    self.orderTableView.separatorColor = XBB_separatorColor;
    [self.orderTableView  registerNib:[UINib nibWithNibName:@"MyOrderMouldTableViewCell" bundle:nil] forCellReuseIdentifier:identifi];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isCurrentClass = YES;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    isCurrentClass = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNoDataUI];
    [self setNavigationBarControl];
    [self regisCell];
    [self initView];
    page = 1;

    
    [self fetchOrderFromWeb:^{
        [UIView animateWithDuration:0.3 animations:^{
            if (self.orderArr.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                noDataView.alpha = 1;
                self.orderTableView.alpha = 0;
                
            }else
            {
                noDataView.alpha = 0;
                self.orderTableView.alpha = 1;
            }
            
        } completion:^(BOOL finished) {
            [self.orderTableView reloadData];
            [SVProgressHUD dismiss];
        }];

        
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOfPay:) name:NotificationRecharge object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOrderDidUpdate:) name:NotificationOrderListUpdate object:nil];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    WS(weakSelf)
    self.orderTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page++;
        [weakSelf.orderTableView.header endRefreshing];
        [weakSelf.orderTableView.footer resetNoMoreData];
        [weakSelf fetchOrderFromWeb:^{
            [UIView animateWithDuration:0.3 animations:^{
                if (self.orderArr.count == 0) {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                    noDataView.alpha = 1;
                    self.orderTableView.alpha = 0;
                    
                }else
                {
                    noDataView.alpha = 0;
                    self.orderTableView.alpha = 1;
                }
                
            } completion:^(BOOL finished) {
                [self.orderTableView reloadData];
                [SVProgressHUD dismiss];
               
            }];
           
        }];
       
    }];
    self.orderTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf.orderTableView.header endRefreshing];
        [weakSelf.orderTableView.footer resetNoMoreData];
        [weakSelf fetchOrderFromWeb:^{
            [UIView animateWithDuration:0.3 animations:^{
                if (self.orderArr.count == 0) {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                    noDataView.alpha = 1;
                    self.orderTableView.alpha = 0;
                    
                }else
                {
                    noDataView.alpha = 0;
                    self.orderTableView.alpha = 1;
                }
                
            } completion:^(BOOL finished) {
                [self.orderTableView reloadData];
                [SVProgressHUD dismiss];
           
            }];
                   }];

    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Action

- (void)handleOfPay:(NSNotification *)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RechargeResultObject *result = sender.object;
        if (result.isSuccessful) {
         
            if (isCurrentClass) {
                XBBOrderObject *object = self.orderArr[selectTag];
                XBBOrderInfoViewController *info = [[XBBOrderInfoViewController alloc] init];
                info.isPayBack = YES;
                info.pageController = 2;
                info.navigationTitle = @"支付成功";
                info.orderid = object.order_id;
                
                [self.navigationController pushViewController:info animated:YES];
                [self.orderArr removeAllObjects];
                self.orderArr = nil;
                page = 1;
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOrderListUpdate object:nil];
            }
      
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    });
}

- (IBAction)backViewController:(id)sender
{
    
    
    if (self.isBackController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)initNoDataUI
{
    noDataView = [[XBBNotDataView alloc] initWithFrame:self.view.bounds withImage:[UIImage imageNamed:@"泡泡"] withString:@"您还没有订单信息哦"];
    [self.view addSubview:noDataView];
    noDataView.alpha = 0;
}

- (void)handleOrderDidUpdate:(NSNotification *)sender {

    if ([sender.object isEqualToString:@"orderInfo"]) {
        [self.orderArr removeAllObjects];
        self.orderArr = nil;
        page = 1;
    }
    [self fetchOrderFromWeb:^{
        [UIView animateWithDuration:0.3 animations:^{
            if (self.orderArr.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                noDataView.alpha = 1;
                self.orderTableView.alpha = 0;
                
            }else
            {
                noDataView.alpha = 0;
                self.orderTableView.alpha = 1;
                [SVProgressHUD dismiss];
            }
            
        } completion:^(BOOL finished) {
            [SVProgressHUD dismiss];
            [self.orderTableView reloadData];
        }];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)clickBack:(id)sender {
    if (self.isBackController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)typeBtnOnClick:(id)sender {

    [self.orderTableView reloadData];
}

- (void)fetchOrderFromWeb:(void (^)())callback {
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:XBB_orderSelect parameter:@{@"uid": [UserObj shareInstance].uid,@"p":@(page)} successBlock:^(id response) {
   
        if (self.orderArr == nil) {
            self.orderArr = [NSMutableArray array];
        }
        if ([response[@"code"] integerValue] == 1) {
            id arr = response[@"result"];
            if (![arr isKindOfClass:[NSArray class]]) {
                page = 1;
            }else{
                for (NSDictionary *temp in response[@"result"]) {
                    [XBBOrderObject setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{@"order_id": @"id"};
                    }];
                    XBBOrderObject *model = [XBBOrderObject objectWithKeyValues:temp];
                    [self.orderArr addObject:model];
                }
            }
        } else {
            [SVProgressHUD showInfoWithStatus:response[@"msg"]];
        }
        
        if (callback)
            callback();
    } failBlock:^(NSError *error) {
        if (callback)
            callback();
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
   
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        XBBOrderObject *model = self.orderArr[actionSheet.tag];
        [SVProgressHUD show];
        [NetworkHelper postWithAPI:API_OrderCancel parameter:@{@"uid": [UserObj shareInstance].uid, @"orderid": model.order_id} successBlock:^(id response) {
            if ([response[@"code"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                [self.orderArr removeAllObjects];
                self.orderArr = nil;
                page = 1;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOrderListUpdate object:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"取消失败"];
        }];
    }
}

- (IBAction)buttonAction:(id)sender
{
    
    UIButton *button = sender;
    XBBOrderObject *order = self.orderArr[button.tag];
    DLog(@"%ld",button.tag)
    if ([button.titleLabel.text isEqualToString:@"取消订单"]) {
        
        
        if (order.order_state <= 3) {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"取消订单" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [action showInView:self.view];
            action.tag  = button.tag;
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"您不能取消此订单"];
        }
        
        DLog(@"取消")
    }else if ([button.titleLabel.text isEqualToString:@"支付订单"]){
        selectTag = button.tag;

        [RechargeHelper setAliPayNotifyURLString:[NSString stringWithFormat:@"%@?recharge_type=%@", Notify_AlipayCallback_Url, @"1"]];
        double price = order.total_price;
        [[RechargeHelper defaultRechargeHelper] payAliWithMoney:price orderNO:order.order_num productTitle:order.order_name productDescription:order.order_name];

        DLog(@"支付订单")
    }else if ([button.titleLabel.text isEqualToString:@"去评价"]) {
        DLog(@"去评价")
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MyOrderPushDetailComplete"]) {
        MyOrderModel *model = sender;
        [segue.destinationViewController setValue:[NSString stringWithFormat:@"%@", @(model.orderId)] forKey:@"order_id"];
    } else if ([segue.identifier isEqualToString:@"MyOrderPushComment"]) {
        MyOrderModel *model = sender;
        [segue.destinationViewController setValue:model.emp_name forKey:@"emp_name"];
        [segue.destinationViewController setValue:model.emp_img forKey:@"emp_img"];
        [segue.destinationViewController setValue:model.emp_num forKey:@"emp_num"];
        [segue.destinationViewController setValue:@(model.order_reg_id) forKey:@"emp_id"];
        [segue.destinationViewController setValue:@(model.orderId) forKey:@"order_id"];
    } else if ([segue.identifier isEqualToString:@"MyOrderPushComplaint"]) {
        MyOrderModel *model = sender;
        [segue.destinationViewController setValue:model.emp_name forKey:@"emp_name"];
        [segue.destinationViewController setValue:model.emp_img forKey:@"emp_img"];
        [segue.destinationViewController setValue:model.emp_num forKey:@"emp_num"];
        [segue.destinationViewController setValue:@(model.order_reg_id) forKey:@"emp_id"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //    if (buttonIndex == 1) {
    //        MyOrderModel *model = self.doingButton.selected? self.orderDoingArr[alertView.tag]: self.orderDoneArr[alertView.tag];
    //        [NetworkHelper postWithAPI:API_OrderCancel parameter:@{@"uid": [UserObj shareInstance].uid, @"order_id": @(model.orderId)} successBlock:^(id response) {
    //            if ([response[@"code"] integerValue] == 1) {
    //                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
    //                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOrderListUpdate object:nil];
    //            } else {
    //                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
    //            }
    //        } failBlock:^(NSError *error) {
    //            [SVProgressHUD showErrorWithStatus:@"取消失败"];
    //        }];
    //    }
}


#pragma mark tableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
    return self.orderArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 300.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBBOrderObject *order = self.orderArr[indexPath.section];
    MyOrderMouldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (cell == nil) {
        cell = [[MyOrderMouldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    cell.nameLabel.text = order.order_name?order.order_name:@"";
    cell.payStateLabel.text = order.orderstate?order.orderstate:@""; //[order orderStateString];
    
    cell.serviceTimeLabel.text = [NSString stringWithFormat:@"服务时间:   %@",order.servicetime?order.servicetime:@""];
    cell.downOrderTimeLabel.text = [NSString stringWithFormat:@"车辆位置:   %@",order.location?order.location:@""];
    cell.carTypeLabel.text = [NSString stringWithFormat:@"车       型:   %@",order.cartype?order.cartype:@""];
    cell.carCaseLabel.text = [NSString stringWithFormat:@"下单时间:   %@",order.p_order_time?order.p_order_time:@""];
    cell.CarNumLabel.text = [NSString stringWithFormat:@"订单号码:   %@",order.order_num?order.order_num:@""];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"合计 : ¥ %.2f",order.total_price?order.total_price:0];

    cell.oneButton.alpha = 0;
    cell.twoButton.alpha = 0;
    
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
    
    UIImage *sureImage = [UIImage imageNamed:@"支付订单"];
    sureImage = [sureImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeTile];
    
    UIImage *cannelImage = [UIImage imageNamed:@"取消订单"];
     cannelImage = [cannelImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeTile];
    
    [cell.payStateLabel setTextColor:[UIColor lightGrayColor]];
    switch (order.order_state) {
        case 0:
        {
            cell.twoButton.alpha = 1;
            cell.oneButton.alpha = 1.;
            [cell.oneButton setTitleColor:XBB_Bg_Color forState:UIControlStateNormal];
            [cell.oneButton setBackgroundImage:sureImage forState:UIControlStateNormal];
            [cell.oneButton setTitle:@"支付订单" forState:UIControlStateNormal];
            
            [cell.twoButton setBackgroundImage:cannelImage forState:UIControlStateNormal];
            [cell.twoButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [cell.twoButton setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
            [cell.payStateLabel setTextColor:[UIColor redColor]];
        }
            break;
        case 1:
        {
            cell.oneButton.alpha = 1.;
            [cell.oneButton setBackgroundImage:cannelImage forState:UIControlStateNormal];
            [cell.oneButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [cell.oneButton setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            cell.oneButton.alpha = 1.;
            [cell.oneButton setTitleColor:XBB_Bg_Color forState:UIControlStateNormal];
            [cell.oneButton setBackgroundImage:cannelImage forState:UIControlStateNormal];
            [cell.oneButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [cell.oneButton setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];

        }
            break;
        case 3:
        {
            cell.oneButton.alpha = 1.;
            [cell.oneButton setTitleColor:XBB_Bg_Color forState:UIControlStateNormal];
            [cell.oneButton setBackgroundImage:cannelImage forState:UIControlStateNormal];
            [cell.oneButton setTitle:@"取消订单" forState:UIControlStateNormal];
                [cell.oneButton setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
//            cell.oneButton.alpha = 1.;
//            [cell.oneButton setTitleColor:XBB_Bg_Color forState:UIControlStateNormal];
//            [cell.oneButton setBackgroundImage:cannelImage forState:UIControlStateNormal];
//            [cell.oneButton setTitle:@"取消订单" forState:UIControlStateNormal];
//            [cell.oneButton setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
           
  
        }
            break;
        case 5:
        {
            cell.oneButton.alpha = 1.;
            [cell.oneButton setTitleColor:XBB_Bg_Color forState:UIControlStateNormal];
            [cell.oneButton setBackgroundImage:sureImage forState:UIControlStateNormal];
            [cell.oneButton setTitle:@"去评价" forState:UIControlStateNormal];
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
    
    
    [cell.oneButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.twoButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.oneButton.tag = indexPath.section;
    cell.twoButton.tag = indexPath.section;
    
    
//    cell.carCaseLabel.text = [NSString stringWithFormat:@"车辆信息: %@",order.];
//    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTableViewCell" forIndexPath:indexPath];
   
//
//    self.orderDoneArr[indexPath.row];
//    cell.topView.priceLabel.text = [NSString stringWithFormat:@"￥%@", order.total_price ? order.total_price : @""];
//    NSString *str=order.p_order_time;//时间戳
//    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
//    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//    NSLog(@"date:%@",[detaildate description]);
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.timeZone = [NSTimeZone localTimeZone];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//     NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//    cell.topView.dateLabel.text = currentDateStr;
//    cell.topView.addressLabel.text = order.location ? order.location : @"";
//   
//    cell.topView.modelLabel.text = [NSString stringWithFormat:@"%@ %@ %@", order.c_brand?order.c_brand : @"", order.c_color ? order.c_color : @"", order.c_plate_num? order.c_plate_num: @""];
//    cell.topView.orderNO.text = order.order_num ? order.order_num : @"";
//    cell.topView.orderState.text = [order orderStateString];
//    cell.topView.titleLabel.text = order.order_name ? order.order_name : @"";
//    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, order.emp_img]]];
//    cell.nameLabel.text = order.emp_name;
//    cell.summaryLabel.text = [NSString stringWithFormat:@"%@", @(order.order_reg_id)];
//    [cell.scoreView setScore:[order.star floatValue]];
//    cell.scoreLabel.text = [NSString stringWithFormat:@"%@分", @([order.star floatValue])];
//
//    if (self.doingButton.selected) {
//        [cell.locationButton setTitle:@"工作人员位置" forState:UIControlStateNormal];
//        [cell.locationButton setImage:[UIImage imageNamed:@"1@icon_16"] forState:UIControlStateNormal];
//        cell.locationButton.backgroundColor = [UIColor colorWithRed:0.08 green:0.8 blue:0.62 alpha:1];
//        [cell.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
//        [cell.cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
//    }
//    if (self.completionButton.selected) {
//        [cell.locationButton setTitle:@"评价" forState:UIControlStateNormal];
//        [cell.locationButton setImage:[UIImage imageNamed:@"1@icon_16"] forState:UIControlStateNormal];
//        cell.locationButton.backgroundColor = [UIColor orangeColor];
//        [cell.cancelButton setTitle:@"投诉" forState:UIControlStateNormal];
//        [cell.cancelButton setImage:[UIImage imageNamed:@"xbb_165"] forState:UIControlStateNormal];
//    }
//    cell.locationButton.tag = indexPath.row;
//    cell.cancelButton.tag = indexPath.row;
//    [cell.locationButton addTarget:self action:@selector(leftBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.cancelButton addTarget:self action:@selector(rightBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    XBBOrderObject *object = self.orderArr[indexPath.section];
    XBBOrderInfoViewController *info = [[XBBOrderInfoViewController alloc] init];
    info.navigationTitle = @"订单详情";
    info.orderid = object.order_id;
    info.orderNum = object.order_num;
    info.orderName = object.order_name;
    
    [self.navigationController pushViewController:info animated:YES];
    
}


@end
