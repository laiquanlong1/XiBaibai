//
//  AddOrderViewController.m
//  XBB
//
//  Created by Daniel on 15/8/20.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "AddOrderViewController.h"
#import "CustamViewController.h"
#import "PayTableViewController.h"
#import "sys/stat.h"
#import "UserObj.h"
#import "CarInfo.h"
#import "CheckOnderViewController.h"
#import "XBBListHeadLabel.h"
#import "XBBListContentLabel.h"
#import "DIYSelectTableViewController.h"
#import "AddPlanOrderViewController.h"
#import "PayTableViewController.h"
#import "MyCouponsViewController.h"
#import "MyCarTableViewController.h"
#import "FacialSelectTableViewController.h"

#import "AddOrderDetailTableViewCell.h"
#import "AddOrderTableViewCell.h"
#import "XBBOrder.h"

#import "XBBFacialViewController.h"
#import "XBBDIYViewController.h"
#import "XBBDiyObject.h"


#define START_TIME @"reserve_start_time"
#define END_TIME @"reserve_end_time"

static NSString *identifier = @"titcell";
static NSString *identifier_2 = @"tit1cell";

@interface AddOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *barView;
    XBBListHeadLabel *priceTotalTitle;
    float selectWashPrice;
    float selectDIYPrice;
    float selectFaicalPrice;
    float selectCouponPrice;
    float selectAllPrice;
    
    NSInteger washType;
    NSInteger carType;
    BOOL isJust;
    BOOL haveSelectWash;
    NSString *planTime;
}
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSArray *selectDIYArray;

@property (nonatomic, copy) NSArray *selectFacialArray;

@property (nonatomic, strong) XBBOrder *selectWashOrderObject;


@end



@implementation AddOrderViewController

#pragma mark dataDispose

- (void)initViewDidLoadDatas
{
    [NetworkHelper postWithAPI:XBB_Wash2Coupons parameter:@{@"uid":[UserObj shareInstance].uid} successBlock:^(id response) {
        NSDictionary *resposeDic = response;
        if ([resposeDic[@"code"] integerValue] == 1) {
            NSDictionary *dic_ro = resposeDic[@"result"];
            NSDictionary *washDic = dic_ro[@"wash"];
            NSDictionary *outDic = washDic[@"out"];
            XBBOrder *order_1 = [[XBBOrder alloc] init];
            order_1.title = outDic[@"p_name"];
            if (carType == 1) {
                order_1.price = [outDic[@"p_price"] floatValue];
            }else
            {
                order_1.price = [outDic[@"p_price2"] floatValue];
            }
            order_1.xbbid = outDic[@"id"];

            NSDictionary *outinDic  = washDic[@"outin"];
            
            XBBOrder *order_2 = [[XBBOrder alloc] init];
            order_2.title = outinDic[@"p_name"];
            if (carType == 1) {
                order_2.price = [outinDic[@"p_price"] floatValue];
            }else
            {
                order_2.price = [outinDic[@"p_price2"] floatValue];
            }
            order_2.xbbid = outinDic[@"id"];
            
            XBBOrder *order = self.dataArray[0];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:order_1];
            [arr addObject:order_2];
            order.xbbOrders = arr;
            [self initUpdateData];
            [self alphaToOne];
        }else
        {
            [SVProgressHUD showErrorWithStatus:resposeDic[@"msg"]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取洗车方式和优惠券网络错误"];
    }];
}

- (void)initDatas
{
    haveSelectWash = NO;
    self.dataArray = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    
    XBBOrder *o_1 = [[XBBOrder alloc] init];
    o_1.title = @"洗车";
    o_1.hasIndication = NO;
    o_1.iconImage = [UIImage imageNamed:@"washImage"];
    [self.dataArray addObject:o_1];
    
    XBBOrder *o_1_1 = [[XBBOrder alloc] init];
    o_1_1.title = @"外1";
    o_1_1.price = 21.;
    o_1_1.selectImage = [UIImage imageNamed:@"noselectImage"];
    [o_1.xbbOrders addObject:o_1_1];
    
    XBBOrder *o_1_2 = [[XBBOrder alloc] init];
    o_1_2.title = @"外1 + 内饰清洗";
    o_1_2.price = 41.;
    o_1_2.selectImage = [UIImage imageNamed:@"noselectImage"];
    [o_1.xbbOrders addObject:o_1_2];
    
    XBBOrder *o_2 = [[XBBOrder alloc] init];
    o_2.title = @"DIY";
    o_2.hasIndication = YES;
    o_2.iconImage = [UIImage imageNamed:@"diyIcon"];
    [self.dataArray addObject:o_2];
    
    XBBOrder *o_3 = [[XBBOrder alloc] init];
    o_3.title = @"美容";
    o_3.hasIndication = YES;
    o_3.iconImage = [UIImage imageNamed:@"facialIcon"];
    [self.dataArray addObject:o_3];
    
    XBBOrder *o_4 = [[XBBOrder alloc] init];
    o_4.title = @"优惠券";
    o_4.hasIndication = YES;
    o_4.detailString = @"暂无可用优惠券";
    o_4.iconImage = [UIImage imageNamed:@"couponIcon"];
    [self.dataArray addObject:o_4];
    
    
    XBBOrder *o_5 = [[XBBOrder alloc] init];
    o_5.title = @"车辆位置";
    o_5.hasIndication = YES;
    o_5.iconImage = [UIImage imageNamed:@"carCoupon"];
    [self.dataArray addObject:o_5];
    
    XBBOrder *o_6 = [[XBBOrder alloc] init];
    o_6.title = @"服务时间";
    o_6.hasIndication = NO;
    o_6.iconImage = [UIImage imageNamed:@"timerIcon"];
    [self.dataArray addObject:o_6];
    
    XBBOrder *time_1 = [[XBBOrder alloc] init];
    time_1.title = @"即刻上门";
    time_1.selectImage = [UIImage imageNamed:@"noselectImage"];
    [o_6.xbbOrders addObject:time_1];
    
    XBBOrder *time_2 = [[XBBOrder alloc] init];
    time_2.title = @"预约上门";
    time_2.selectImage = [UIImage imageNamed:@"noselectImage"];
    [o_6.xbbOrders addObject:time_2];
    [self initUpdateData];

   
}

- (void)initUpdateData
{
    if (self.dataSource == nil) {
        self.dataSource = [NSMutableArray array];
    }else
    {
        [self.dataSource removeAllObjects];
    }
    for (XBBOrder *objcet in self.dataArray) {
        [self.dataSource addObject:objcet];
        if (objcet.xbbOrders) {
            for (XBBOrder *order in objcet.xbbOrders) {
                [self.dataSource addObject:order];
            }
        }
    }
    
    [self.tableView reloadData];
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
- (void)initUIs
{
    [self setNavigationBarControl];
    [self addTabBar];
    [self addtabview];
    [self alphatoZero];
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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"下单"];
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
   
    priceTotalTitle = [[XBBListHeadLabel alloc] initWithFrame:CGRectMake(0, 0, (XBB_Screen_width/3)*2 , barView.bounds.size.height)];
    [priceTotalTitle setTextColor:XBB_NavBar_Color];
    [priceTotalTitle setFont:[UIFont boldSystemFontOfSize:16.]];
    [barView addSubview:priceTotalTitle];
    [priceTotalTitle setTextAlignment:NSTextAlignmentCenter];
    [self addAllPrice];
    priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",selectAllPrice>0?selectAllPrice:0.00];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width- XBB_Screen_width/3, 0, XBB_Screen_width/3, barView.bounds.size.height)];
    [button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = XBB_NavBar_Color;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:XBB_Bg_Color forState:UIControlStateNormal];
    [barView addSubview:button];
   
}

- (void)addtabview
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64., XBB_Screen_width, XBB_Screen_height-64.-44.)];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddOrderTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:identifier_2];
    
    self.tableView.separatorColor = kUIColorFromRGB(0xdddddd);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self initUIs];
    [self initDatas];

}


#pragma mark datadisposed
- (IBAction)backViewController:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark actions

- (void)submit:(id)sender
{
    
    DLog(@"%@\n%@\n%@\n%@",self.selectWashOrderObject,self.selectDIYArray,self.selectFacialArray,planTime);
}





#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    XBBOrder *object = self.dataSource[indexPath.row];

    if (object.iconImage) {
        AddOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[AddOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.titleLabel.text = object.title;
        cell.indicationImage.alpha = object.hasIndication?1.:0.;
        cell.detailLabel.text = [object.detailString length] > 0?object.detailString:@"";
        cell.headImageView.image = object.iconImage;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        if ([[self.dataArray lastObject] isEqual:object]|| [[self.dataArray firstObject] isEqual:object]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else
    {
        AddOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_2];
        cell.tag = 11;
        if (cell == nil) {
            cell = [[AddOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_2];
        }
        
        
        cell.priceLabel.alpha = 1.f;
        cell.selectImageView.alpha = 1.f;
        cell.titleLabel.text = object.title;
        if ([object isEqual:(XBBOrder *)[[[self.dataArray lastObject]xbbOrders]lastObject]]) {
            cell.priceLabel.text = planTime?planTime:@"";
        }else if ([object isEqual:[[self.dataArray lastObject] xbbOrders][0]]){
            cell.priceLabel.text = @"";
        }else
        {
            cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",object.price];
        }
        cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
        if ([[self.dataArray[1] xbbOrders] count] > 0) {
            for (XBBOrder *ob_1 in [self.dataArray[1] xbbOrders]) {
                if ([object isEqual:ob_1]) {
                    cell.selectImageView.alpha = 0;
                }
            }
        }
        if ([[self.dataArray[2] xbbOrders] count] > 0) {
            for (XBBOrder *ob_1 in [self.dataArray[2] xbbOrders]) {
                if ([object isEqual:ob_1]) {
                    cell.selectImageView.alpha = 0;
                }
            }
        }
        
        if (haveSelectWash == NO) {
            if ([object isEqual:[self.dataArray[0] xbbOrders][0]]) {
                cell.tag = 22;
                washType = 11;
                cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                selectWashPrice = object.price;
                [self addAllPrice];
                self.selectWashOrderObject = object;
                
                
            }else if ([object isEqual:[self.dataArray[0] xbbOrders][1]])
            {
                cell.tag = 11;
                cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
            }
        }else
        {
            
            if (self.selectWashOrderObject != nil && [self.selectWashOrderObject isEqual: object]) {
                if ([object isEqual:[self.dataArray[0] xbbOrders][0]]) {
                    cell.tag = 22;
                    washType = 11;
                    cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                    selectWashPrice = object.price;
                    [self addAllPrice];
                    
                    
                }else if ([object isEqual:[self.dataArray[0] xbbOrders][1]])
                {
                    cell.tag = 22;
                    washType = 22;
                    cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                    selectWashPrice = object.price;
                    [self addAllPrice];
                }
                
            }
            
        }

        if ([planTime length]==0|| planTime == nil) {
            if ([object isEqual:[[self.dataArray lastObject] xbbOrders][0]]) {
                cell.tag = 22;
                isJust = YES;
                cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
            }
            
        }else
        {
            if ([object isEqual:[[self.dataArray lastObject] xbbOrders][1]]) {
                cell.tag = 22;
                isJust = NO;
                cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        for (XBBOrder *ooo in [self.dataArray[1] xbbOrders]) {
            if ([ooo isEqual:object]) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        for (XBBOrder *ooo in [self.dataArray[2] xbbOrders]) {
            if ([ooo isEqual:object]) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        
        
        
        return cell;
    }
    return nil;
}

- (void)addAllPrice
{
    selectAllPrice = selectDIYPrice + selectWashPrice + selectFaicalPrice  - selectCouponPrice;
     priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",selectAllPrice>0?selectAllPrice:0.00];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBBOrder *object = self.dataSource[indexPath.row];
    

    
    if ([object isEqual:[self.dataArray[0] xbbOrders][0]]||[object isEqual:[self.dataArray[0] xbbOrders][1]]) {
        haveSelectWash = YES;
        AddOrderDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
       
        if (cell.tag == 11) {
            cell.tag = 22;
            selectWashPrice = object.price;
            [self addAllPrice];
            cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
            if (indexPath.row == 1) {
                washType = 11;
                NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:2 inSection:indexPath.section];
                AddOrderDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath_1];
                cell.tag = 11;
                cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
                self.selectWashOrderObject = object;
                
                
            }else
            {
                washType = 22;
                NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
                AddOrderDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath_1];
                cell.tag = 11;
                cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
                self.selectWashOrderObject = object;
            }
        }
        else
        {
            self.selectWashOrderObject = nil;
            cell.tag = 11;
            washType = 0;
            selectWashPrice = 0;
            [self addAllPrice];
            cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
            
        }
    }

    if ([object isEqual:[[self.dataArray lastObject] xbbOrders][0]]||[object isEqual:[[self.dataArray lastObject] xbbOrders][1]]) {
        AddOrderDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.tag == 11) {
            cell.tag = 22;
            cell.selectImageView.image = [UIImage imageNamed:@"selectImage"];
            if (indexPath.row == self.dataSource.count-2) {
                NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:indexPath.section];
                AddOrderDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath_1];
                cell.tag = 11;
                cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
                
            }else
            {
                NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:self.dataSource.count-2 inSection:indexPath.section];
                AddOrderDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath_1];
                cell.tag = 11;
                cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
            }
            
        }
        if ([object isEqual:[self.dataSource lastObject]]) {
            isJust = NO;
            AddPlanOrderViewController *plan = [[AddPlanOrderViewController alloc] init];
            plan.planTime = ^(NSString *time){
                planTime = time;
                cell.priceLabel.text = time;
//                object.timeString = time;
                if (time==nil|| time.length==0) {
                    cell.selectImageView.image = [UIImage imageNamed:@"noselectImage"];
                    cell.tag = 11;
                    isJust = YES;
                    
                    NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:self.dataSource.count-2 inSection:indexPath.section];
                    AddOrderDetailTableViewCell *cell_1 = [tableView cellForRowAtIndexPath:indexPath_1];
                    cell_1.selectImageView.image = [UIImage imageNamed:@"selectImage"];
                    cell_1.tag = 22;
                    
                }
            };
            [self.navigationController pushViewController:plan animated:YES];
        }else{
            planTime = nil;
            isJust = YES;
            NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:indexPath.section];
            AddOrderDetailTableViewCell *cell_1 = [tableView cellForRowAtIndexPath:indexPath_1];
            cell_1.priceLabel.text = @"";
        }
    }
    
    if ([object isEqual:self.dataArray[1]]) {
        
        XBBDIYViewController *diy_1 = [[XBBDIYViewController alloc] init];
        diy_1.selectCarType = carType;
        diy_1.washType = washType;
        diy_1.selectArray = object.xbbOrders;
        diy_1.selectObjectsBlock = ^(NSHashTable *selectHashObject){
            NSMutableArray *arr = [NSMutableArray array];
            selectDIYPrice = 0;
            for (XBBDiyObject *obj in selectHashObject) {
                XBBOrder *order = [[XBBOrder alloc] init];
                order.title = obj.proName;
                if (carType == 1) {
                   
                    order.price = obj.price1;
                    
                }else
                {
                     order.price = obj.price2;
                }
                selectDIYPrice += order.price;
                order.xbbid = obj.pid;
                [arr addObject:order];
            }
            [self addAllPrice];
            object.xbbOrders = arr;
            self.selectDIYArray = arr;
            [self initUpdateData];
            
        };
        [self presentViewController:diy_1 animated:YES completion:nil];
        

        return;
        
        DIYSelectTableViewController *diy = [[DIYSelectTableViewController alloc] init];
        diy.selectCarType = 1;
        diy.washType = washType;
        diy.diyServers = ^(id mode){
            selectDIYPrice = [mode[@"price"] floatValue];
            [self addAllPrice];
            NSArray *array = mode[@"diy"];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                XBBOrder *o_o = [[XBBOrder alloc] init];
                o_o.title = dic[@"p_info"];
                float price = 0.00;
                if (carType == 1) {
                    price = [dic[@"p_price"] floatValue];
                }else
                {
                    price = [dic[@"p_price2"] floatValue];
                }
                o_o.price = price;
                [arr addObject:o_o];
            }
            [self addAllPrice];
            object.xbbOrders = arr;
            [self initUpdateData];
        };
        [self.navigationController pushViewController:diy animated:YES];
    }
    
    if ([object isEqual:self.dataArray[2]]) {
        
//        XBBFacialViewController *fa = [[XBBFacialViewController alloc] init];
//        fa.washType = washType;
//        fa.selectCarType = carType;
//        fa.selectFacialArray = object.xbbOrders;
//        fa.facialBlock = ^(NSHashTable *selectHashObject){
//            NSMutableArray *arr = [NSMutableArray array];
//            selectFaicalPrice = 0;
//            for (XBBDiyObject *object in selectHashObject) {
//                XBBOrder *order = [[XBBOrder alloc] init];
//                order.title = object.proName;
//                order.xbbid = object.pid;
//                if (carType == 1) {
//                    order.price = object.price1;
//                }
//                else
//                {
//                    order.price = object.price2;
//                }
//                selectFaicalPrice += order.price;
//                [arr addObject:order];
//                
//            }
//            [self addAllPrice];
//            object.xbbOrders = arr;
//            self.selectFacialArray = arr;
//            [self initUpdateData];
//        };
//        [self presentViewController:fa animated:YES completion:nil];
//        
//        
//        
//        return;
        FaicalSelectTableViewController *faical = [[FaicalSelectTableViewController alloc]init];
        faical.selectCarType = 1;
        faical.washType = washType;
        faical.diyServers = ^(id mode){
            selectFaicalPrice = [mode[@"price"] floatValue];
            [self addAllPrice];
            NSArray *array = mode[@"noWash"];
            NSArray *twoArray = mode[@"wax"];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                XBBOrder *o_o = [[XBBOrder alloc] init];
                o_o.title = dic[@"p_info"];
                float price = 0.00;
                if (carType == 1) {
                    price = [dic[@"p_price"] floatValue];
                }else
                {
                    price = [dic[@"p_price2"] floatValue];
                }
                o_o.price = price;
                [arr addObject:o_o];
            }
            for (NSDictionary *dic in twoArray) {
                XBBOrder *o_o = [[XBBOrder alloc] init];
                o_o.title = dic[@"p_info"];
                float price = 0.00;
                if (carType == 1) {
                    price = [dic[@"p_price"] floatValue];
                }else
                {
                    price = [dic[@"p_price2"] floatValue];
                }
                o_o.price = price;
                [arr addObject:o_o];
            }

            object.xbbOrders = arr;
            self.selectFacialArray = arr;
            [self initUpdateData];
        };
        [self.navigationController pushViewController:faical animated:YES];
    }
    
    if ([object isEqual:self.dataArray[3]]) {
        
    }
    if ([object isEqual:self.dataArray[4]]) {
        
    }
}

#pragma mark  memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
