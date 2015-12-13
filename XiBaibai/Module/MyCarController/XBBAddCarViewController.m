//
//  XBBAddCarViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/12/12.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBAddCarViewController.h"
#import "XBBAddCarTableViewCell.h"
#import "AddCarNumTableViewCell.h"
#import "CarListTableViewController.h"
#import "CarBrandModel.h"
#import "CarTypeTableViewController.h"
#import "UserObj.h"
@interface XBBAddCarViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView  *barView;
    CarBrandModel *selectCarbrand;
    NSDictionary  *selectCarType;
    NSString      *selectNumber;
    NSString      *selectColor;
}
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end


static NSString *identifierNum = @"cellnum";
static NSString *identifier = @"cell";

@implementation XBBAddCarViewController


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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"常用车辆"];
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



- (void)sureOnClick:(id)sender
{
    DLog(@"")
    
    if (selectNumber == nil || [selectNumber length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入车牌号"];
    } else if (selectCarbrand == nil) {
        [SVProgressHUD showErrorWithStatus:@"请输入品牌"];
    }else if (selectCarType == nil) {
        [SVProgressHUD showErrorWithStatus:@"请输入车型"];
    } else if (selectColor == nil || [selectColor length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入颜色"];
    } else {
        
        if (self.carModel) {
            [self updateOnTouch:nil];
        }else
        {
            [self addCarToWeb:nil];
        }
    }
    
}

- (IBAction)updateOnTouch:(id)sender {
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:API_CarUpdate parameter:@{@"id": @(self.carModel.carId), @"uid": [UserObj shareInstance].uid, @"c_plate_num": selectNumber, @"c_brand": selectCarbrand.make_name, @"c_color": selectColor,@"c_type":selectCarType?selectCarType[@"type"]:@""} successBlock:^(id response) {
        [SVProgressHUD dismiss];
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




- (void)addCarToWeb:(void (^)())callback {
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:Car_Insert_API parameter:@{@"uid": [UserObj shareInstance].uid, @"c_img": @"", @"c_plate_num": selectNumber, @"c_type": selectCarType?selectCarType[@"type"]:@"", @"c_color": selectColor, @"add_time": @([[NSDate date] timeIntervalSince1970]), @"c_remark": @"", @"c_brand": selectCarbrand.make_name} successBlock:^(NSDictionary *response) {
        [SVProgressHUD dismiss];
        DLog(@"%@",response)
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






- (IBAction)backViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)initUI
{
    self.tableView.separatorColor = XBB_separatorColor;
    [self setNavigationBarControl];
}

- (void)setTap
{
    [self.tableView.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
   
    
}
- (IBAction)tapAction:(id)sender
{
    
    AddCarNumTableViewCell *cell_1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell_1.nameTextFile resignFirstResponder];
    AddCarNumTableViewCell *cell_2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [cell_2.nameTextFile resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 120.;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XBB_Screen_width, 120.)];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor clearColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30., backView.bounds.size.height - 44., XBB_Screen_width - 60., 44.)];
    button.layer.cornerRadius = 5;
    button.layer.borderColor = XBB_NavBar_Color.CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.masksToBounds = YES;
    
    if (self.carModel) {
        [button setTitle:@"修改" forState:UIControlStateNormal];
    }else
    {
        [button setTitle:@"提交" forState:UIControlStateNormal];
    }
    
    [button addTarget:self action:@selector(sureOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
    [backView addSubview:button];
    [button setBackgroundColor:XBB_Bg_Color];
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (IBAction)one:(id)sender
{
    DLog(@"")
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            AddCarNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierNum forIndexPath:indexPath];
            cell.nameTextFile.delegate = self;
            cell.nameTextFile.tag = indexPath.row;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.carModel) {
                cell.nameTextFile.text = self.carModel.c_plate_num;
                selectNumber = self.carModel.c_plate_num;
            }
            return cell;
        }
            break;
        case 1:
        {
            XBBAddCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.nameLabel.placeholder = @"请选择爱车的品牌";
            cell.nameLabel.tag = indexPath.row;
            cell.nameLabel.delegate = self;
            if (self.carModel) {
                cell.nameLabel.text= self.carModel.c_brand;
                CarBrandModel *ca  = [[CarBrandModel alloc] init];
                ca.make_name = self.carModel.c_brand;
                selectCarbrand = ca;
                [cell.nameLabel setTextColor:[UIColor blackColor]];
                
            }
            return cell;
        }
            break;
        case 2:
        {
            XBBAddCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.nameLabel.placeholder = @"请选择爱车的车型";
            cell.nameLabel.tag = indexPath.row;
            cell.nameLabel.delegate = self;
            if (self.carModel) {
                selectCarType = @{@"name":self.carModel.typeString , @"type":[NSString stringWithFormat:@"%ld",self.carModel.c_type]};
                cell.nameLabel.text= self.carModel.typeString;
                [cell.nameLabel setTextColor:[UIColor blackColor]];
                
            }
            return cell;
        }
            break;
        case 3:
        {
            AddCarNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierNum forIndexPath:indexPath];
            cell.nameTextFile.delegate = self;
             cell.nameTextFile.tag = indexPath.row;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameTextFile.placeholder = @"请输入爱车的颜色";
            if (self.carModel) {
                selectColor = self.carModel.c_color;
                cell.nameTextFile.text = self.carModel.c_color;
                
            }
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 0 && indexPath.row != 3) {
        NSIndexPath *inde = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        AddCarNumTableViewCell *cell = [tableView cellForRowAtIndexPath:inde];
        NSIndexPath *inde2 = [NSIndexPath indexPathForRow:3 inSection:indexPath.section];
        AddCarNumTableViewCell *cell2 = [tableView cellForRowAtIndexPath:inde2];
        [cell.nameTextFile resignFirstResponder];
        [cell2.nameTextFile resignFirstResponder];
    }
    
    
    if (indexPath.row == 1 || indexPath.row == 2) {
        XBBAddCarTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 1) {
            
            CarListTableViewController *calist = [[UIStoryboard storyboardWithName:@"XBBOne" bundle:nil] instantiateViewControllerWithIdentifier:@"CarListTableViewController"];
            calist.brandSelectedCallback = ^(id param){
                DLog(@"%@",param);
                [cell.nameLabel setTextColor:[UIColor blackColor]];
                selectCarbrand = param;
                cell.nameLabel.text = selectCarbrand.make_name;
                
            };
            
            [self.navigationController pushViewController:calist animated:YES];
            
        }
        
        if (indexPath.row == 2) {
            CarTypeTableViewController *carType = [[CarTypeTableViewController alloc] init];
            carType.carType = ^(NSDictionary *type){
                DLog(@"%@",type)
                selectCarType = type;
                [cell.nameLabel setTextColor:[UIColor blackColor]];
                cell.nameLabel.text = selectCarType[@"name"];
            };
            carType.navigationTitle = @"选择车辆类型";
            [self.navigationController pushViewController:carType animated:YES];
            
        }
        return;
    }
}


#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 1 || textField.tag == 2) {
        AddCarNumTableViewCell *cell_3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        AddCarNumTableViewCell *cell_1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        [cell_1.nameTextFile resignFirstResponder];
        [cell_3.nameTextFile resignFirstResponder];
        
        if (textField.tag == 1) {
           
            XBBAddCarTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            CarListTableViewController *calist = [[UIStoryboard storyboardWithName:@"XBBOne" bundle:nil] instantiateViewControllerWithIdentifier:@"CarListTableViewController"];
            calist.brandSelectedCallback = ^(id param){
                DLog(@"%@",param);
                [cell.nameLabel setTextColor:[UIColor blackColor]];
                selectCarbrand = param;
                cell.nameLabel.text = selectCarbrand.make_name;
                
            };
            
            [self.navigationController pushViewController:calist animated:YES];
            return NO;
        }
        
        if (textField.tag == 2) {
            XBBAddCarTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            CarTypeTableViewController *carType = [[CarTypeTableViewController alloc] init];
            carType.carType = ^(NSDictionary *type){
                DLog(@"%@",type)
                selectCarType = type;
                [cell.nameLabel setTextColor:[UIColor blackColor]];
                cell.nameLabel.text = selectCarType[@"name"];
            };
            carType.navigationTitle = @"选择车辆类型";
            [self.navigationController pushViewController:carType animated:YES];
            return NO;
            
        }
        
        
    }
    
    
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    AddCarNumTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    AddCarNumTableViewCell *cell_1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *string_1 = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([string_1 length] > 8) {
        return NO;
    }
    if ([textField isEqual:cell.nameTextFile]) {
        selectNumber = string_1;
    }else if ([textField isEqual:cell_1.nameTextFile])
    {
        selectColor = string_1;
    }
    
    return YES;
}


@end
