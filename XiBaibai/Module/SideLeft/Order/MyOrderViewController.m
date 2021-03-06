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
#import "XBBCommentViewController.h"


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
    self.orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XBB_Screen_width, XBB_Screen_height-64)];
    [self.view addSubview:self.orderTableView ];
    self.orderTableView .backgroundView = nil;
    self.orderTableView .backgroundColor = XBB_Bg_Color;
    self.orderTableView .dataSource = self;
    self.orderTableView .delegate = self;
    self.orderTableView.separatorColor = XBB_separatorColor;
    [self.orderTableView  registerNib:[UINib nibWithNibName:@"MyOrderMouldTableViewCell" bundle:nil] forCellReuseIdentifier:identifi];
//    self.orderTableView.contentInset = UIEdgeInsetsMake(6., 0, 0, 0);
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
    DLog(@"%@",[[UserObj shareInstance] uid])
    [self initNoDataUI];
    [self setNavigationBarControl];
    [self regisCell];
    [self initView];
    page = 1;
    self.orderTableView.alpha = 0;
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
                [self.orderTableView reloadData];
            }
            
        } completion:^(BOOL finished) {
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
    noDataView = [[XBBNotDataView alloc] initWithFrame:self.view.bounds withImage:[UIImage imageNamed:@"40订单列表无数据"] withString:@"您还没有订单信息哦"];
    [self.view addSubview:noDataView];
    noDataView.alpha = 0;
}

- (void)handleOrderDidUpdate:(NSNotification *)sender {

    if ([sender.object isEqualToString:@"orderInfo"]) {
        [self.orderArr removeAllObjects];
        self.orderArr = nil;
        page = 1;
    }
    self.orderTableView.alpha = 0;
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
            [self.orderTableView reloadData];
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
        DLog(@"%@",response)
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
        
    }else if ([button.titleLabel.text isEqualToString:@"支付订单"]){
        selectTag = button.tag;

        [RechargeHelper setAliPayNotifyURLString:[NSString stringWithFormat:@"%@?recharge_type=%@", Notify_AlipayCallback_Url, @"1"]];
        double price = order.total_price;
        [[RechargeHelper defaultRechargeHelper] payAliWithMoney:price orderNO:order.order_num productTitle:order.order_name productDescription:order.order_name];

        DLog(@"支付订单")
    }else if ([button.titleLabel.text isEqualToString:@"去评价"]) {
        DLog(@"去评价")
        XBBCommentViewController *comment = [[XBBCommentViewController alloc] init];
        comment.orderId = order.order_id;
        [self presentViewController:comment animated:YES completion:nil];
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = XBB_Bg_Color;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 6.0;
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
    
    if (order.order_state == 0) {
         cell.priceLabel.text = [NSString stringWithFormat:@"待付 : ¥ %.2f",order.total_price?order.total_price:0];
    }else if (order.order_state == 7) {
        cell.priceLabel.text = [NSString stringWithFormat:@"合计 : ¥ %.2f",order.total_price?order.total_price:0];
    }else
    {
         cell.priceLabel.text = [NSString stringWithFormat:@"实付 : ¥ %.2f",order.total_price?order.total_price:0];
    }

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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
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
    XBBOrderObject *order = self.orderArr[indexPath.section];
    if (order.order_state == 0 || order.order_state == 6 || order.order_state == 7) {
        return YES;
    }
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         XBBOrderObject *order = self.orderArr[indexPath.section];
        [NetworkHelper postWithAPI:DeleteOrder parameter:@{@"uid":[UserObj shareInstance].uid,@"orderid":order.order_id} successBlock:^(id response) {
            DLog(@"%@",response)
            if ([response[@"code"] integerValue] == 1) {
                [self.orderArr removeObject:order];
                NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
                [tableView deleteSections:set withRowAnimation:UITableViewRowAnimationLeft];
            }else
            {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        }];
        
       
    }
    
}


@end
