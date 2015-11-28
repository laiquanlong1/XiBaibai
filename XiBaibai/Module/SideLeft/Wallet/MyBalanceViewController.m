//
//  MyBalanceViewController.m
//  XBB
//
//  Created by Daniel on 15/8/28.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "MyBalanceViewController.h"
#import "UserObj.h"
#import "PayTableViewController.h"
#import "UserPayManagerModel.h"
#import <MJExtension.h>

@interface MyBalanceViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    UILabel *labPoints;
    UITableView *tbViewDeatil;
}

@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation MyBalanceViewController

- (void)initView{
    self.title = @"我的余额";
    //返回
    UIImageView * img_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_back.png"]];
    img_view.layer.masksToBounds=YES;
    img_view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fanhui)];
    [img_view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:img_view];
    
    tbViewDeatil = [[UITableView alloc] init];
    //    tbViewDeatil.scrollEnabled=NO;
    //tbViewDeatil.frame = CGRectMake(0, 230, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-220);
    tbViewDeatil.backgroundColor = kUIColorFromRGB(0xf6f5fa);
    tbViewDeatil.delegate = self;
    tbViewDeatil.dataSource = self;
    tbViewDeatil.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbViewDeatil];
    [tbViewDeatil mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIView *topView = [UIView new];
    topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 220);
    topView.backgroundColor = [UIColor clearColor];
    tbViewDeatil.tableHeaderView = topView;
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(self.view);
//        make.height.mas_equalTo(220);
//    }];
    
    UIView *viewRound = [UIView new];
    viewRound.backgroundColor=kUIColorFromRGB(0xfdb961);
    viewRound.layer.masksToBounds=YES;
    viewRound.layer.cornerRadius=50;
    [topView addSubview:viewRound];
    [viewRound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
        make.centerX.mas_equalTo(topView).mas_offset(0);
        make.centerY.mas_equalTo(topView).mas_offset(-40);
    }];
    
    UILabel *labPointstitle = [UILabel new];
    labPointstitle.text = @"余额";
    labPointstitle.textColor = kUIColorFromRGB(0xfdf0e5);
    [viewRound addSubview:labPointstitle];
    [labPointstitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewRound).mas_offset(0);
        make.centerY.mas_equalTo(viewRound).mas_offset(-15);
    }];
    
    labPoints = [UILabel new];
    labPoints.textColor = kUIColorFromRGB(0xFFFFFF);
    labPoints.font = [UIFont boldSystemFontOfSize:20];
    labPoints.text = @"0";
    [viewRound addSubview:labPoints];
    [labPoints mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewRound).mas_offset(0);
        make.centerY.mas_equalTo(viewRound).mas_offset(10);
    }];
    
    UIButton *btnPointsMall = [UIButton new];
    btnPointsMall.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    btnPointsMall.layer.borderWidth=1;
    btnPointsMall.layer.borderColor=kUIColorFromRGB(0xe9e9e9).CGColor;
    btnPointsMall.layer.masksToBounds=YES;
    btnPointsMall.layer.cornerRadius=5;
    [topView addSubview:btnPointsMall];
    [btnPointsMall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(topView).mas_offset(0);
        make.centerY.mas_equalTo(topView).mas_offset(50);
    }];
    [btnPointsMall addTarget:self action:@selector(rechargeOnTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labbtnTitle=[UILabel new];
    labbtnTitle.text=@"提现";
    labbtnTitle.textColor=kUIColorFromRGB(0xec9e21);
    [btnPointsMall addSubview:labbtnTitle];
    [labbtnTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnPointsMall).mas_offset(0);
        make.centerX.mas_equalTo(btnPointsMall).mas_offset(0);
    }];
    
    UIImageView *imgView_Mall=[UIImageView new];
    imgView_Mall.image =[UIImage imageNamed:@"1@icon_money.png"];
    [btnPointsMall addSubview:imgView_Mall];
    [imgView_Mall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(btnPointsMall).mas_offset(0);
        make.centerX.mas_equalTo(btnPointsMall).mas_offset(-30);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = kUIColorFromRGB(0xe4e4e6);
    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(topView.mas_bottom).mas_offset(-15);
    }];
    
    
    UILabel *labDetail = [UILabel new];
    labDetail.textColor = kUIColorFromRGB(0x868686);
    labDetail.backgroundColor = kUIColorFromRGB(0xf6f5fa);
    labDetail.textAlignment = NSTextAlignmentCenter;
    labDetail.text = @"财务流水";
    [topView addSubview:labDetail];
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.bottom.mas_equalTo(topView.mas_bottom).mas_offset(-5);
        make.centerX.mas_equalTo(topView).mas_offset(0);
    }];
    
}

- (void)fetchBalanceFromWeb:(void (^)())callback {
    [NetworkHelper postWithAPI:API_Balance parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            labPoints.text = [NSString stringWithFormat:@"%@", [[response objectForKey:@"result"] objectForKey:@"money"]];
        }
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)fetchMoneyRecordFromWeb:(void (^)())callback {
    [NetworkHelper postWithAPI:API_MoneyRecord parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
        self.dataArr = [NSMutableArray array];
        if ([response[@"code"] integerValue] == 1) {
            for (NSDictionary *temp in response[@"result"]) {
                UserPayManagerModel *model = [UserPayManagerModel objectWithKeyValues:temp];
                [self.dataArr addObject:model];
            }
        }
        [tbViewDeatil reloadData];
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)rechargeOnTouch {
    if ([labPoints.text doubleValue] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入提现金额" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    } else {
        [SVProgressHUD showErrorWithStatus:@"没有可提现的金额"];
    }
//    PayTableViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayTableViewController"];
//    viewController.orderName = @"洗白白在线充值";
//    viewController.price = 10;
//    viewController.isRecharge = YES;
//    
//    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tbViewDeatil mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-300));
    }];
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = kUIColorFromRGB(0xf6f5fa);
    
    UserPayManagerModel *model = self.dataArr[indexPath.row];
    UILabel *labLine= (UILabel *)[cell.contentView viewWithTag:99];
    if (!labLine) {
        labLine = [UILabel new];
    }
    labLine.tag = 99;
    labLine.textColor = kUIColorFromRGB(0xd2d2d4);
    labLine.text = @".............................................................................";
    [cell.contentView addSubview:labLine];
    [labLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(cell.contentView.mas_bottom).mas_offset(5);
    }];
    
    UILabel *labNumber = (UILabel *)[cell.contentView viewWithTag:98];
    if (!labNumber) {
        labNumber = [UILabel new];
    }
    labNumber.tag = 98;
    labNumber.text = [model signMoney];
    labNumber.textColor = kUIColorFromRGB(0xfdb961);
    [cell.contentView addSubview:labNumber];
    [labNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell.contentView).mas_offset(-15);
        make.centerY.mas_equalTo(cell.contentView).mas_offset(0);
    }];
    
    cell.textLabel.text = model.operate_type == 1 ? @"收入" : @"支出";
    if (model.operate_type == 3)
        cell.textLabel.text = @"提现";
    cell.textLabel.textColor = kUIColorFromRGB(0x58585a);
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY.MM.dd HH:mm";
    cell.detailTextLabel.text = [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.operate_time doubleValue]]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = kUIColorFromRGB(0x99999a);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self fetchBalanceFromWeb:nil];
    [self fetchMoneyRecordFromWeb:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMoneyDidUpdate) name:NotificationMoneyUpdate object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleMoneyDidUpdate {
    [self fetchBalanceFromWeb:nil];
    [self fetchMoneyRecordFromWeb:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *inputStr = [alertView textFieldAtIndex:0].text;
        if ([labPoints.text doubleValue] > 0 && [inputStr doubleValue] <= [labPoints.text doubleValue] && [inputStr doubleValue] > 0) {
            [NetworkHelper postWithAPI:API_ApplyFor parameter:@{@"uid": [UserObj shareInstance].uid, @"money": inputStr} successBlock:^(id response) {
                if ([response[@"code"] integerValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"申请成功"];
                    [self fetchBalanceFromWeb:nil];
                    [self fetchMoneyRecordFromWeb:nil];
                } else {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
            } failBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"申请失败"];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的金额"];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
