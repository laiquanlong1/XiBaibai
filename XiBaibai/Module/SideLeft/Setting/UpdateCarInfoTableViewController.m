//
//  UpdateCarInfoTableViewController.m
//  XBB
//
//  Created by mazi on 15/9/13.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "UpdateCarInfoTableViewController.h"
#import "UserObj.h"
#import "CarListTableViewController.h"
#import "CarBrandModel.h"
#import "CarTypeTableViewController.h"
#import "CarInfo.h"
@interface UpdateCarInfoTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *carNOLabel;
@property (weak, nonatomic) IBOutlet UITextField *carBrandLabel;
@property (weak, nonatomic) IBOutlet UITextField *colorLabel;
@property (weak, nonatomic) IBOutlet UITextField *typeLabel;


@property (nonatomic, copy) NSString *c_type;
@end

@implementation UpdateCarInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.carBrandLabel.delegate = self;
    self.carNOLabel.delegate = self;
    self.typeLabel.delegate = self;
    
    [self configDataOnUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configDataOnUI {
    self.carNOLabel.text = self.carModel.c_plate_num;
    self.carBrandLabel.text = self.carModel.c_brand;
    self.colorLabel.text = self.carModel.c_color;
    self.typeLabel.text = [CarInfo carType:self.carModel.c_type];
   
}

- (IBAction)updateOnTouch:(id)sender {
    DLog(@"%@",self.c_type);
    if (![self.carNOLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [SVProgressHUD showErrorWithStatus:@"请输入车牌号"];
    } else if (![self.carBrandLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [SVProgressHUD showErrorWithStatus:@"请输入爱车品牌"];
    } else if (![self.colorLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [SVProgressHUD showErrorWithStatus:@"请输入爱车颜色"];
    }  else if (![self.typeLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [SVProgressHUD showErrorWithStatus:@"请输入爱车类型"];
    }  else {
        [NetworkHelper postWithAPI:API_CarUpdate parameter:@{@"id": @(self.carModel.carId), @"uid": [UserObj shareInstance].uid, @"c_plate_num": self.carNOLabel.text, @"c_brand": self.carBrandLabel.text, @"c_color": self.colorLabel.text,@"c_type":self.c_type?self.c_type:@""} successBlock:^(id response) {
            if ([response[@"code"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCarListUpdate object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.navigationController.visibleViewController == self)
                        [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }];
    }
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
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

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.carBrandLabel]) {
        [self.carNOLabel resignFirstResponder];
        [self.colorLabel resignFirstResponder];
        CarListTableViewController *viewcontroller = [[CarListTableViewController alloc] init];
        WS(weakSelf)
        viewcontroller.brandSelectedCallback = ^(CarBrandModel *model) {
            weakSelf.carBrandLabel.text = model.make_name;
        };
        [self.navigationController pushViewController:viewcontroller animated:YES];
        return NO;
    }else if ([textField isEqual:self.typeLabel]) {
        [self.carNOLabel resignFirstResponder];
        [self.colorLabel resignFirstResponder];
        CarTypeTableViewController *viewController = [[CarTypeTableViewController alloc] init];
        WS(weakself)
        viewController.carType = ^(NSDictionary *dic) {
            weakself.typeLabel.text = dic[@"name"];
            weakself.c_type = dic[@"type"];
        
        };
        [self.navigationController pushViewController:viewController animated:YES];
        
        return NO;
        
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.carNOLabel]) {
        NSString *fullString = [textField.text stringByAppendingString:string];
        if ([fullString length]>7) {
            return NO;
        }
    }
    return YES;
}


@end
