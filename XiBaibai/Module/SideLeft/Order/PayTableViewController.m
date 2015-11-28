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

#import "OrderPaySigleTableViewCell.h"
#import "OrderPayWayTableViewCell.h"
#import "OrderPayUserInfoTableViewCell.h"
#import "CarInfo.h"


@interface PayTableViewController () <UIActionSheetDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *priceArr;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (strong, nonatomic) UIImageView *selectedImgView;
@property (assign, nonatomic) NSInteger payType;//1支付宝


@property (nonatomic, assign) BOOL isDownOrder; // 是否下单

@end

@implementation PayTableViewController
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",buttonIndex);
    NSMutableDictionary *orderDic = [NSMutableDictionary dictionaryWithDictionary:self.dic_prama];
    // 下单时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    DLog(@"%@",currentDateStr);
    [orderDic setObject:currentDateStr?currentDateStr:@"" forKey:@"day"];
    
    
    
    if (buttonIndex==1) {
        [SVProgressHUD show];
        if (!self.data)
            [NetworkHelper postWithAPI:OrderInsert_API parameter:orderDic successBlock:^(id response) {
                if ([response[@"code"] integerValue] == 1) {
                    self.orderNO = [[response objectForKey:@"result"] objectForKey:@"order_num"];
                    self.orderName = response[@"result"][@"order_name"];
                    self.price = [response[@"result"][@"total_price"] doubleValue];
                    self.orderId = [NSString stringWithFormat:@"%@", response[@"result"][@"id"]];
                    [SVProgressHUD showSuccessWithStatus:@"下单成功"];
                    [self toPay];
                    self.isDownOrder = YES;
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
            } failBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"下单失败"];
            }];
        else {
            AFHTTPRequestOperationManager *uploadManager = [AFHTTPRequestOperationManager manager];
            uploadManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [uploadManager POST:OrderInsert_API parameters:orderDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:self.data name:[NSString stringWithFormat:@"file"] fileName:[NSString stringWithFormat:@"file.aac"] mimeType:@"file/.aac"];
            } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                NSLog(@"%@", responseObject);
                id response = responseObject;
                if ([response[@"code"] integerValue] == 1) {
                    self.orderNO = [[response objectForKey:@"result"] objectForKey:@"order_num"];
                    self.orderName = response[@"result"][@"order_name"];
                    self.price = [response[@"result"][@"total_price"] doubleValue];
                    self.orderId = [NSString stringWithFormat:@"%@", response[@"result"][@"id"]];
                    [SVProgressHUD showSuccessWithStatus:@"下单成功"];
                    [self toPay];
                    self.isDownOrder = YES;
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:@"下单失败"];
            }];
        }

    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOfPay:) name:NotificationRecharge object:nil];
    self.priceArr = @[@"10", @"20", @"30", @"50", @"100"];
    self.orderNameLabel.text = self.orderName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", @(self.price)];
    _selectedImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xbb_168"]];
    
    //请求产品标题
    
    if (self.dic) {
        [NetworkHelper postWithAPI:API_orderName_price parameter:@{@"p_ids":[self.dic objectForKey:@"p_ids"]} successBlock:^(id response) {
            [SVProgressHUD dismiss];
            self.orderName = response[@"result"][@"order_name"];
            NSLog(@"pro %@",response);
            
            
#pragma mark 改价格  哈哈
            
            self.price = [[NSString stringWithFormat:@"%@",response[@"result"][@"order_price"]] doubleValue];
            self.orderNameLabel.text = self.orderName;
            self.priceLabel.text = [NSString stringWithFormat:@"%@", @(self.price)];
        } failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"信息有误"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    // 是否是有订单
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
        if (result.isSuccessful) {
            if (self.isRecharge == NO)
                [self performSegueWithIdentifier:@"PayPushPayCallback" sender:nil];
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

- (IBAction)backOnClick:(id)sender {
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:NSClassFromString(@"PayCallbackViewController")]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return @"用户信息";
        }
            break;
        case 1:
        {
            return @"车辆信息";
        }
            break;
        case 2:
        {
            return @"产品信息";
        }
            break;

        case 4:
        {
            return @"支付方式";
        }
            break;
        case 5:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 2:
        {
            return self.pro_Dics.count; // 产品数据
        }
            break;
        case 0:
        {
            return 2; // 用户信息数据
        }
            break;
        case 1:
        {
            return 4; // 车辆信息数据
        }
            break;
        case 3:
        {
            return 2; // 价格
        }
            
        default:
            break;
    }
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 2:
        {
            
            OrderPaySigleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderServer" forIndexPath:indexPath];
            NSDictionary *dic = self.pro_Dics[indexPath.row];
            cell.nameLabel.text = dic[@"p_info"];
            
            switch (self.carType) {
                case 1:
                {
                    cell.priceLabel.text = [NSString stringWithFormat:@"¥：%.2f",[dic[@"p_price"] floatValue]];
                }
                    break;
                    
                default:
                {
                    cell.priceLabel.text = [NSString stringWithFormat:@"¥：%.2f",[dic[@"p_price2"] floatValue]];
                }
                    break;
            }
            
            
            return cell;
        }
            break;
        case 3:
        {
            OrderPaySigleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderServer" forIndexPath:indexPath];
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.nameLabel.text = @"优惠券抵扣:";
                    [cell.priceLabel setTextColor:[UIColor orangeColor]];
                    [cell.priceLabel setFont:[UIFont systemFontOfSize:16]];
                    cell.priceLabel.text = [NSString stringWithFormat:@"¥：%.2f",self.couponprice<=0?0.00:-self.couponprice];
                }
                    break;
                case 1:
                {
                    cell.nameLabel.text = @"总金额";
                    [cell.priceLabel setFont:[UIFont systemFontOfSize:20]];
                    [cell.priceLabel setTextColor:[UIColor redColor]];
                    cell.priceLabel.text = [NSString stringWithFormat:@"¥：%.2f",self.price];
                }
                    break;
                    
                default:
                    break;
            }
            
           
            return cell;
        }
            break;
        case 4:
        {
            OrderPayWayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderpay" forIndexPath:indexPath];
            cell.headImageView.image = [UIImage imageNamed:@"alipay_logo"];
            return cell;
        }
            break;
        case 5:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sure" forIndexPath:indexPath];
            return cell;
        }
            break;
            
        case 0:
        {
            // 名称
            OrderPayUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderName" forIndexPath:indexPath];
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.nameLabel.text = @"用户:";
                    cell.contentLabel.text = [[UserObj shareInstance] uname];
                }
                    break;
                case 1:
                {
                    cell.nameLabel.text = @"电话:";
                    cell.contentLabel.text = [[UserObj shareInstance] iphone];
                }
                    break;
                    
                default:
                    break;
            }
           
            
            
            return cell;
        }
            break;
        case 1:
        {
            // 车信息
            OrderPayUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderName" forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:
                {
                    cell.nameLabel.text = @"车牌号";
                    cell.contentLabel.text = self.carInfo[@"c_plate_num"];
                }
                    break;
                case 1:
                {
                    cell.nameLabel.text = @"车型";
                    NSInteger type = [self.carInfo[@"c_type"] integerValue];
                    NSString *c_type =type==0 ? @"":[CarInfo carType:type];
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@/%@",self.carInfo[@"c_brand"],c_type];
                }
                    break;
                case 2:
                {
                    cell.nameLabel.text = @"颜色";
                    cell.contentLabel.text = self.carInfo[@"c_color"];
                }
                    break;
                case 3:
                {
                    cell.nameLabel.text = @"停放位置";
                    cell.contentLabel.text = self.location?self.location:@"";
                }
                    break;
                    
                default:
                    break;
            }
        
            
            
            
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1 && self.isRecharge) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择充值金额" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
            for (NSString *price in self.priceArr) {
                [actionSheet addButtonWithTitle:price];
            }
            [actionSheet showInView:self.view];
        }
    } else if (indexPath.section == 4) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        _selectedImgView.frame = CGRectMake(self.view.frame.size.width - 15 - _selectedImgView.frame.size.width, cell.frame.size.height * 0.5 - _selectedImgView.frame.size.height * 0.5, _selectedImgView.frame.size.width, _selectedImgView.frame.size.height);
        [cell.contentView addSubview:_selectedImgView];
        _payType = indexPath.row + 1;
        if (indexPath.row == 0) {
//            if (self.isRecharge == NO) {
//                [RechargeHelper setAliPayNotifyURLString:[NSString stringWithFormat:@"%@?recharge_type=%@", Notify_AlipayCallback_Url, @"1"]];
//                [[RechargeHelper defaultRechargeHelper] payAliWithMoney:[self.priceLabel.text doubleValue] orderNO:self.orderNO productTitle:self.orderNameLabel.text productDescription:self.orderName];
//            } else {
//                [NetworkHelper postWithAPI:API_Recharge parameter:@{@"uid": [UserObj shareInstance].uid, @"money": self.priceLabel.text} successBlock:^(id response) {
//                    if ([response[@"code"] integerValue] == 1) {
//                        NSString *orderNO = [[response objectForKey:@"result"] objectForKey:@"recharge_num"];
//                        NSString *orderName = response[@"result"][@"recharge_name"];
//                        double price = [response[@"result"][@"recharge_price"] doubleValue];
////                        NSString *orderId = [NSString stringWithFormat:@"%@", response[@"result"][@"id"]];
//                        [[RechargeHelper defaultRechargeHelper] payAliWithMoney:price orderNO:orderNO productTitle:orderName productDescription:orderName];
//                    } else {
//                        [SVProgressHUD showErrorWithStatus:response[@"msg"]];
//                    }
//                } failBlock:^(NSError *error) {
//                    [SVProgressHUD showErrorWithStatus:@"充值失败"];
//                }];
//            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"暂未开通"];
        }
    }
}

- (IBAction)submitPayOnTouch:(id)sender {
    
    if (self.isDownOrder) {
        [self toPay];
    }
    else
    {
        if (_payType == 1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认下单" message:@"是否下单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
        }
    }
}

// 支付
- (void)toPay
{
    if (self.isDownOrder) {
        if (self.isRecharge == NO) {
            [RechargeHelper setAliPayNotifyURLString:[NSString stringWithFormat:@"%@?recharge_type=%@", Notify_AlipayCallback_Url, @"1"]];
            [[RechargeHelper defaultRechargeHelper] payAliWithMoney:self.price orderNO:self.orderNO productTitle:self.orderName productDescription:self.orderName];
        } else {
            [NetworkHelper postWithAPI:API_Recharge parameter:@{@"uid": [UserObj shareInstance].uid, @"money": [NSString stringWithFormat:@"%.2f",self.price]} successBlock:^(id response) {
                if ([response[@"code"] integerValue] == 1) {
                    NSString *orderNO = [[response objectForKey:@"result"] objectForKey:@"recharge_num"];
                    NSString *orderName = response[@"result"][@"recharge_name"];
                    double price = [response[@"result"][@"recharge_price"] doubleValue];
                    //                        NSString *orderId = [NSString stringWithFormat:@"%@", response[@"result"][@"id"]];
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
                    [[RechargeHelper defaultRechargeHelper] payAliWithMoney:self.price orderNO:self.orderNO productTitle:self.orderName productDescription:self.orderName];
                } else {
                    [NetworkHelper postWithAPI:API_Recharge parameter:@{@"uid": [UserObj shareInstance].uid, @"money": self.priceLabel.text} successBlock:^(id response) {
                        if ([response[@"code"] integerValue] == 1) {
                            NSString *orderNO = [[response objectForKey:@"result"] objectForKey:@"recharge_num"];
                            NSString *orderName = response[@"result"][@"recharge_name"];
                            double price = [response[@"result"][@"recharge_price"] doubleValue];
                            //                        NSString *orderId = [NSString stringWithFormat:@"%@", response[@"result"][@"id"]];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"%@", self.priceArr[buttonIndex - 1]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"PayPushPayCallback"]) {
        [segue.destinationViewController setValue:_orderId forKey:@"orderId"];
    }
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
