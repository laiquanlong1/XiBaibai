//
//  SettingTableViewController.m
//  XBB
//
//  Created by Apple on 15/9/3.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "SettingTableViewController.h"
#import "WebViewController.h"
#import "BPush.h"
#import "UserObj.h"

@interface SettingTableViewController ()<UIAlertViewDelegate>

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backOnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signoutOnClick:(id)sender {
    UIAlertView *alert = [CustamViewController createAlertViewTitleStr:@"确认退出？" withMsg:nil widthDelegate:self withCancelBtn:@"取消" withbtns:@"确定"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [BPush delTag:[UserObj shareInstance].uid withCompleteHandler:^(id result, NSError *error) {
            
        }];
        NSLog(@"退出");
        NSUserDefaults *isLogin = [NSUserDefaults standardUserDefaults];
        
    
        [isLogin removeObjectForKey:@"userid"];
        
        [isLogin synchronize];
        
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
////#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    switch (section) {
//        case 0:
//            return 2;
//            break;
//        case 1:
//            return 4;
//            break;
//        case 2:
//            return 1;
//            break;
//        default:
//            return 0;
//            break;
//    }
////    return 0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: //常用地址车位
                
                break;
            case 1: //常用车辆
                
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: //给洗车APP好评
//                https://itunes.apple.com/cn/app/dian-zhuang/id1033019320?mt=8
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/dian-zhuang/id1033019320?mt=8"]];
                break;
            case 1: //帮助与反馈
                
                break;
            case 2: //法律条款
            {
                WebViewController *viewController = [[WebViewController alloc] init];
                viewController.title = @"法律条款";
                viewController.urlString = @"http://xbbwx.marnow.com/Weixin/Diy/aboutLow";
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
            case 3: //关于洗车APP
            {
                WebViewController *viewController = [[WebViewController alloc] init];
                viewController.title = @"关于洗车APP";
                viewController.urlString = @"http://mp.weixin.qq.com/s?__biz=MzAxMTY4ODEyOQ==&mid=207988342&idx=1&sn=a011a2b05c04d12fadc4eae58d404353&scene=18#rd";
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
            default:
                break;
        }
    }}

@end
