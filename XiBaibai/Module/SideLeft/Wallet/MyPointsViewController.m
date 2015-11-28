//
//  MyPointsViewController.m
//  XBB
//
//  Created by Daniel on 15/8/28.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "MyPointsViewController.h"
#import "UserObj.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "MyCouponsModel.h"
#import "MyPointsModel.h"

@interface MyPointsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UILabel *labPoints;
    UITableView *tbViewDeatil;
}

@property (strong, nonatomic) NSMutableArray *couDoneArr;

@end

@implementation MyPointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [tbViewDeatil.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的积分";
    //返回
    UIImageView * img_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_back.png"]];
    img_view.layer.masksToBounds=YES;
    img_view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fanhui)];
    [img_view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:img_view];
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    
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
    labPointstitle.text = @"积分";
    labPointstitle.textColor = kUIColorFromRGB(0xfdf0e5);
    [viewRound addSubview:labPointstitle];
    [labPointstitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewRound).mas_offset(0);
        make.centerY.mas_equalTo(viewRound).mas_offset(-20);
    }];
    
    labPoints = [UILabel new];
    labPoints.textColor = kUIColorFromRGB(0xFFFFFF);
    labPoints.font = [UIFont boldSystemFontOfSize:30];
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
    [btnPointsMall addTarget:self action:@selector(usePointBtnOnTouch) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btnPointsMall];
    [btnPointsMall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(topView).mas_offset(0);
        make.centerY.mas_equalTo(topView).mas_offset(50);
    }];
    
    UILabel *labbtnTitle=[UILabel new];
    labbtnTitle.text=@"积分兑换商城";
    labbtnTitle.textColor=kUIColorFromRGB(0xec9e21);
    [btnPointsMall addSubview:labbtnTitle];
    [labbtnTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnPointsMall).mas_offset(0);
        make.centerX.mas_equalTo(btnPointsMall).mas_offset(10);
    }];
    
    UIImageView *imgView_Mall=[UIImageView new];
    imgView_Mall.image =[UIImage imageNamed:@"1@icon_Mall.png"];
    [btnPointsMall addSubview:imgView_Mall];
    [imgView_Mall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(16);
        make.centerY.mas_equalTo(btnPointsMall).mas_offset(0);
        make.centerX.mas_equalTo(btnPointsMall).mas_offset(-60);
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
    labDetail.text = @"积分明细";
    [topView addSubview:labDetail];
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.bottom.mas_equalTo(topView.mas_bottom).mas_offset(-5);
        make.centerX.mas_equalTo(topView).mas_offset(0);
    }];
    
    tbViewDeatil = [[UITableView alloc] init];
    tbViewDeatil.backgroundColor = kUIColorFromRGB(0xf6f5fa);
    tbViewDeatil.delegate = self;
    tbViewDeatil.dataSource = self;
    tbViewDeatil.separatorStyle= UITableViewCellSeparatorStyleNone;
    tbViewDeatil.tableHeaderView = topView;
    [self.view addSubview:tbViewDeatil];
    [tbViewDeatil mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // 2.集成刷新控件
    [self setupRefresh];
    
}

- (void)usePointBtnOnTouch {
    [SVProgressHUD showErrorWithStatus:@"敬请期待"];
}

- (void)setupRefresh
{
    self.view.backgroundColor = [UIColor whiteColor];
    WS(weakSelf)
    tbViewDeatil.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf fetchCouponsFromWeb:^{
            [tbViewDeatil.header endRefreshing];
            [tbViewDeatil.footer resetNoMoreData];
        }];
    }];
    /*
    tbViewDeatil.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf fetchCouponsFromWeb:^{
            [tbViewDeatil.footer endRefreshing];
        }];
    }];
     */
}

- (void)fetchCouponsFromWeb:(void (^)())callback {
    [SVProgressHUD show];
    [NetworkHelper getWithAPI:API_MyPointsSelect parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
        if (callback)
            callback();
        self.couDoneArr = [NSMutableArray array];
        NSLog(@"dic%@",response);
        if ([response[@"code"] integerValue] == 1) {
            labPoints.text = [NSString stringWithFormat:@"%@", response[@"total_points"]];
            for (NSDictionary *temp in response[@"result"][@"list"]) {
                [MyPointsModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"pointId": @"id"};
                }];
                MyPointsModel *model = [MyPointsModel objectWithKeyValues:temp];
                
                [self.couDoneArr addObject:model];
                
                
                if (self.couDoneArr == 0) {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                    [tbViewDeatil.footer noticeNoMoreData];
                } else {
                    [SVProgressHUD dismiss];
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        [tbViewDeatil reloadData];
    } failBlock:^(NSError *error) {
        if (callback)
            callback();
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.couDoneArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
        UILabel *labLine=[UILabel new];
        labLine.textColor = kUIColorFromRGB(0xd2d2d4);
        labLine.text = @".............................................................................";
        [cell.contentView addSubview:labLine];
        [labLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(cell.contentView.mas_bottom).mas_offset(5);
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = kUIColorFromRGB(0xf6f5fa);
    
    MyPointsModel *model = self.couDoneArr[indexPath.row];
    
    UILabel *labNumber = (UILabel *)[cell.contentView viewWithTag:99];
    if (!labNumber) {
        labNumber = [UILabel new];
        labNumber.tag = 99;
    }
    labNumber.text = model.type == 1? [NSString stringWithFormat:@"+%@", model.points]: [NSString stringWithFormat:@"-%@", model.points];
    labNumber.textColor = kUIColorFromRGB(0xfdb961);
    [cell.contentView addSubview:labNumber];
    [labNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell.contentView).mas_offset(-15);
        make.centerY.mas_equalTo(cell.contentView).mas_offset(0);
    }];
    
    cell.textLabel.text = model.point_name;
    cell.textLabel.textColor = kUIColorFromRGB(0x58585a);
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY.MM.dd HH:mm";
    
    cell.detailTextLabel.text = [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.time doubleValue]]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = kUIColorFromRGB(0x99999a);

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
    
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
