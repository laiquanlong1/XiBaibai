//
//  CarListTableViewController.m
//  XiBaibai
//
//  Created by Apple on 15/9/20.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "CarListTableViewController.h"
#import "MJExtension.h"

@interface CarListTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *brandArr, *firstWordArr;
@property (strong, nonatomic) NSMutableDictionary *brandDic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CarListTableViewController


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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"选择车辆品牌"];
    [titelLabel setFont:XBB_NavBar_Font];
    [titelLabel setTextAlignment:NSTextAlignmentCenter];
    [self.xbbNavigationBar addSubview:titelLabel];
    [titelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30.);
        make.centerY.mas_equalTo(self.xbbNavigationBar).mas_offset(10.f);
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(XBB_Screen_width-100);
    }];
    self.tableView.alpha = 0.;
}
- (IBAction)backViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarControl];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = XBB_Bg_Color;
    [self fetchCarbrandFromWeb:nil];
}

- (void)backOnTouch {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchCarbrandFromWeb:(void (^)())callback {
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:API_AllCarbrandSelect parameter:nil successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            self.tableView.alpha = 1.;
            [CarBrandModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"brandId": @"id"};
            }];
            self.firstWordArr = [NSMutableArray array];
            
            for (NSDictionary *temp in response[@"result"]) {
                CarBrandModel *model = [CarBrandModel objectWithKeyValues:temp];
                if (![self.firstWordArr containsObject:model.first_letter]) {
                    [self.firstWordArr addObject:model.first_letter];
                }
            }
            self.brandDic = [NSMutableDictionary dictionary];
            for (NSString *firstWork in self.firstWordArr) {
                [self.brandDic setObject:[NSMutableArray array] forKey:firstWork];
            }
            for (NSDictionary *temp in response[@"result"]) {
                CarBrandModel *model = [CarBrandModel objectWithKeyValues:temp];
                NSMutableArray *arr = [self.brandDic objectForKey:model.first_letter];
                [arr addObject:model];
                
            }
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.firstWordArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.brandDic objectForKey:self.firstWordArr[section]] count];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.firstWordArr;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    CarBrandModel *model = [[self.brandDic objectForKey:self.firstWordArr[indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text =  model.make_name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@" %@", self.firstWordArr[section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CarBrandModel *model = [[self.brandDic objectForKey:self.firstWordArr[indexPath.section]] objectAtIndex:indexPath.row];
    if (self.brandSelectedCallback) {
        self.brandSelectedCallback(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
