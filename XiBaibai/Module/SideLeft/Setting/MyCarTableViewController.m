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


@interface MyCarTableViewController ()
{
    UILabel *nofoundLabel;
    UIView  *barView;
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
    [button setTitle:@"添加新车" forState:UIControlStateNormal];
    [barView addSubview:button];
    [self alphaTabBar:YES];
    
}


- (IBAction)backViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initUI
{
    [self setNavigationBarControl];
    [self addTabelView:UITableViewStyleGrouped];
    self.tableView.backgroundColor = XBB_Bg_Color;
    self.tableView.backgroundView = nil;
    
    [self registerCell];
    [self initNotDataUI];
//    [self addTabBar];
    
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
                if (self.carArr.count == 0) {
                    
                }
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
                [self alphaNoFound:NO];
            } else {
                [self.tableView reloadData];
                 [self alphaNoFound:YES];
            }
        }
    } failBlock:^(NSError *error) {
        if (callback) {
            callback();
        }
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

- (void)alphaNoFound:(BOOL)hidden
{
    if (hidden) {
        nofoundLabel.alpha = 0;
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            nofoundLabel.alpha = 1;
        }];
        
    }
    
}

- (void)initNotDataUI
{
    nofoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, XBB_Screen_height/2-XBB_Size_w_h(200), XBB_Screen_width, 50)];
    nofoundLabel.numberOfLines = 0;
    [nofoundLabel setTextAlignment:NSTextAlignmentCenter];
    nofoundLabel.text = NSLocalizedString(@"您还没有添加车辆信息哦~\n请添加您的爱车，方便技师查找", nil);
    [self.tableView addSubview:nofoundLabel];
    nofoundLabel.alpha = 0;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 120.;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XBB_Screen_width, 120.)];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor clearColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30., backView.bounds.size.height - 44., XBB_Screen_width - 60., 44.)];
    button.layer.cornerRadius = 5;
    button.layer.borderColor = XBB_NavBar_Color.CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.masksToBounds = YES;
    [button setTitle:@"添加新车" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
    [backView addSubview:button];
    [button setBackgroundColor:XBB_Bg_Color];
    return backView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.carArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyCarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.;
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
                    [UserObj shareInstance].c_id = nil;
                    [UserObj shareInstance].carModel = nil;
                    
                    [self.carArr removeObject:model];
                    if (self.carArr.count == 0) {
                        [self alphaNoFound:NO];
                    }
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
            if (self.carArr.count == 0) {
                [self alphaNoFound:NO];
            }
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XBBAddCarViewController *car = [[UIStoryboard storyboardWithName:@"XBBOne" bundle:nil] instantiateViewControllerWithIdentifier:@"XBBAddCarViewController"];
    car.carModel = self.carArr[indexPath.row];
    car.navigationTitle = @"修改车辆信息";
    [self.navigationController pushViewController:car animated:YES];
//    [self performSegueWithIdentifier:@"CarPushUpdateCar" sender:[self.carArr objectAtIndex:indexPath.row]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue.destinationViewController setValue:[sender isKindOfClass:[MyCarModel class]]?sender:nil forKey:@"carModel"];
}

@end
