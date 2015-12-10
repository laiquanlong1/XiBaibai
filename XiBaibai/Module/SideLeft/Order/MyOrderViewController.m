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

@interface MyOrderViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@property (weak, nonatomic) IBOutlet UIButton *doingButton;
@property (weak, nonatomic) IBOutlet UIButton *completionButton;
@property (strong, nonatomic) NSMutableArray *orderDoingArr, *orderDoneArr;
@property (assign, nonatomic) int doingPage, donePage;

@end

@implementation MyOrderViewController
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

- (IBAction)backViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarControl];
    
    // Do any additional setup after loading the view.
    [self initView];
    self.doingPage = 0;
    self.donePage = 0;
    [self fetchOrderFromWeb:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOrderDidUpdate:) name:NotificationOrderListUpdate object:nil];
//    [self setNavigationBarControl];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleOrderDidUpdate:(NSNotification *)sender {
    NSLog(@"%s",__func__);
    [self.orderTableView.header beginRefreshing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    WS(weakSelf)
    self.orderTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.doingButton.selected)
            weakSelf.doingPage = 0;
        else if (weakSelf.completionButton.selected)
            weakSelf.donePage = 0;
        [weakSelf fetchOrderFromWeb:^{
            [weakSelf.orderTableView.header endRefreshing];
            [weakSelf.orderTableView.footer resetNoMoreData];
        }];
    }];
    self.orderTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (weakSelf.doingButton.selected)
            weakSelf.doingPage = 0;
        else if (weakSelf.completionButton.selected)
            weakSelf.donePage = 0;
        [weakSelf fetchOrderFromWeb:^{
            [weakSelf.orderTableView.footer endRefreshing];
        }];
    }];
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)typeBtnOnClick:(id)sender {
    if (sender == self.doingButton) {
        self.doingButton.selected = YES;
        self.completionButton.selected = NO;
        if (self.orderDoingArr.count == 0) {
            [self fetchOrderFromWeb:nil];
        }
    } else {
        self.doingButton.selected = NO;
        self.completionButton.selected = YES;
        if (self.orderDoneArr.count == 0) {
            [self fetchOrderFromWeb:nil];
        }
    }
    [self.orderTableView reloadData];
}

- (void)fetchOrderFromWeb:(void (^)())callback {
    [SVProgressHUD show];
    DLog(@"%@  %d",[[UserObj shareInstance] uid],self.doingPage);
    
    
    [NetworkHelper postWithAPI:OrderSelect_API parameter:@{@"uid": [UserObj shareInstance].uid, @"state": self.doingButton.selected ? @"1": @"2", @"p": @(self.doingButton.selected?self.doingPage:self.donePage)} successBlock:^(id response) {
        if (callback)
            callback();
        if (self.doingButton.selected) {
            if (self.doingPage == 0)
                self.orderDoingArr = [NSMutableArray array];
        } else {
            if (self.donePage == 0)
                self.orderDoneArr = [NSMutableArray array];
        }
        if ([response[@"code"] integerValue] == 1) {
            for (NSDictionary *temp in response[@"result"]) {
                [MyOrderModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"orderId": @"id"};
                }];
                MyOrderModel *model = [MyOrderModel objectWithKeyValues:temp];
                if (self.doingButton.selected)
                    [self.orderDoingArr addObject:model];
                else
                    [self.orderDoneArr addObject:model];
            }
            if (self.doingButton.selected && self.orderDoingArr.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                [self.orderTableView.footer noticeNoMoreData];
            } else if (self.completionButton.selected && self.orderDoneArr.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                [self.orderTableView.footer noticeNoMoreData];
            } else {
                [SVProgressHUD dismiss];
            }
        } else {
            [SVProgressHUD showInfoWithStatus:response[@"msg"]];
        }
        [self.orderTableView reloadData];
    } failBlock:^(NSError *error) {
        if (callback)
            callback();
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

- (void)leftBtnOnTouch:(UIButton *)sender {
    MyOrderModel *model = self.doingButton.selected? self.orderDoingArr[sender.tag]: self.orderDoneArr[sender.tag];
    if (self.doingButton.selected) {
        // 工作人员位置
        if (model.order_state == 3 || model.order_state == 4) {
//            PersonLocationViewController *viewcontroller = [[PersonLocationViewController alloc] init];
//            viewcontroller.coordinate = CLLocationCoordinate2DMake([model.location_lt doubleValue], [model.location_lg doubleValue]);
//            viewcontroller.emp_name = model.emp_name;
//            viewcontroller.emp_num = model.emp_num;
//            [self.navigationController pushViewController:viewcontroller animated:YES];
            [SVProgressHUD showErrorWithStatus:@"即将上线"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"暂时无法查看员工位置"];
        }
    } else {
        // 评价
        if (model.order_state == 7) {
            [SVProgressHUD showErrorWithStatus:@"取消后不能评价"];
            return;
        }
        [self performSegueWithIdentifier:@"MyOrderPushComment" sender:model];
    }
}

- (void)rightBtnOnTouch:(UIButton *)sender {
    MyOrderModel *model = self.doingButton.selected? self.orderDoingArr[sender.tag]: self.orderDoneArr[sender.tag];
    if (self.doingButton.selected) {
        // 取消订单
        if (model.order_state < 1) {
            UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已付款金额将退至您的账户余额，确定取消？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            if (model.order_state < 1)
                cancelAlert.message = @"确定取消吗？";
            cancelAlert.tag = sender.tag;
            [cancelAlert show];
        } else {
            [SVProgressHUD showErrorWithStatus:@"此时无法取消"];
        }
    } else {
        // 投诉
        if (model.order_state == 7) {
            [SVProgressHUD showErrorWithStatus:@"取消后不能投诉"];
            return;
        }
        [self performSegueWithIdentifier:@"MyOrderPushComplaint" sender:model];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.doingButton.selected) {
        return self.orderDoingArr.count;
    }
    return self.orderDoneArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderModel *order = self.doingButton.selected? self.orderDoingArr[indexPath.row]: self.orderDoneArr[indexPath.row];
    if (self.doingButton.selected) {
         if (order.order_state ==0 || order.order_state ==1 || order.order_state ==2 || order.order_state ==7 ) {
             return MyOrderTableViewCellHeightReady;
         } else {
             return MyOrderTableViewCellHeightAll;
         }
    } else if (order.order_state == 7) {
        return 240;
    }
    return MyOrderTableViewCellHeightAll;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTableViewCell" forIndexPath:indexPath];
    MyOrderModel *order = self.doingButton.selected? self.orderDoingArr[indexPath.row]:
   
    self.orderDoneArr[indexPath.row];
    cell.topView.priceLabel.text = [NSString stringWithFormat:@"￥%@", order.total_price ? order.total_price : @""];
    NSString *str=order.p_order_time;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    cell.topView.dateLabel.text = currentDateStr;
    cell.topView.addressLabel.text = order.location ? order.location : @"";
   
    cell.topView.modelLabel.text = [NSString stringWithFormat:@"%@ %@ %@", order.c_brand?order.c_brand : @"", order.c_color ? order.c_color : @"", order.c_plate_num? order.c_plate_num: @""];
    cell.topView.orderNO.text = order.order_num ? order.order_num : @"";
    cell.topView.orderState.text = [order orderStateString];
    cell.topView.titleLabel.text = order.order_name ? order.order_name : @"";
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, order.emp_img]]];
    cell.nameLabel.text = order.emp_name;
    cell.summaryLabel.text = [NSString stringWithFormat:@"%@", @(order.order_reg_id)];
    [cell.scoreView setScore:[order.star floatValue]];
    cell.scoreLabel.text = [NSString stringWithFormat:@"%@分", @([order.star floatValue])];

    if (self.doingButton.selected) {
        [cell.locationButton setTitle:@"工作人员位置" forState:UIControlStateNormal];
        [cell.locationButton setImage:[UIImage imageNamed:@"1@icon_16"] forState:UIControlStateNormal];
        cell.locationButton.backgroundColor = [UIColor colorWithRed:0.08 green:0.8 blue:0.62 alpha:1];
        [cell.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [cell.cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    }
    if (self.completionButton.selected) {
        [cell.locationButton setTitle:@"评价" forState:UIControlStateNormal];
        [cell.locationButton setImage:[UIImage imageNamed:@"1@icon_16"] forState:UIControlStateNormal];
        cell.locationButton.backgroundColor = [UIColor orangeColor];
        [cell.cancelButton setTitle:@"投诉" forState:UIControlStateNormal];
        [cell.cancelButton setImage:[UIImage imageNamed:@"xbb_165"] forState:UIControlStateNormal];
    }
    cell.locationButton.tag = indexPath.row;
    cell.cancelButton.tag = indexPath.row;
    [cell.locationButton addTarget:self action:@selector(leftBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cancelButton addTarget:self action:@selector(rightBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.doingButton.selected) {
//        Class orderInfoVCClass = NSClassFromString(@"OrderInfoViewController");
//        id viewController = [[orderInfoVCClass alloc] init];
        MyOrderModel *order = self.doingButton.selected? self.orderDoingArr[indexPath.row]: self.orderDoneArr[indexPath.row];
        OrderInfoViewController *orderinfoVC = [[OrderInfoViewController alloc] init];
        NSLog(@"%ld------",order.orderId);
        orderinfoVC.order_id = [NSString stringWithFormat:@"%d",order.orderId];
        [self.navigationController pushViewController:orderinfoVC animated:YES];
    } else
        [self performSegueWithIdentifier:@"MyOrderPushDetailComplete" sender:self.doingButton.selected? self.orderDoingArr[indexPath.row]: self.orderDoneArr[indexPath.row]];
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
    if (buttonIndex == 1) {
        MyOrderModel *model = self.doingButton.selected? self.orderDoingArr[alertView.tag]: self.orderDoneArr[alertView.tag];
        [NetworkHelper postWithAPI:API_OrderCancel parameter:@{@"uid": [UserObj shareInstance].uid, @"order_id": @(model.orderId)} successBlock:^(id response) {
            if ([response[@"code"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOrderListUpdate object:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"取消失败"];
        }];
    }
}

@end
