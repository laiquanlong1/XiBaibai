//
//  AddCarTableViewController.m
//  XBB
//
//  Created by Apple on 15/9/4.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "AddCarTableViewController.h"
#import "UserObj.h"
#import "CarBrandModel.h"
#import "CarListTableViewController.h"
#import "CarTypeTableViewController.h"

@interface AddCarTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *carNOTextField;
@property (weak, nonatomic) IBOutlet UITextField *carBrandTextField;
@property (weak, nonatomic) IBOutlet UITextField *carColorTextField;
@property (weak, nonatomic) IBOutlet UITextField *carTypeTextFiled;


@property (nonatomic, copy) NSString *c_type;
@end

@implementation AddCarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.carBrandTextField.delegate = self;
    self.carNOTextField.delegate = self;
    self.carTypeTextFiled.delegate = self;
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI {
    self.carNOTextField.text = self.carModel.c_plate_num;
//    self.carBrandTextField.text =
    self.carColorTextField.text = self.carModel.c_color;
}

- (IBAction)okOnClick:(id)sender {
    if (![self.carNOTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [SVProgressHUD showErrorWithStatus:@"请输入车牌号"];
    } else if (![self.carBrandTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [SVProgressHUD showErrorWithStatus:@"请输入品牌"];
    } else if (![self.carColorTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [SVProgressHUD showErrorWithStatus:@"请输入颜色"];
    } else if (![self.carTypeTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [SVProgressHUD showErrorWithStatus:@"请输入车型"];
    }else {
        [self addCarToWeb:nil];
    }
}

- (void)addCarToWeb:(void (^)())callback {
    [NetworkHelper postWithAPI:Car_Insert_API parameter:@{@"uid": [UserObj shareInstance].uid, @"c_img": @"", @"c_plate_num": self.carNOTextField.text, @"c_type": self.c_type?self.c_type:@"", @"c_color": self.carColorTextField.text, @"add_time": @([[NSDate date] timeIntervalSince1970]), @"c_remark": @"", @"c_brand": self.carBrandTextField.text} successBlock:^(NSDictionary *response) {
        if ([[response objectForKey:@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SVDisplayDuration(4) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCarListUpdate object:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"添加失败"];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"添加失败"];
    }];
}

- (IBAction)backOnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark textFeil delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.carBrandTextField]) {
        [self.carNOTextField resignFirstResponder];
        [self.carColorTextField resignFirstResponder];
        CarListTableViewController *viewcontroller = [[CarListTableViewController alloc] init];
        WS(weakSelf)
        viewcontroller.brandSelectedCallback = ^(CarBrandModel *model) {
            weakSelf.carBrandTextField.text = model.make_name;
        };
        [self.navigationController pushViewController:viewcontroller animated:YES];
        return NO;
    }else if ([textField isEqual:self.carTypeTextFiled]) {
        [self.carNOTextField resignFirstResponder];
        [self.carColorTextField resignFirstResponder];
        
        CarTypeTableViewController *carType = [[CarTypeTableViewController alloc] init];
        WS(weakSelf)
        carType.carType = ^(NSDictionary  *carType_1){
            weakSelf.carTypeTextFiled.text = carType_1[@"name"];
            self.c_type = carType_1[@"type"];
        };
        [self.navigationController pushViewController:carType animated:YES];

        return NO;
    }
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.carNOTextField isEqual:textField]) {
        NSString *fullString = [textField.text stringByAppendingString:string];
        if ([fullString length]>7) {
            return NO;
        }
    }
    return YES;
}



//#pragma mark - Table view data source
//
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
