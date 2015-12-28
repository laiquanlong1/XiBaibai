//
//  ServerCityViewController.m
//  XiBaibai
//
//  Created by xbb01 on 15/12/19.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "ServerCityViewController.h"

@interface ServerCityViewController ()<UITableViewDelegate,UITableViewDataSource>
{

}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *serversCityArray;
@end

@implementation ServerCityViewController

#pragma mark data

- (void)initViewDidLoadDatas
{
    [self toFeathData];
}
- (void)toFeathData
{
    [self feathData:^{
   
        [SVProgressHUD dismiss];
        DLog(@"%@",self.currentCity)
    }];
}
- (void)feathData:(void(^)(void))complation
{
    
    
    [NetworkHelper postWithAPI:ServerCity parameter:nil successBlock:^(id response) {
        DLog(@"%@",response)
        if ([response[@"code"] integerValue] == 1) {
            NSArray *citys = response[@"result"];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSString *string in citys) {
                [arr addObject:string];
            }
            self.serversCityArray = arr;
             [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
       
        
        
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
    }];
    
    if (complation) {
        complation();
    }
}

#pragma mark UI

- (void)initUI
{
    [self setNavigationBarControl];
    [self initTableView];
}

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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"服务城市"];
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


- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, XBB_Screen_width, XBB_Screen_height-65)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = XBB_Bg_Color;
    [_tableView setContentInset:XBB_HeadEdge];
    [self.view addSubview:_tableView];
}


#pragma mark action

- (IBAction)backViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.serversCityArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([[self.serversCityArray[indexPath.row] substringWithRange:NSMakeRange(0, [self.currentCity length])]isEqualToString:self.currentCity]) {
        [cell.textLabel setTextColor:[UIColor redColor]];
    }else
    {
         [cell.textLabel setTextColor:[UIColor grayColor]];
    }
    cell.textLabel.text = self.serversCityArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 100.;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = XBB_Bg_Color;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, XBB_Screen_width, 30)];
    label.text = @"我们正在努力为更多城市提供服务";
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont systemFontOfSize:13.]];
    [view addSubview:label];
    [label setBackgroundColor:[UIColor clearColor]];
    return view;
}


#pragma mark system

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
