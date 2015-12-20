//
//  XBBDIYViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/12/4.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBDIYViewController.h"
#import "XBBListHeadLabel.h"
#import "XBBListContentLabel.h"
#import "XBBDiyObject.h"
#import "XBBDIYTableViewCell.h"
#import "AddOrderDetailTableViewCell.h"
#import "XBBOrder.h"
#import "WebViewController.h"
#import "AddOrderViewController.h"
#import "UserObj.h"

@interface XBBDIYViewController ()
{
    UIView *barView;
    float allPrice;
    XBBListHeadLabel *priceTotalTitle;
    NSInteger carType;
    NSHashTable *selectObjects;
}
@property (nonatomic, copy) NSMutableArray *dataSource; // allDatas

@end

@implementation XBBDIYViewController


#pragma mark datas

- (void)initViewDidLoadDatas
{
    carType = [UserObj shareInstance].carModel.c_type;
    [NetworkHelper postWithAPI:XBB_DIY_Pro parameter:nil successBlock:^(id response) {
        DLog(@"%@",response);
        NSDictionary *dic = response;
       
        if ([dic[@"code"] integerValue] == 1) {
            NSDictionary *resultDic = dic[@"result"];
            NSArray *proArray = resultDic[@"group"];
            NSMutableArray *gropTempArrayAll = [NSMutableArray array];
            if (proArray) {
                for (NSDictionary *grouDic in proArray) {
                    NSMutableArray *gropTempArray = [NSMutableArray array];
                    XBBDiyObject *object = [[XBBDiyObject alloc] init];
                    object.proName = grouDic[@"name"];
    
                    NSDictionary *dic_pro_1 = grouDic[@"half"];
                    XBBDiyObject *subO_1 = [[XBBDiyObject alloc] init];
                    subO_1.pid = dic_pro_1[@"id"];
                    subO_1.proName = dic_pro_1[@"p_name"];
                    subO_1.price1 = [dic_pro_1[@"p_price"] floatValue];
                    subO_1.price2 = [dic_pro_1[@"p_price2"] floatValue];
                    
                    NSDictionary *dic_pro_2 = grouDic[@"all"];
                    XBBDiyObject *subO_2 = [[XBBDiyObject alloc] init];
                    subO_2.pid = dic_pro_2[@"id"];
                    subO_2.proName = dic_pro_2[@"p_name"];
                    subO_2.price1 = [dic_pro_2[@"p_price"] floatValue];
                    subO_2.price2 = [dic_pro_2[@"p_price2"] floatValue];

                    NSMutableArray *subArray = [NSMutableArray array];
                    
                    [subArray addObject:subO_1];
                    [subArray addObject:subO_2];
                     object.proArray = [subArray copy];
    
                    [gropTempArray addObject:object];
                    [gropTempArray addObject:subO_1];
                    [gropTempArray addObject:subO_2];
                    [gropTempArrayAll addObject:gropTempArray];
                }
            }
            
            NSMutableArray *commonTempArray = [NSMutableArray array];
            NSArray *proDicArray = resultDic[@"common"];
            for (NSDictionary *proDic in proDicArray) {
                XBBDiyObject *object = [[XBBDiyObject alloc] init];
                object.proName = proDic[@"p_name"];
                object.pid = proDic[@"id"];
                object.price1 = [proDic[@"p_price"] floatValue];
                object.price2 = [proDic[@"p_price2"] floatValue];
                [commonTempArray addObject:object];
            }
            
            [gropTempArrayAll addObject:commonTempArray];
            self.dataSource = [gropTempArrayAll copy];
            for (XBBDiyObject *ob in self.dataSource) {
                DLog(@"%@",ob);
            }
            DLog(@"%@",self.dataSource);
        }
        [self inita];
        [self alphaToOne];
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"DIY查询网络错误"];
    }];
}

- (void)inita
{
    if (selectObjects == nil) {
        selectObjects = [NSHashTable weakObjectsHashTable];
    }
    for (XBBOrder *order in self.selectArray) {
        for (NSArray *array in self.dataSource) {
            for (XBBDiyObject *object in array) {
                if ([order.xbbid isEqualToString:object.pid]) {
                    [selectObjects addObject:object];
                }
            }
        }
        
    }
    [self addAllPrice];
}


- (void)addAllPrice
{
    allPrice = 0;
    for (XBBDiyObject *object in selectObjects) {
        if (carType == 1) {
            allPrice += object.price1;
        }else
        {
            allPrice += object.price2;
        }
    }
    priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",allPrice>0?allPrice:0.00];
}

#pragma mark viewdisposed

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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"DIY"];
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
    [self alphatoZero];
    
}


- (void)resigestCell
{
    self.tableView.separatorColor = XBB_separatorColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBDIYTableViewCell" bundle:nil] forCellReuseIdentifier:@"diycell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"txt1"];
}

- (void)initUI
{
    [self setNavigationBarControl];
    [self addTabBar];
    [self resigestCell];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
   
    // Do any additional setup after loading the view.
}


#pragma mark actions

- (IBAction)tapLabel:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UILabel *label = (UILabel *)tap.view;
    if (label.tag != 11111) {
        NSString *urlString = [NSString stringWithFormat:@"http://xbbwx.marnow.com/Weixin/Diy/index?p_id=%ld",label.tag];
        WebViewController *web = [[WebViewController alloc] init];
        web.navigationTitle = label.text;
        web.urlString = urlString;
        [self presentViewController:web animated:YES completion:nil];
    }
    

    DLog(@"")
}
- (IBAction)submit:(id)sender
{
 
    NSArray *viewControllers = self.navigationController.viewControllers;
    BOOL isWeb = NO;
    for (id viewControll in viewControllers) {
        if ([viewControll isKindOfClass:[WebViewController class]]) {
            isWeb = YES;
        }
    }
    if (isWeb) {
        isWeb = NO;
        NSMutableArray *arr = [NSMutableArray array];
        for (XBBDiyObject *object in selectObjects) {
            object.type = 1;
            [arr addObject:object];
        }
        AddOrderViewController *ader = [[AddOrderViewController alloc] init];
        ader.selectArray = arr;
        [self.navigationController pushViewController:ader animated:YES];
        return;
    }
    self.selectObjectsBlock(selectObjects);
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark tableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
   return  [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBBDiyObject *ob = self.dataSource[indexPath.section][indexPath.row];
    if (indexPath.section < [self.dataSource count] - 1 ) {
        if (indexPath.row == 0) {
            XBBDIYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diycell"];
            if (cell == nil) {
                cell = [[XBBDIYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"diycell"];
            }
            
            cell.tag = 1;
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            cell.priceLabel.alpha = 1;
            cell.selectImageView.alpha = 1;
            cell.nameLabel.text = ob.proName;
            cell.nameLabel.tag = 11111;
            cell.priceLabel.alpha = 0;
            cell.selectImageView.alpha = 0;
            cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
            cell.priceLabel.textColor = XBB_NotSelectColor;
            
            NSEnumerator *enumerator = [selectObjects objectEnumerator];
            id object_enumer;
            while (object_enumer = [enumerator nextObject]) {
                if ([ob isEqual:object_enumer]) {
                    cell.tag = 2;
                    cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                    cell.priceLabel.textColor = XBB_SelectedColor;
                    break;
                }
            }
            [self addAllPrice];
            
            return cell;
        }
        else
        {
            AddOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"txt1"];
            cell.tag = 1;
            if (cell == nil) {
                cell = [[AddOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"txt1"];
            }
            cell.titleLabel.frame = CGRectMake(20, 0, 120, cell.contentView.frame.size.height);
            if (carType == 1) {
                cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",ob.price1];
            }
            else
            {
                cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",ob.price2];
            }
            
            cell.titleLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
            [cell.titleLabel addGestureRecognizer:tap];
            
            
            cell.titleLabel.text = ob.proName;
            cell.titleLabel.tag = [ob.pid integerValue];
            cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
            cell.priceLabel.textColor = XBB_NotSelectColor;
            NSEnumerator *enumerator = [selectObjects objectEnumerator];
            id object_enumer;
            
            while (object_enumer = [enumerator nextObject]) {
                if ([ob isEqual:object_enumer]) {
                    cell.tag = 2;
                    cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                      cell.priceLabel.textColor = XBB_SelectedColor;
                    break;
                }
            }
            [self addAllPrice];
            return cell;
        }
     
    }else
    {
        XBBDIYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diycell"];
        cell.tag = 1;
        cell.selectionStyle =  UITableViewCellSelectionStyleGray;
        cell.priceLabel.alpha = 1;
        cell.selectImageView.alpha = 1;
        if (cell == nil) {
            cell = [[XBBDIYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"diycell"];
        }
        cell.nameLabel.tag = [ob.pid integerValue];
        cell.nameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
        [cell.nameLabel addGestureRecognizer:tap];
        cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
          cell.priceLabel.textColor = XBB_NotSelectColor;
        cell.nameLabel.text = ob.proName;
        if (carType == 1) {
            cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",ob.price1];
        }
        else
        {
            cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",ob.price2];
        }
        
        NSEnumerator *enumerator = [selectObjects objectEnumerator];
        id object_enumer;
        while (object_enumer = [enumerator nextObject]) {
            if ([ob isEqual:object_enumer]) {
                cell.tag = 2;
                cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                  cell.priceLabel.textColor = XBB_SelectedColor;
                break;
            }
        }
        [self addAllPrice];
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectObjects == nil) {
        selectObjects = [NSHashTable weakObjectsHashTable];
    }
    XBBDiyObject *object = self.dataSource[indexPath.section][indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section < [self.dataSource count]-1) {
        if (indexPath.row != 0) {
            for (int i = 0; i < [self.dataSource[indexPath.section] count]; i++) {
                NSIndexPath *index_1 = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                AddOrderDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:index_1];
                if ([index_1 isEqual:indexPath]) {
                    if (cell.tag == 1) {
                        
                        if (self.washType == 0 && self.hasWax == NO) {
                            
                            [SVProgressHUD showErrorWithStatus:@"此选项必须选择洗车"];
                            return;
                        }
                        
                        
                        cell.tag = 2;
                        cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                        cell.priceLabel.textColor = XBB_SelectedColor;
                        [selectObjects addObject:object];
                    }else
                    {
                        cell.tag = 1;
                        cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
                        cell.priceLabel.textColor = XBB_NotSelectColor;
                        [selectObjects removeObject:object];
                    }
                }else
                {
                   XBBDiyObject *object_1 = self.dataSource[indexPath.section][i];
                    cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
                      cell.priceLabel.textColor = XBB_NotSelectColor;
                    cell.tag = 1;
                    NSEnumerator *enumerator = [selectObjects objectEnumerator];
                    id object_enumer;
                    while (object_enumer = [enumerator nextObject]) {
                        if ([object_1 isEqual:object_enumer]) {
                            [selectObjects removeObject:object_1];
                            break;
                        }
                    }
                }
            }
        }
    }else
    {
        XBBDIYTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.tag == 1) {
            if (self.washType == 0 && self.hasWax == NO) {
                
                [SVProgressHUD showErrorWithStatus:@"此选项必须选择洗车"];
                return;
            }
            cell.tag = 2;
            [selectObjects addObject:object];
            cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
              cell.priceLabel.textColor = XBB_SelectedColor;
        }else
        {
            cell.tag = 1;
            [selectObjects removeObject:object];
            cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
              cell.priceLabel.textColor = XBB_NotSelectColor;
            
        }
       
    }
    
     [self addAllPrice];
}


@end
