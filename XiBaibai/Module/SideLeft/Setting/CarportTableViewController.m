//
//  CarportTableViewController.m
//  XBB
//
//  Created by Apple on 15/9/3.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "CarportTableViewController.h"
#import "SetCarAddsViewController.h"
#import "SetCarAddsInfoViewController.h"
#import "UserObj.h"

@interface CarportTableViewController ()<SetCarAddsViewControllerDelegate,SetCarAddsInfoViewControllerDelegate>

@end

@implementation CarportTableViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UserObj shareInstance] homeAddress] == nil) {
        [self fetchAddressFromWeb:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backOnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchAddressFromWeb:(void (^)())callback {
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:API_AddressSelect parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            NSArray *result = response[@"result"][@"list"];
            for (NSDictionary *temp in result) {
                if ([temp[@"address_type"] integerValue] == 0) {
                    //家
            
                    [UserObj shareInstance].homeAddress = temp[@"address"];
                    [UserObj shareInstance].homeDetailAddress = temp[@"address_info"];
                    [UserObj shareInstance].homeCoordinate = CLLocationCoordinate2DMake([temp[@"address_lt"] doubleValue], [temp[@"address_lg"] doubleValue]);
                } else if ([temp[@"address_type"] integerValue] == 1) {
                    //公司
                    [UserObj shareInstance].companyAddress = temp[@"address"];
                    [UserObj shareInstance].companyDetailAddress = temp[@"address_info"];
                    [UserObj shareInstance].companyCoordinate = CLLocationCoordinate2DMake([temp[@"address_lt"] doubleValue], [temp[@"address_lg"] doubleValue]);
                }
            }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SetCarAddsViewController *setcaraddVC = [[SetCarAddsViewController alloc] init];
    SetCarAddsInfoViewController *setcaraddsInfoVC = [[SetCarAddsInfoViewController alloc] init];
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                setcaraddVC.delegate = self;
                setcaraddVC.num = 0;
                [self.navigationController pushViewController:setcaraddVC animated:YES];
                break;
            case 1:
                setcaraddsInfoVC.delegate = self;
                setcaraddsInfoVC.num =0;
                [self.navigationController pushViewController:setcaraddsInfoVC animated:YES];
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                setcaraddVC.delegate = self;
                setcaraddVC.num = 1;
                [self.navigationController pushViewController:setcaraddVC animated:YES];
                break;
            case 1:
                setcaraddsInfoVC.delegate = self;
                setcaraddsInfoVC.num = 1;
                [self.navigationController pushViewController:setcaraddsInfoVC animated:YES];
                break;
            default:
                break;
        }

    }
    
    
    
    
    
    
    
    
    
    
}

- (void)setNowLocation:(NSString *)strLocation withNum:(NSInteger)num{
//    if (num == 0) {
//        self.labHomeCommon.text = strLocation;
//    }else if(num==1){
//        self.labComp.text = strLocation;
//    }
}
- (void)setAddsInfo:(NSString *)AddsInfo withNum:(NSInteger)num{
//    if (num == 0) {
//        self.labHomeInfo.text = AddsInfo;
//    }else if (num == 1){
//        self.labCompInfo.text = AddsInfo;
//    }
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
