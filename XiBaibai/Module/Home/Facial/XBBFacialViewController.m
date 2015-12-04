//
//  XBBFacialViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/12/4.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBFacialViewController.h"
#import "XBBListHeadLabel.h"
#import "XBBDiyObject.h"
#import "XBBDIYTableViewCell.h"
#import "AddOrderDetailTableViewCell.h"

@interface XBBFacialViewController ()
{
    XBBListHeadLabel *priceTotalTitle;
    float allPrice;
    NSHashTable *selectHashTable;
 
}

@property (nonatomic, copy) NSMutableArray *dataSource;

@end

@implementation XBBFacialViewController

#pragma mark datas

- (void)initViewDidLoadDatas
{
   [NetworkHelper postWithAPI:XBB_Facial_Pro parameter:nil successBlock:^(id response) {
       DLog(@"%@",response)
       NSDictionary *responseDic = response;
       if ([responseDic[@"code"] integerValue] == 1) {
           NSArray *resultArray = responseDic[@"result"];
           
           NSMutableArray *proArray = [NSMutableArray array];
           for (NSDictionary *resultDic  in resultArray) {
               XBBDiyObject *facialObject = [[XBBDiyObject alloc] init];
               facialObject.proName = resultDic[@"p_name"];
               facialObject.price1 = [resultDic[@"p_price"] floatValue];
               facialObject.price2 = [resultDic[@"p_price2"] floatValue];
               [proArray addObject:facialObject];
           }
           
           
           NSMutableArray *temp = [NSMutableArray array];
           NSMutableArray *onon = [NSMutableArray array];
           
           for (XBBDiyObject *object in proArray) {
               if (object.price1 == object.price2) {
                   [onon addObject:object];
               }else
               {
                   XBBDiyObject *o_1 = [[XBBDiyObject alloc] init];
                   o_1.proName = @"轿车";
                   o_1.price1 = object.price1;
                   
                   
                   XBBDiyObject *o_2 = [[XBBDiyObject alloc] init];
                   o_2.proName = @"SUV/MPV";
                   o_2.price1 = object.price2;
                   [temp addObject:@[object,o_1,o_2]];
               }
           }
           [temp addObject:onon];
           self.dataSource = [temp mutableCopy];
           DLog(@"%@",self.dataSource);
           [self.tableView reloadData];
      
       }
   } failBlock:^(NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"获取美容数据网络错误"];
   }];
}


#pragma mark viewdisposed


- (void)initUI
{
    [self setNavigationBarControl];
    [self addTabBar];
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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"美容"];
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

- (void)addTabBar
{
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, XBB_Screen_height-44., XBB_Screen_width, 44.)];
    [self.view addSubview:barView];
    barView.backgroundColor = XBB_Bg_Color;
    barView.layer.borderWidth = 0.5;
    barView.layer.borderColor = XBB_NavBar_Color.CGColor;
    
    priceTotalTitle = [[XBBListHeadLabel alloc] initWithFrame:CGRectMake(0, 0, (XBB_Screen_width/3)*2 , barView.bounds.size.height)];
    [priceTotalTitle setTextColor:XBB_NavBar_Color];
    [priceTotalTitle setFont:[UIFont boldSystemFontOfSize:16.]];
    [barView addSubview:priceTotalTitle];
    [priceTotalTitle setTextAlignment:NSTextAlignmentCenter];
    [self addAllPrice];
    priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",allPrice>0?allPrice:0.00];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width- XBB_Screen_width/3, 0, XBB_Screen_width/3, barView.bounds.size.height)];
    [button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = XBB_NavBar_Color;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:XBB_Bg_Color forState:UIControlStateNormal];
    [barView addSubview:button];
    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, XBB_Screen_width, XBB_Screen_height-64.-barView.frame.size.height);
    
}
- (void)addAllPrice
{
    
    priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",allPrice>0?allPrice:0.00];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBDIYTableViewCell" bundle:nil] forCellReuseIdentifier:@"diycell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"txt1"];
    [self initUI];
    
    // Do any additional setup after loading the view.
}


#pragma mark actions

- (IBAction)submit:(id)sender
{
    DLog(@"")
}
- (IBAction)backViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section]count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBBDiyObject *object = self.dataSource[indexPath.section][indexPath.row];
 
    if (object.price1 != object.price2 && object.price2 != 0) {
        XBBDIYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diycell"];
        
        if (cell == nil) {
            cell = [[XBBDIYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"diycell"];
        }
         cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
        cell.tag = 1;
         cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = object.proName;
        cell.priceLabel.alpha = 0;
        cell.selectImageView.alpha = 0;
        return cell;
    }else if (object.price1 == object.price2) {
        XBBDIYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diycell"];
        if (cell == nil) {
            cell = [[XBBDIYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"diycell"];
        }
         cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
        cell.tag = 1;
        cell.priceLabel.alpha = 1.;
        cell.selectImageView.alpha = 1.;
        cell.nameLabel.text = object.proName;
        cell.priceLabel.text =[NSString stringWithFormat:@"¥ %.2f",object.price1];
         cell.selectionStyle =  UITableViewCellSelectionStyleGray;
        return cell;
    }else
    {
        AddOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"txt1"];
        if (cell == nil) {
            cell = [[AddOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"txt1"];
        }
         cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
        cell.tag = 1;
        cell.titleLabel.text = object.proName;
        cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",object.price1];
        cell.selectionStyle =  UITableViewCellSelectionStyleGray;
        if (self.selectCarType == 1) {
            if (indexPath.row == 2) {
                cell.selectionStyle =  UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            }
        }else
        {
            if (indexPath.row == 1) {
                cell.selectionStyle =  UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            }
        }
        return cell;

    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (selectHashTable == nil) {
        selectHashTable = [NSHashTable weakObjectsHashTable];
    }
    
    
    
    XBBDiyObject *object = self.dataSource[indexPath.section][indexPath.row];
    
   
    
    
    if ([self.dataSource[indexPath.section] count]==3) {
        AddOrderDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (self.selectCarType == 1) {
            if (indexPath.row == 1) {
                if (cell.tag == 1) {
                    cell.tag = 2;
                    [selectHashTable addObject:self.dataSource[indexPath.section][0]];
                    XBBDiyObject *object = self.dataSource[indexPath.section][0];
                    allPrice += object.price1;
                    [self addAllPrice];
                    cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                }else
                {
                    cell.tag = 1;
                    [selectHashTable removeObject:self.dataSource[indexPath.section][0]];
                    XBBDiyObject *object = self.dataSource[indexPath.section][0];
                    allPrice -= object.price1;
                    cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
                    [self addAllPrice];
                }
                
            }
        }else
        {
            if (indexPath.row == 2) {
                if (cell.tag == 1) {
                    cell.tag = 2;
                    [selectHashTable addObject:self.dataSource[indexPath.section][0]];
                    XBBDiyObject *object = self.dataSource[indexPath.section][0];
                    allPrice += object.price2;
                    [self addAllPrice];
                    cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                }else
                {
                    cell.tag = 1;
                    [selectHashTable removeObject:self.dataSource[indexPath.section][0]];
                    XBBDiyObject *object = self.dataSource[indexPath.section][0];
                    cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
                    allPrice -= object.price2;
                    [self addAllPrice];
                }
                
            }
        }
        
    }else
    {
        XBBDIYTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.tag == 1) {
            cell.tag = 2;
            cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
            allPrice += object.price1;
            [selectHashTable addObject:object];
            
        }
        else
        {
            cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
            allPrice -= object.price1;
            cell.tag = 1;
            [selectHashTable removeObject:object];
        }
        [self addAllPrice];
    }
    
    
    DLog(@"%@",selectHashTable);
    
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
