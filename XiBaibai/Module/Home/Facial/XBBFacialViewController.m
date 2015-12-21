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
#import "XBBOrder.h"
#import "WebViewController.h"
#import "AddOrderViewController.h"
#import "UserObj.h"


@class AddOrderViewController;
@interface XBBFacialViewController ()
{
    UIView *barView;
    XBBListHeadLabel *priceTotalTitle;
    float allPrice;
    NSHashTable *selectHashTable;
    NSInteger carType; // 1 轿车
 
}

@property (nonatomic, copy) NSArray *proArray;
@property (nonatomic, copy) NSMutableArray *dataSource;

@end

@implementation XBBFacialViewController

#pragma mark datas

- (void)haveSelectObjectDatas
{
    if (selectHashTable == nil) {
        selectHashTable = [NSHashTable weakObjectsHashTable];
    }
    for (XBBOrder *order in self.selectFacialArray) {
        for (NSArray *arr in self.dataSource) {
            for (XBBDiyObject *object in arr) {
                if ([object.proName isEqualToString:order.title]) {
                    [selectHashTable addObject:object];
                }
            }
        }
    }
}

- (void)sortArray
{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.proArray.count; i ++) {
        NSMutableArray *arr_1 = [NSMutableArray array];
        XBBDiyObject *diy = self.proArray[i];
        
        [arr_1 addObject:diy];
        if (diy.proArray.count > 0) {
            for (XBBDiyObject *ob in diy.proArray) {
                [arr_1 addObject:ob];
            }
        }
        [arr addObject:arr_1];
    }
    self.dataSource = arr;
  
}


- (void)initViewDidLoadDatas
{

   [NetworkHelper postWithAPI:API_SelectWax parameter:nil successBlock:^(id response) {
       DLog(@"%@",response)
       NSDictionary *responseDic = response;
       if ([responseDic[@"code"] integerValue] == 1) {
           NSDictionary *resultDic_1 = responseDic[@"result"];
           NSArray  *wax = resultDic_1[@"wax"][@"result"];
           NSArray  *noWashArr = resultDic_1[@"notwash"][@"result"];
           DLog(@"")
           XBBDiyObject *diy_1 = [[XBBDiyObject alloc] init];
           diy_1.proName = @"打蜡(附赠外观清洗)";
           diy_1.isWaxTag = 1;
           XBBDiyObject *diy_2 = [[XBBDiyObject alloc] init];
           diy_2.proName = @"推荐美容";
           NSMutableArray *waxArr = [NSMutableArray array];
           for (NSDictionary *resultDic  in wax) {
               XBBDiyObject *facialObject = [[XBBDiyObject alloc] init];
               facialObject.proName = resultDic[@"p_name"];
               facialObject.pid = resultDic[@"id"];
               facialObject.price1 = [resultDic[@"p_price"] floatValue];
               facialObject.price2 = [resultDic[@"p_price2"] floatValue];
               facialObject.urlString = resultDic[@"detailurl"];
               facialObject.p_wash_free = [resultDic[@"p_wash_free"] integerValue];
               [waxArr addObject:facialObject];
           }
           
           
           NSMutableArray *noArr = [NSMutableArray array];
           for (NSDictionary *resultDic  in noWashArr) {
               XBBDiyObject *facialObject = [[XBBDiyObject alloc] init];
               facialObject.proName = resultDic[@"p_name"];
               facialObject.pid = resultDic[@"id"];
               facialObject.price1 = [resultDic[@"p_price"] floatValue];
               facialObject.price2 = [resultDic[@"p_price2"] floatValue];
               facialObject.urlString = resultDic[@"detailurl"];
               facialObject.p_wash_free = [resultDic[@"p_wash_free"] integerValue];
               [noArr addObject:facialObject];
           }

           diy_1.proArray = waxArr;
           diy_2.proArray = noArr;
           
  
           NSMutableArray *arrr = [NSMutableArray array];
           [arrr addObject:diy_1];
           [arrr addObject:diy_2];
           self.proArray = arrr;
           [self sortArray];
           [self alphaToOne];
           [self haveSelectObjectDatas];
           [self.tableView reloadData];
           
       }
   } failBlock:^(NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"获取美容数据网络错误"];
   }];
}
- (void)addAllPrice
{
    allPrice = 0.;
    for (XBBDiyObject *object in selectHashTable) {
        if (carType == 1) {
            allPrice += object.price1;
        }else
        {
            allPrice += object.price2;
        }
    }
    
    priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",allPrice>0?allPrice:0.00];
}

- (void)initData
{
    carType = [[UserObj shareInstance] carModel].c_type;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}


#pragma mark viewdisposed

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
    barView = [[UIView alloc] initWithFrame:CGRectMake(0, XBB_Screen_height-44., XBB_Screen_width, 44.)];
    [self.view addSubview:barView];
    barView.backgroundColor = XBB_Bg_Color;
    barView.layer.borderWidth = 0.5;
    barView.layer.borderColor = XBB_NavBar_Color.CGColor;
    
    priceTotalTitle = [[XBBListHeadLabel alloc] initWithFrame:CGRectMake(0, 0, (XBB_Screen_width/2) , barView.bounds.size.height)];
    [priceTotalTitle setTextColor:XBB_NavBar_Color];
    [priceTotalTitle setFont:[UIFont boldSystemFontOfSize:16.]];
    [barView addSubview:priceTotalTitle];
    [priceTotalTitle setTextAlignment:NSTextAlignmentCenter];
    [self addAllPrice];
    priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",allPrice>0?allPrice:0.00];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width- XBB_Screen_width/2, 0, XBB_Screen_width/2, barView.bounds.size.height)];
    [button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = XBB_NavBar_Color;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:XBB_Bg_Color forState:UIControlStateNormal];
    [barView addSubview:button];
    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, XBB_Screen_width, XBB_Screen_height-64.-barView.frame.size.height);
    self.tableView.backgroundColor = XBB_Bg_Color;
    [self alphatoZero];
}

- (void)registerCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBDIYTableViewCell" bundle:nil] forCellReuseIdentifier:@"diycell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"txt1"];
}

- (void)alphatoZero
{
    barView.alpha = 0;
    self.tableView.alpha = 0.;
}
- (void)alphaToOne
{
    [UIView animateWithDuration:0.25 animations:^{
        barView.alpha = 1;
        self.tableView.alpha = 1.;
    }];
    
}

- (void)initUI
{
    [self registerCell];
     self.tableView.separatorColor = XBB_separatorColor;;
    [self setNavigationBarControl];
    [self addTabBar];
}

#pragma mark actions

- (IBAction)toTapAction:(id)sender
{
    UITapGestureRecognizer *tap = sender;
    UILabel *label = (UILabel *)tap.view;
    
    for (NSArray *arr in self.dataSource) {
        for (XBBDiyObject *ob in arr) {
            if (label.tag == [ob.pid integerValue]) {
                WebViewController *web = [[WebViewController alloc] init];
                web.navigationTitle = ob.proName;
                web.urlString = ob.urlString;
                [self presentViewController:web animated:YES completion:nil];
                return;
            }
        }
    }
    
    DLog(@"%ld",label.tag)
}
- (IBAction)submit:(id)sender
{
 
    NSArray *viewControllers = self.navigationController.viewControllers;
    DLog(@"%@",viewControllers)
    BOOL isWeb = NO;
    for (id viewControll in viewControllers) {
        if ([viewControll isKindOfClass:[WebViewController class]]) {
            isWeb = YES;
        }
    }
    if (isWeb) {
        
        
        NSMutableArray *arr = [NSMutableArray array];
        for (XBBDiyObject *object in selectHashTable) {
            object.type = 2;
            [arr addObject:object];
        }
        AddOrderViewController *ader = [[AddOrderViewController alloc] init];
        ader.selectArray = arr;
        [self.navigationController pushViewController:ader animated:YES];
        return;
    }
    
    self.facialBlock(selectHashTable);
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = XBB_Bg_Color;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}


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
   
    return [self.dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    XBBDiyObject *object = self.dataSource[indexPath.section][indexPath.row];
    if (object.price1==0) {
        XBBDIYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diycell"];
        
        if (cell == nil) {
            cell = [[XBBDIYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"diycell"];
        }
        cell.tag = 1;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = object.proName;
        cell.priceLabel.alpha = 0;
        cell.selectImageView.alpha = 0;
        return cell;

    }else
    {
        AddOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"txt1"];
        if (cell == nil) {
            cell = [[AddOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"txt1"];
        }
        cell.titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toTapAction:)];
        cell.titleLabel.tag = [object.pid integerValue];
        [cell.titleLabel addGestureRecognizer:tap];
        cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
        cell.priceLabel.textColor = XBB_NotSelectColor;
        cell.tag = 1;
        cell.titleLabel.text = object.proName;
        if (carType == 1) {
            cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",object.price1];
        }else
        {
            cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",object.price2];
        }
        if (selectHashTable) {
            for (XBBDiyObject *ob in selectHashTable) {
                if ([object.proName isEqualToString:ob.proName]) {
                    cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                      cell.priceLabel.textColor = XBB_SelectedColor;
                    cell.tag = 2;
                    [self addAllPrice];
                    
                }
            }
        }
        
        cell.selectionStyle =  UITableViewCellSelectionStyleGray;
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
    
//    BOOL is_free = NO;
//    for (XBBDiyObject *object_1 in selectHashTable) {
//        if (object_1.p_wash_free == 1) {
//            is_free = YES;
//        }
//    }
//    if (self.washType == 0 && is_free == NO && object.p_wash_free==0) {
//        BOOL isOk = NO;
//        for (XBBDiyObject *o_1 in selectHashTable) {
//            if ([o_1 isEqual:object]) {
//                isOk = YES;
//            }
//        }
//        if (isOk) {
//            
//        }else
//        {
//            [SVProgressHUD showErrorWithStatus:@"此项目必须选择洗车"];
//            return;
//        }
//    }
    if (indexPath.row == 0) {
        
    }else
    {
        
        AddOrderDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([self.dataSource[indexPath.section][0] isWaxTag] == 1) {
            for (int i = 1; i < [self.dataSource[indexPath.section] count]; i++) {
                
                XBBDiyObject *object_1 = self.dataSource[indexPath.section][i];
                
                NSIndexPath *inde = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                AddOrderDetailTableViewCell *cell_1 = [tableView cellForRowAtIndexPath:inde];
                if ([cell isEqual:cell_1]) {
                    if (cell.tag == 1) {
                        cell.tag = 2;
                        cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                        cell.priceLabel.textColor = XBB_SelectedColor;
                        [selectHashTable addObject:object];
                        
                    }else
                    {
                        cell.tag = 1;
                        cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
                        cell.priceLabel.textColor = XBB_NotSelectColor;
                        [selectHashTable removeObject:object];
                        
                    }

                }else
                {
                    if (cell_1.tag == 2) {
                        cell_1.tag = 1;
                        cell_1.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
                        cell_1.priceLabel.textColor = XBB_NotSelectColor;
                        [selectHashTable removeObject:object_1];
                        
                    }
                }
            }
           
        }else
        {
            if (cell.tag == 1) {
                cell.tag = 2;
                cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                cell.priceLabel.textColor = XBB_SelectedColor;
                [selectHashTable addObject:object];
                
            }else
            {
                cell.tag = 1;
                cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
                cell.priceLabel.textColor = XBB_NotSelectColor;
                [selectHashTable removeObject:object];
                
            }
            
        }
    }
    
    [self addAllPrice];
}


@end
