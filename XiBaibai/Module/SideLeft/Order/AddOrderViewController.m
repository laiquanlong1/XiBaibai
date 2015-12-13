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
#import "AddPlanOrderViewController.h"
#import "PayTableViewController.h"
#import "MyCouponsViewController.h"
#import "MyCarTableViewController.h"

#import "AddOrderDetailTableViewCell.h"
#import "AddOrderTableViewCell.h"
#import "XBBOrder.h"

#import "XBBFacialViewController.h"
#import "XBBDIYViewController.h"
#import "XBBDiyObject.h"
#import "XBBAddressSelectViewController.h"
#import "XBBAddressModel.h"
#import "MyCouponsModel.h"
#import "MyCarModel.h"



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

@property (nonatomic, strong) NSArray *allCoupons;

@property (nonatomic, copy) NSArray *selectDIYArray;

@property (nonatomic, copy) NSArray *selectFacialArray;

@property (nonatomic, strong) XBBOrder *selectWashOrderObject;

@property (nonatomic, strong) XBBAddressModel *selectAddress;

@property (nonatomic, strong) MyCarModel  *selectCar;

@property (nonatomic, strong) MyCouponsModel *selectCouponModel;

@end



@implementation AddOrderViewController

#pragma mark dataDispose

- (void)initViewDidLoadDatas
{
    carType = [UserObj shareInstance].carModel.c_type;
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
            // 0当前可以使用,1已使用,2已过期,3未到使用期 (state)    优惠券类型0现金券，1免单洗车券(type)
            [NetworkHelper postWithAPI:XBB_Coupons_select parameter:@{@"uid":[[UserObj shareInstance] uid]} successBlock:^(id response) {
                DLog(@"%@",response)
                if (response && [response[@"code"] integerValue] == 1) {
                    NSArray *couponsDics = response[@"result"];
                    NSMutableArray *couponsModels = [NSMutableArray array];
                    for (NSDictionary *couponsDic in couponsDics) {
                        if ([couponsDic[@"state"] integerValue] == 0) {
                            if ([couponsDic[@"type"] integerValue] == 0) {
                                MyCouponsModel *coupon = [[MyCouponsModel alloc] init];
                                coupon.coupons_name = couponsDic[@"coupons_name"];
                                coupon.state = couponsDic[@"state"];
                                coupon.time = couponsDic[@"time"];
                                coupon.couponsId = couponsDic[@"id"];
                                coupon.uid = couponsDic[@"uid"];
                                coupon.coupons_price = couponsDic[@"coupons_price"];
                                coupon.coupons_remark = couponsDic[@"coupons_remark"];
                                coupon.number = couponsDic[@"number"];
                                coupon.effective_time = couponsDic[@"effective_time"];
                                coupon.expired_time = couponsDic[@"expired_time"];
                                coupon.type = couponsDic[@"type"];
                                [couponsModels addObject:coupon];
                            }
                        }
                    }
                    self.allCoupons = couponsModels;
                    self.selectCouponModel = nil;
                    for (MyCouponsModel *model in couponsModels) {
                        if (self.selectCouponModel == nil) {
                            self.selectCouponModel = model;
                        }
                        NSDate *selectCouponDate = [NSDate dateWithTimeIntervalSince1970:[self.selectCouponModel.expired_time integerValue]];
                        NSDate *modelDate = [NSDate dateWithTimeIntervalSince1970:[model.expired_time integerValue]];
                        
                        
                        NSDate *date_one = [selectCouponDate earlierDate:modelDate];
                        if ([date_one isEqualToDate:modelDate]) {
                            self.selectCouponModel = model;
                        }
                    }
                    
                    if (self.selectCouponModel) {
                        XBBOrder *couponSuperOrder = self.dataArray[3];
                        XBBOrder *couponModel = [[XBBOrder alloc] init];
                        couponModel.title = self.selectCouponModel.coupons_name;
                        couponModel.price = [self.selectCouponModel.coupons_price floatValue];
                        selectCouponPrice = couponModel.price;
                        [couponSuperOrder.xbbOrders addObject:couponModel];
                    }
                    [self initUpdateData];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
                
                
                
            } failBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"获取优惠券错误!"];
            }];
            
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
    carType = [UserObj shareInstance].carModel.c_type;
    self.selectCar = [[UserObj shareInstance] carModel];
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
    
    if (self.selectArray) {
        
        NSMutableArray *arr_1 = [NSMutableArray array];
       
        NSMutableArray *arr_2 = [NSMutableArray array];
        
        for (XBBDiyObject *object in self.selectArray) {
            if (object.type == 1) {
                XBBOrder *order_1 = [[XBBOrder alloc] init];
                order_1.title = object.proName;
                
                if (carType == 1) {
                    order_1.price = object.price1;
                }else
                {
                    order_1.price = object.price2;
                }
                
                
                order_1.xbbid = object.pid;
                [arr_1 addObject:order_1];
                
                
            }else if (object.type == 2)
            {
                XBBOrder *order = [[XBBOrder alloc] init];
                order.title = object.proName;
                if (carType == 1) {
                    order.price = object.price1;
                }else
                {
                    order.price = object.price2;
                }
                [arr_2 addObject:order];
                order.xbbid = object.pid;
            }
        }
        
        o_2.xbbOrders = arr_1;
        self.selectDIYArray = arr_1;
        o_3.xbbOrders = arr_2;
        self.selectFacialArray = arr_2;
    }
    
        
    
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
    

    if (self.hasLocation) {
        XBBAddressModel *model = [[XBBAddressModel alloc] init];
        model.address = [[UserObj shareInstance] currentAddress];
        model.remarkAddress = [[UserObj shareInstance] currentAddressDetail];
        model.coordinate = [[UserObj shareInstance] currentCoordinate];
        
        self.selectAddress = model;
        XBBOrder *o_5_1 = [[XBBOrder alloc] init];
        o_5_1.title = [NSString stringWithFormat:@"%@ %@",model.address,model.remarkAddress];
        self.hasLocation = NO;
        [o_5.xbbOrders addObject:o_5_1];
    }
    
    
    
    
    
    
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
    NSMutableArray *arr = [NSMutableArray array];
    
    for (XBBOrder *objcet in self.dataArray) {
        [arr addObject:objcet];
        if (objcet.xbbOrders) {
            for (XBBOrder *order in objcet.xbbOrders) {
                [arr addObject:order];
            }
        }
    }
    self.dataSource = arr;
    
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
   
    priceTotalTitle = [[XBBListHeadLabel alloc] initWithFrame:CGRectMake(0, 0, (XBB_Screen_width/2) , barView.bounds.size.height)];
    [priceTotalTitle setTextColor:XBB_NavBar_Color];
    [priceTotalTitle setFont:[UIFont boldSystemFontOfSize:16.]];
    [barView addSubview:priceTotalTitle];
    [priceTotalTitle setTextAlignment:NSTextAlignmentCenter];
    [self addAllPrice];
    priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",selectAllPrice>0?selectAllPrice:0.00];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width- XBB_Screen_width/2, 0, XBB_Screen_width/2, barView.bounds.size.height)];
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
    
    self.tableView.separatorColor = XBB_separatorColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initUIs];
    [self initDatas];

}

#pragma mark actions
- (IBAction)backViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)submit:(id)sender
{
    if (self.selectCar == nil) {
         [SVProgressHUD showErrorWithStatus:@"请设置车辆！"];
        return;
    }
    if (self.selectAddress == nil) {
         [SVProgressHUD showErrorWithStatus:@"请选择车辆停放位置！"];
        return;
    }
    if (self.selectWashOrderObject == nil && self.selectDIYArray.count > 0) {
        [SVProgressHUD showErrorWithStatus:@"您选择的DIY项目需要洗车才能下单！"];
        return;
    }
    [self packageData];
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
        
        if ([object isEqual:self.dataArray[3]]) {
            if (object.xbbOrders.count > 0) {
                cell.detailLabel.alpha = 0.;
            }
        }
        
        
        return cell;
    }else
    {
        AddOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_2];
        cell.addressLabel.text = @"";
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
            if (self.selectArray) {
                selectDIYPrice = 0;
                for (XBBOrder *oooo in self.selectDIYArray) {
                    selectDIYPrice += oooo.price;
                }
                self.selectArray = nil;
            }
            
        }
        for (XBBOrder *ooo in [self.dataArray[2] xbbOrders]) {
            if ([ooo isEqual:object]) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (self.selectArray) {
                selectFaicalPrice = 0;
                for (XBBOrder *oooo in self.selectFacialArray) {
                    selectFaicalPrice += oooo.price;
                    
                }
            }
        }
        
        for (XBBOrder *ooo in [self.dataArray[4] xbbOrders]) {
            if ([ooo isEqual:object]) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.selectImageView.alpha = 0.;
                cell.priceLabel.text = @"";
                cell.titleLabel.text = @"";
                [cell.addressLabel setHidden:NO];
                cell.addressLabel.text = object.title;
    
            }
        }
        if ([[self.dataArray[3] xbbOrders] count] > 0) {
            for (XBBOrder *ob in [self.dataArray[3]xbbOrders]) {
                if ([object isEqual:ob]) {
                    if (ob.price > selectDIYPrice + selectWashPrice + selectFaicalPrice) {
                        selectCouponPrice = selectDIYPrice + selectWashPrice + selectFaicalPrice-0.01;
                        [self addAllPrice];
                    }
                    cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f", selectCouponPrice==0?selectCouponPrice:-selectCouponPrice];
                    cell.selectImageView.alpha = 0;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                }
            }
        }
        
        return cell;
    }
    return nil;
}

- (void)addAllPrice
{
    if (self.selectCouponModel) {
        if ([self.selectCouponModel.coupons_price floatValue] - ( selectDIYPrice + selectWashPrice + selectFaicalPrice) > 0) {
            selectCouponPrice = selectDIYPrice + selectWashPrice + selectFaicalPrice - 0.01;
        }else
        {
            selectCouponPrice = [self.selectCouponModel.coupons_price floatValue];
        }
    }
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
            [self presentViewController:plan animated:YES completion:nil];
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
        diy_1.washType = washType;
        diy_1.selectArray = object.xbbOrders;
        diy_1.selectObjectsBlock = ^(NSHashTable *selectHashObject){
            NSMutableArray *arr = [NSMutableArray array];
           selectDIYPrice = 0;
            for (XBBDiyObject *obj in selectHashObject) {
                
                XBBOrder *order = [[XBBOrder alloc] init];
                order.title = obj.proName;
                if (carType == 1)
                {
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
        
    }
    
    if ([object isEqual:self.dataArray[2]]) {
        
        XBBFacialViewController *fa = [[XBBFacialViewController alloc] init];
        fa.washType = washType;
        fa.selectFacialArray = object.xbbOrders;
        fa.facialBlock = ^(NSHashTable *selectHashObject){
            NSMutableArray *arr = [NSMutableArray array];
            selectFaicalPrice = 0;
            for (XBBDiyObject *object in selectHashObject) {
                XBBOrder *order = [[XBBOrder alloc] init];
                order.title = object.proName;
                order.xbbid = object.pid;
                if (carType == 1) {
                    order.price = object.price1;
                }
                else
                {
                    order.price = object.price2;
                }
                order.p_wash_free = object.p_wash_free;

                
                selectFaicalPrice += order.price;
                [arr addObject:order];
            }
            [self addAllPrice];
            object.xbbOrders = arr;
            self.selectFacialArray = arr;
            [self initUpdateData];
        };
        [self presentViewController:fa animated:YES completion:nil];
        return;

    }
    
    if ([object isEqual:self.dataArray[3]]) {
        MyCouponsViewController *coupons = [[MyCouponsViewController alloc] init];
        coupons.isAddoder = YES;
        coupons.couponsBlock = ^(MyCouponsModel *param){
            if (param) {
                NSMutableArray *arr = [NSMutableArray array];
                self.selectCouponModel = param;
                XBBOrder *oder = [[XBBOrder alloc] init];
                oder.title = param.coupons_name;
                oder.price = [param.coupons_price floatValue];
                selectCouponPrice = oder.price;
                [arr addObject:oder];
                object.xbbOrders = arr;
            }else
            {
                object.xbbOrders = nil;
            }
            [self addAllPrice];
            [self initUpdateData];
        };
        [self presentViewController:coupons animated:YES completion:nil];
        
    }
    if ([object isEqual:self.dataArray[4]]) {
 
        XBBAddressSelectViewController *address = [[UIStoryboard storyboardWithName:@"XBBOne" bundle:nil] instantiateViewControllerWithIdentifier:@"XBBAddressSelectViewController"];
        address.navigationTitle = @"地址选择";
        address.selectAddressBlock = ^(XBBAddressModel *model){
            
            if (model) {
                self.selectAddress = model;
                XBBOrder *order = [[XBBOrder alloc] init];
                order.title = [NSString stringWithFormat:@"%@ %@",model.address,model.remarkAddress];
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:order];
                object.xbbOrders  = arr;
                [self initUpdateData];
            }else
            {
                object.xbbOrders = nil;
                [self initUpdateData];
            }
        };
        [self presentViewController:address animated:YES completion:nil];
        
        
    }
}

#pragma mark packageDataToJumpNextPayPage

- (void)packageData
{
    NSMutableDictionary *orderDic = [NSMutableDictionary dictionary];
    [orderDic setObject:[UserObj shareInstance].uid forKey:@"uid"];

    [orderDic setObject:self.selectAddress.address?self.selectAddress.address:@"" forKey:@"location"];
    
    [orderDic setObject:self.selectAddress.remarkAddress?self.selectAddress.remarkAddress:@"" forKey:@"remark"];
    [orderDic setObject:[NSString stringWithFormat:@"%f",self.selectAddress.coordinate.latitude] forKey:@"location_lt"];
    [orderDic setObject:[NSString stringWithFormat:@"%f",self.selectAddress.coordinate.longitude] forKey:@"location_lg"];
    NSMutableArray *p_proArray = [NSMutableArray array];
    NSMutableString *p_ids = [NSMutableString string];
    if (self.selectWashOrderObject) {
        [p_ids appendFormat:@"%@,",self.selectWashOrderObject.xbbid];
        NSDictionary *dic = @{@"p_info":self.selectWashOrderObject.title,@"p_price":@(self.selectWashOrderObject.price)};
        [p_proArray addObject:dic];
    }
    if (self.selectDIYArray.count > 0) {
        for (XBBOrder *order in self.selectDIYArray) {
            DLog(@"%@",order.xbbid)
            
            NSDictionary *dic = @{@"p_info":order.title,@"p_price":@(order.price)};
            [p_proArray addObject:dic];
            
            [p_ids appendFormat:@"%@,",order.xbbid];
        }
    }
    if (self.selectFacialArray.count > 0) {
        for (XBBOrder *order in self.selectFacialArray) {
            [p_ids appendFormat:@"%@,",order.xbbid];
            NSDictionary *dic = @{@"p_info":order.title,@"p_price":@(order.price)};
            [p_proArray addObject:dic];
        }
    }
    if ([[p_ids substringWithRange:NSMakeRange([p_ids length]-1, 1)] isEqualToString:@","]) {
        [p_ids deleteCharactersInRange:NSMakeRange([p_ids length]-1, 1)];
    }
    
    [orderDic setObject:p_ids forKey:@"p_ids"];
    [orderDic setObject:[NSString stringWithFormat:@"%.2f",selectAllPrice]? [NSString stringWithFormat:@"%.2f",selectAllPrice]:@"0"forKey:@"total_price"];
    if (self.selectCouponModel) {
        [orderDic setObject:self.selectCouponModel.couponsId forKey:@"coupons_id"];
    }else
    {
        [orderDic setObject:@"" forKey:@"coupons_id"];

    }
    [orderDic setObject:planTime?planTime:@"" forKey:@"plan_time"];
    
     MyCarModel *carModel = [UserObj shareInstance].carModel;
      NSString *carId = nil;
    if (self.selectCar) {
        carId = [NSString stringWithFormat:@"%d",carModel.carId];
    }else
    {
        carId = @"";
    }
    [orderDic setObject:carId forKey:@"c_ids"];
    
//    [orderDic setObject:<#(nonnull id)#> forKey:@"order_reg_id"];
    PayTableViewController *pay = [[PayTableViewController alloc] init];
    pay.dic_prama = orderDic; // 字典参数
    pay.pro_Dics = [p_proArray copy]; // 数组

    pay.location = [NSString stringWithFormat:@"%@ %@",self.selectAddress.address?self.selectAddress.address:@"",self.selectAddress.remarkAddress?self.selectAddress.remarkAddress:@""];
    pay.planTime = planTime;
     pay.couponprice = selectCouponPrice;
    
    
    [self.navigationController pushViewController:pay animated:YES];

    
}

#pragma mark  memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
