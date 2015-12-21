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
//#import "UpdateCarInfoTableViewController.h"
#import "XBBAddCarViewController.h"


@interface MyCarTableViewController ()<UIAlertViewDelegate>
{
    UIView  *barView;
    XBBNotDataView *noDataView;
}
@property (strong, nonatomic) NSMutableArray *carArr;
@property (assign, nonatomic) NSInteger defaultId;

@end


static NSString *identifier = @"carcell";


@implementation MyCarTableViewController


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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"常用车辆"];
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


- (void)alphaTabBar:(BOOL)hidden
{
    if (hidden) {
        barView.alpha = 0;
    }
    else
    {
        barView.alpha = 1;
    }
}

- (void)addTabBar
{
    barView = [[UIView alloc] initWithFrame:CGRectMake(0, XBB_Screen_height-80., XBB_Screen_width, 80.)];
    barView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:barView];
//    barView.backgroundColor = XBB_Bg_Color;
//    barView.layer.borderWidth = 0.5;
//    barView.layer.borderColor = XBB_NavBar_Color.CGColor;
    

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, XBB_Screen_width-60, 44)];
    [button addTarget:self action:@selector(addOnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = XBB_Bg_Color;
    button.layer.borderColor = XBB_NavBar_Color.CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
    [button setTitle:@"添加车辆" forState:UIControlStateNormal];
    [barView addSubview:button];
    [self alphaTabBar:YES];
    
}


- (IBAction)backViewController:(id)sender
{
    if (self.isDownOrder) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)initNoDataUI
{
    noDataView = [[XBBNotDataView alloc] initWithFrame:self.view.bounds withImage:[UIImage imageNamed:@"41我的车辆无数据"] withString:@"您还没有车辆信息哦" withButtonTitle:@"现在添加"];
    [self.view addSubview:noDataView];
    [noDataView.sureButton addTarget:self action:@selector(addOnClick:) forControlEvents:UIControlEventTouchUpInside];
    noDataView.alpha = 0;
}

- (void)initUI
{
    [self initNoDataUI];
    [self setNavigationBarControl];
    [self addTabelView:UITableViewStylePlain];
    self.tableView.header.ignoredScrollViewContentInsetTop = 6;
    self.tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
    self.tableView.backgroundColor = XBB_Bg_Color;
    self.tableView.backgroundView = nil;
    [self registerCell];
}
- (void)registerCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCarTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    self.tableView.alpha = 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDefaultCar:) name:NotificationSetDefalutCar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotificationCarUpdate) name:NotificationCarListUpdate object:nil];
    [self initView];
    [SVProgressHUD show];
    [self fetchCarListFromWeb:^{
        [SVProgressHUD dismiss];
        [UIView animateWithDuration:0.3 animations:^{
            if (self.carArr.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"暂无车辆"];
                self.tableView.alpha = 0.;
                noDataView.alpha = 1;
                
            } else {
                self.tableView.alpha = 1.;
                noDataView.alpha = 0;
                
            }
        } completion:^(BOOL finished) {
            
            [self.tableView reloadData];
        }];
  
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

            [UIView animateWithDuration:0.3 animations:^{
                if (self.carArr.count == 0) {
                    [SVProgressHUD showErrorWithStatus:@"暂无车辆"];
                    self.tableView.alpha = 0.;
                    noDataView.alpha = 1;
                    
                } else {
                    self.tableView.alpha = 1.;
                    noDataView.alpha = 0;
                    
                }
            } completion:^(BOOL finished) {
                [self.tableView reloadData];
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
        self.tableView.alpha = 1;
        if (self.tableView.header.isRefreshing) {
            [self.carArr removeAllObjects];
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
        }
        if (callback) {
            callback();
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
    XBBAddCarViewController *add = [[UIStoryboard storyboardWithName:@"XBBOne" bundle:nil] instantiateViewControllerWithIdentifier:@"XBBAddCarViewController"]; //[[XBBAddCarViewController alloc] init];
    add.navigationTitle = @"添加车辆";
    [self.navigationController pushViewController:add animated:YES];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.carArr.count-1) {
        return 120;
    }
    return 6.;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == self.carArr.count-1) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XBB_Screen_width, 120.)];
        backView.userInteractionEnabled = YES;
        backView.backgroundColor = [UIColor clearColor];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30., backView.bounds.size.height - 44., XBB_Screen_width - 60., 44.)];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = XBB_NavBar_Color.CGColor;
        button.layer.borderWidth = 1.0;
        button.layer.masksToBounds = YES;
        [button setTitle:@"添加车辆" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
        [backView addSubview:button];
        [button setBackgroundColor:XBB_Bg_Color];
        return backView;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.carArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.title isEqualToString:@"设置默认车辆"]) {
        if (buttonIndex == 1) {
            [SVProgressHUD show];
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:[NSString stringWithFormat:@"%@",[UserObj shareInstance].uid] forKey:@"uid"];
            [dic setObject:[NSString stringWithFormat:@"%ld",alertView.tag] forKey:@"id"];
            [NetworkHelper postWithAPI:API_set_default_car parameter:dic successBlock:^(id response) {
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
                if (self.isDownOrder) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.complation();
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    });
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCarListUpdate object:nil];
                
            } failBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"设置失败"];
            }];

        }
        
        
        return;
    }
    
    
    
    if (buttonIndex == 1) {
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:alertView.tag];
        [self  tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:index];
    }
}
- (IBAction)deleteButtonAction:(id)sender
{
    
    UIButton *button = sender;
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除车辆?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = button.tag;
    [alert show];
    
    
}

- (IBAction)editButtonAction:(id)sender
{
    DLog(@"")
    UIButton *button = sender;
    XBBAddCarViewController *car = [[UIStoryboard storyboardWithName:@"XBBOne" bundle:nil] instantiateViewControllerWithIdentifier:@"XBBAddCarViewController"];
    car.carModel = self.carArr[button.tag];
    car.navigationTitle = @"修改车辆信息";
    [self.navigationController pushViewController:car animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyCarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MyCarModel *carModel = [self.carArr objectAtIndex:indexPath.section];
    cell.titleLabel.text = carModel.c_plate_num;
    cell.summaryLabel.text = [NSString stringWithFormat:@"%@  %@  %@", [carModel c_brand], carModel.c_color,[carModel typeString]];//
    
    cell.deleteButton.tag = indexPath.section;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.editButton.tag = indexPath.section;
    
    if (carModel.carId == self.defaultId) {
        [cell.btnDefault setTitle:@"默认车辆" forState:UIControlStateNormal];
        [cell.btnDefault setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
        [cell.btnDefault setImage:[UIImage imageNamed:@"默认车辆"] forState:UIControlStateNormal];
        cell.btnDefault.userInteractionEnabled = NO;
        
    }else{
        [cell.btnDefault setTitle:@"设置默认" forState:UIControlStateNormal];
        cell.btnDefault.tag = carModel.carId;
        cell.btnDefault.userInteractionEnabled = YES;
        [cell.btnDefault setImage:[UIImage imageNamed:@"常用车辆设为默认"] forState:UIControlStateNormal];
        [cell.btnDefault setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cell.btnDefault addTarget:self action:@selector(setdefalutcar:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)setdefalutcar:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (self.isDownOrder) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设置默认车辆" message:@"轿车与suv的价格有所不同，确认设置?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = btn.tag;
        [alert show];
        return;
    }
   
    
   
    [SVProgressHUD show];
    NSLog(@"defalut%ld",btn.tag);
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%@",[UserObj shareInstance].uid] forKey:@"uid"];
    [dic setObject:[NSString stringWithFormat:@"%ld",btn.tag] forKey:@"id"];
    [NetworkHelper postWithAPI:API_set_default_car parameter:dic successBlock:^(id response) {
        [btn setTitle:@"默认车辆" forState:UIControlStateNormal];
        [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        if (self.isDownOrder) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.complation();
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
            });
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCarListUpdate object:nil];
        
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"设置失败"];
    }];
}

// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}

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
                    [UserObj shareInstance].c_id = nil;
                    [UserObj shareInstance].carModel = nil;
                    [self.carArr removeObject:model];
                    if (self.carArr.count == 0) {
                        [UIView animateWithDuration:0.3 animations:^{
                            if (self.carArr.count == 0) {
                                [SVProgressHUD showErrorWithStatus:@"暂无车辆"];
                                self.tableView.alpha = 0.;
                                noDataView.alpha = 1;
                                
                            } else {
                                self.tableView.alpha = 1.;
                                noDataView.alpha = 0;
                                
                            }
                        } completion:^(BOOL finished) {
                            
                            
                        }];

                    }
                    NSIndexSet *set= [[NSIndexSet alloc] initWithIndex:indexPath.section];
                    [tableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView reloadData];
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
            if (self.carArr.count == 0) {
                [UIView animateWithDuration:0.3 animations:^{
                    if (self.carArr.count == 0) {
                        [SVProgressHUD showErrorWithStatus:@"暂无车辆"];
                        self.tableView.alpha = 0.;
                        noDataView.alpha = 1;
                        
                    } else {
                        self.tableView.alpha = 1.;
                        noDataView.alpha = 0;
                        
                    }
                } completion:^(BOOL finished) {
                }];
            }
            NSIndexSet *set= [[NSIndexSet alloc] initWithIndex:indexPath.section];
            [tableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }
    }];
    }
 

    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue.destinationViewController setValue:[sender isKindOfClass:[MyCarModel class]]?sender:nil forKey:@"carModel"];
}

@end
