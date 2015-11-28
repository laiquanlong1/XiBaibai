//
//  MyCarTableViewController.m
//  XBB
//
//  Created by Apple on 15/9/3.
//  Copyright (c) 2015年 Mingle. All rights reserved.

#import "MyCarTableViewController.h"
#import "MyCarTableViewCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UserObj.h"
#import "MyCarModel.h"
#import "UpdateCarInfoTableViewController.h"

@interface MyCarTableViewController ()

@property (strong, nonatomic) NSMutableArray *carArr;
@property (assign, nonatomic) NSInteger defaultId;

@end

@implementation MyCarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDefaultCar:) name:NotificationSetDefalutCar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotificationCarUpdate) name:NotificationCarListUpdate object:nil];
    [self initView];
    [SVProgressHUD show];
    [self fetchCarListFromWeb:^{
        [SVProgressHUD dismiss];
    }];
}

- (void)setDefaultCar:(NSNotification *)sender{
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    WS(weakSelf)
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf fetchCarListFromWeb:^{
            [weakSelf fetchCarListFromWeb:^{
                [weakSelf.tableView.header endRefreshing];
            }];
        }];
    }];
}

- (void)handleNotificationCarUpdate {
    [self.tableView.header beginRefreshing];
}

- (void)fetchCarListFromWeb:(void (^)())callback {
    [NetworkHelper postWithAPI:car_select parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
        if (self.tableView.header.isRefreshing) {
            [self.carArr removeAllObjects];
        }
        if (callback) {
            callback();
        }
        
        
        
        if ([response[@"code"] integerValue] == 1) {
            if (!self.carArr) {
                self.carArr = [NSMutableArray array];
            }
            self.defaultId = [[[response objectForKey:@"result"] objectForKey:@"default"] integerValue];
        
            NSArray *dataArr = [[response objectForKey:@"result"] objectForKey:@"list"];
            for (NSDictionary *temp in dataArr) {
                [MyCarModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"carId": @"id"};
                }];
                [self.carArr addObject:[MyCarModel objectWithKeyValues:temp]];
            }
            if (self.carArr.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"暂无车辆"];
            } else {
                [self.tableView reloadData];
            }
        }
    } failBlock:^(NSError *error) {
        if (callback) {
            callback();
        }
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

- (IBAction)backOnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)addOnClick:(id)sender {
    
}

- (void)deleteCarFromWebWithCar:(MyCarModel *)model callback:(void (^)(bool isSuccess))callback {
    [NetworkHelper postWithAPI:Car_Delete_API parameter:@{@"uid": [UserObj shareInstance].uid, @"id": @(model.carId), @"c_plate_num": model.c_plate_num} successBlock:^(id response) {
        if (callback) {
            if ([[response objectForKey:@"code"] integerValue] == 1) {
                callback(YES);
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            } else {
                callback(NO);
                [SVProgressHUD showErrorWithStatus:@"删除失败"];
            }
        }
    } failBlock:^(NSError *error) {
        if (callback) {
            callback(NO);
        }
        [SVProgressHUD showErrorWithStatus:@"删除失败"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.carArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCarTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MyCarModel *carModel = [self.carArr objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@", [carModel c_brand], carModel.c_color];
    cell.summaryLabel.text = carModel.c_plate_num;
    NSLog(@"defalutid%ld",self.defaultId);
    if (carModel.carId == self.defaultId) {
        [cell.btnDefault setTitle:@"默认车辆" forState:UIControlStateNormal];
        cell.btnDefault.userInteractionEnabled = NO;
        cell.btnDefault.tintColor = [UIColor whiteColor];
        cell.btnDefault.backgroundColor = kUIColorFromRGB(0xdb3735);
        cell.btnDefault.titleLabel.font = [UIFont systemFontOfSize:14];
        [cell.btnDefault mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(20);
        }];
    }else{
        [cell.btnDefault setTitle:@"设置为默认车辆" forState:UIControlStateNormal];
        cell.btnDefault.tintColor = [UIColor whiteColor];
        cell.btnDefault.backgroundColor = kUIColorFromRGB(0xb3b3b3);
        cell.btnDefault.titleLabel.font = [UIFont systemFontOfSize:14];
        [cell.btnDefault mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120);
             make.height.mas_equalTo(20);
        }];
        NSLog(@"defalut%ld",carModel.carId);
        cell.btnDefault.tag = carModel.carId;
        [cell.btnDefault addTarget:self action:@selector(setdefalutcar:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)setdefalutcar:(id)sender{
    UIButton *btn = (UIButton *)sender;
   
    [SVProgressHUD show];
    NSLog(@"defalut%ld",btn.tag);
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%@",[UserObj shareInstance].uid] forKey:@"uid"];
    [dic setObject:[NSString stringWithFormat:@"%ld",btn.tag] forKey:@"id"];
    [NetworkHelper postWithAPI:API_set_default_car parameter:dic successBlock:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        [btn setTitle:@"默认车辆" forState:UIControlStateNormal];
//        [self.tableView reloadData];
        [self.tableView.header beginRefreshing];
        NSLog(@"response%@",response);
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"设置失败"];
    }];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MyCarModel *model = [self.carArr objectAtIndex:indexPath.row];
    if (self.defaultId == model.carId) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:[NSString stringWithFormat:@"%@",[UserObj shareInstance].uid] forKey:@"uid"];
        [dic setObject:[NSString stringWithFormat:@"1"] forKey:@"id"];
        [NetworkHelper postWithAPI:API_set_default_car parameter:dic successBlock:^(id response) {
            [SVProgressHUD show];
            [self deleteCarFromWebWithCar:model callback:^(bool isSuccess) {
                [SVProgressHUD dismiss];
                if (isSuccess) {
                    [self.carArr removeObject:model];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];

        } failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
            
        }];
    }else{
    
    [SVProgressHUD show];
    [self deleteCarFromWebWithCar:model callback:^(bool isSuccess) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            [self.carArr removeObject:model];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"CarPushUpdateCar" sender:[self.carArr objectAtIndex:indexPath.row]];
}

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue.destinationViewController setValue:[sender isKindOfClass:[MyCarModel class]]?sender:nil forKey:@"carModel"];
}

@end
