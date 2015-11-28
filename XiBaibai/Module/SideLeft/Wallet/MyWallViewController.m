//
//  MyWallViewController.m
//  XBB
//
//  Created by Daniel on 15/8/28.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "MyWallViewController.h"
#import "MyPointsViewController.h"
#import "MyBalanceViewController.h"
#import "MyCouponsViewController.h"

@interface MyWallViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_dataList;
    NSArray *_imgList;
}

@end

@implementation MyWallViewController

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"我的钱包";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = title;
    //返回
    UIImageView * img_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_back.png"]];
    img_view.layer.masksToBounds=YES;
    img_view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fanhui)];
    [img_view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:img_view];
    
    UIScrollView *mainScrollView=[[UIScrollView alloc] init];
    [self.view addSubview:mainScrollView];
    mainScrollView.backgroundColor=kUIColorFromRGB(0xf6f5fa);
    mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-63);
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UITableView *tbView=[UITableView new];
    tbView.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 150);
    tbView.dataSource=self;
    tbView.delegate=self;
    tbView.layer.borderColor=kUIColorFromRGB(0xd9d9d9).CGColor;
    tbView.layer.borderWidth=0.5;
    tbView.scrollEnabled=NO;
    [mainScrollView addSubview:tbView];
    
}

- (void)initData{
    _dataList = @[@"积分",@"优惠券",@"余额"];
    _imgList = @[@"1@icon_jifen.png",@"1@icon_youhuiquan.png",@"1@icon_yue.png"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initData];
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indetity=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indetity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetity];
    }
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"%@",_imgList[indexPath.row]]];
    cell.imageView.frame=CGRectMake(20, 15, 20, 20);
    cell.imageView.image=img;
    cell.textLabel.text = _dataList[indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyPointsViewController *mypointsVC = [[MyPointsViewController alloc] init];
    
    MyCouponsViewController *myCouponsVC = [[MyCouponsViewController alloc] init];
    
    MyBalanceViewController *balanceVC = [[MyBalanceViewController alloc] init];
    
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:mypointsVC animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:myCouponsVC animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:balanceVC animated:YES];
            break;
        default:
            break;
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
