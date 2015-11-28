//
//  SystemMsgViewController.m
//  XBB
//
//  Created by Apple on 15/9/3.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "SystemMsgViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SystemMsgTableViewCell.h"
#import "SystemMsgModel.h"
#import "UserObj.h"
#import <MJExtension.h>

@interface SystemMsgViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *msgTableView;
@property (strong, nonatomic) NSMutableArray *msgArr;

@end

@implementation SystemMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.msgTableView.estimatedRowHeight = 125;
    [self fetchMsgFromWeb:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backOnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchMsgFromWeb:(void (^)())callback {
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:API_SystemMsg parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
        [SVProgressHUD dismiss];
        [self.msgArr removeAllObjects];
        if ([response[@"code"] integerValue] == 1) {
            [SystemMsgModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"msgId": @"id"};
            }];
            if (!self.msgArr) {
                self.msgArr = [NSMutableArray array];
            }
            NSArray *dataArr = response[@"result"];
            for (NSDictionary *temp in dataArr) {
                [self.msgArr addObject:[SystemMsgModel objectWithKeyValues:temp]];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        [self.msgTableView reloadData];
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"SystemMsgTableViewCell" cacheByIndexPath:indexPath configuration:^(SystemMsgTableViewCell *cell) {
        [self configCellData:cell atIndexPath:indexPath];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemMsgTableViewCell" forIndexPath:indexPath];
    SystemMsgModel *model = [self.msgArr objectAtIndex:indexPath.row];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY.MM.dd HH:mm";
    cell.titleLabel.text = model.a_m_tit;
    cell.dateLabel.text = [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.a_m_time integerValue]]];
    cell.summaryLabel.text = model.a_m_con;
    return cell;
}

- (void)configCellData:(SystemMsgTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

@end
