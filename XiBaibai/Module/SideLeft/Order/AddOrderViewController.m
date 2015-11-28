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



#define START_TIME @"reserve_start_time"
#define END_TIME @"reserve_end_time"

@interface AddOrderViewController ()<AVAudioRecorderDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    
    NSString *startReminderTime; // 提示开始时间
    NSString *endReminderTime; // 提示结束时间
    
    
    UITextView *txtView;//备注内容
    UILabel *labtxtviewpl;//txtview的提示内容
    
    UIView *viewVoids;//语音
    UIImageView *imgVoids;//长按录音按钮
    
    AVAudioRecorder *recorder;
    NSURL *urlPlay;
    UIButton *btnsound;//播放录音
    
    UIAlertView *alertAudio;
    
    
    UIScrollView *mainScrollView; //主滚动视图
    
    UserObj *userObj;
    
    NSInteger selectTimeWay; // 选择预约方式 1为即刻上门  2为预约上门
    NSInteger selectWashCar; // 11.外观清洗 22.整车清洗 0.没有选择
    NSInteger selectCarType; //  车类型
    

    UIView *userView; // 普通信息背景
    XBBListHeadLabel *carTitleLabel;
    XBBListContentLabel *carMessageLabel;
    
    XBBListHeadLabel *addressTitleLabel;
    XBBListContentLabel *addressMessageLabel;
    
    
    XBBListHeadLabel *timeTitleLabel;
    XBBListContentLabel *justLabel;
    UIButton *selectWayButtonOne;
    XBBListContentLabel *planLabel;
    UIButton *selectWayButtonTWO;
    
    XBBListHeadLabel *washTitleLabel;
    XBBListContentLabel *waiguanLabel;
    UIButton *washSelectButtonOne;
    XBBListContentLabel *allWashLabel;
    UIButton *washSelectButtonTWO;
    XBBListContentLabel *washPriceLabel;
    
    
    UIView *lineView; // 线1
    UIView *lineView_1;
    UIView *lineView_2;
    UIView *lineView_3;
    UIView *lineView_4;
    UIView *lineView_5;
    
    XBBListHeadLabel *facialTitleLabel;
    UITextField *facialFiled; // 美容选择
    XBBListContentLabel *facialPriceLabel; // 列表内容标签
    
    
    XBBListHeadLabel *couponTitle;
    XBBListContentLabel *couponContentLabel;
    XBBListContentLabel *couponPriceLabel;
    
    
    XBBListHeadLabel *priceTotalTitle;
    XBBListContentLabel *priceTotelContentLabel;
    
    
    
    UIView *bottomView; //底部
    float allPrice; // 总价格
    float washSelectPrice; // 洗车选择价格
    float facialSelectTotalPrice; // 美容价格
    float couponPrice; //  优惠券价格
    float appearancePrice; // 外观清洗
    float fullCarPrice; // 整车清洗
    
    
    NSInteger *washId; // 洗车id
    NSDictionary *washSelectCombo; // 选择的洗车套餐
    
    
    BOOL isKeyShow; // 是否显示键盘
    UIControl *control; // 控制器
    
    // 地址选择区
    UIImageView *imgHome; // 家
    BOOL isHome;
    UIImageView *imgCompany; // 公司
    BOOL isCompany;
    
   
    // 默认优惠券区
    BOOL hasWashCoupon; // 判断是否有洗车券
    NSDate *defaultDate; // 默认时间
    NSDictionary *defaultCouponCashDic; // 优惠现金券
    NSDictionary *defaultCouponWashDic_hasWashCoupon; // 洗车券
    
    
    
    NSString *couponsId; // 优惠券id
   
}


@property (nonatomic, copy) NSDictionary *diyDic;
@property (nonatomic, copy) NSString *planTime; // 预约时间

// 动画
@property(nonatomic,strong) NSTimer *animationTimer;
@property(nonatomic,strong) UIImageView *bgImageView;

// 洗车选择数组
@property (nonatomic, copy) NSArray *washArray;


@property (nonatomic, assign) NSInteger isServerTime; // 是否是服务时间

@end



@implementation AddOrderViewController



#pragma mark alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 设置车类型
    if (alertView.tag == 112211) {
        if (buttonIndex == 1) {
            MyCarTableViewController *mayCar = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyCarTableViewController"];
            [self.navigationController pushViewController:mayCar animated:YES];
        }
        return;
    }
    
    if ([alertView.title isEqualToString:@"请设置默认车辆"]) {
        if (buttonIndex == 1) {
            MyCarTableViewController *carTableVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyCarTableViewController"];
            [self.navigationController pushViewController:carTableVC animated:YES];
        }
        return;
    }
    
}


#pragma mark 车辆信息

- (void)carMessageUI
{
    // 车辆信息标题
    carTitleLabel = [[XBBListHeadLabel alloc] init];
    carTitleLabel.text = @"车辆信息 :";
    
    [carTitleLabel adjustsFontSizeToFitWidth];
    [userView addSubview:carTitleLabel];
    [carTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(userView.mas_top);
        make.left.mas_equalTo(20);
    }];
    carTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    // 车辆信息内容
    carMessageLabel = [[XBBListContentLabel alloc] init];
    
    
    
    
    [userView addSubview:carMessageLabel];
    //    carMessageLabel.backgroundColor = [UIColor redColor];
    //    carMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    
    
    
    [carMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(userView.mas_top);
        make.left.mas_equalTo(carTitleLabel.mas_rightMargin).mas_offset(20);
        //        make.left.mas_equalTo(carTitleLabel.mas_rightMargin).mas_offset(20);
    }];
    
    
    // 线
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = kUIColorFromRGB(0xd9d9d9);
    [userView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(userView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(carTitleLabel.mas_bottom);
        make.left.mas_equalTo(userView.mas_left);
    }];
}

- (void)fetchCarUserInfo
{
    //请求默认车辆
    NSMutableDictionary *dicCar=[NSMutableDictionary dictionary];
    [dicCar setValue:[UserObj shareInstance].uid forKey:@"uid"];
    [NetworkHelper postWithAPI:car_select parameter:dicCar successBlock:^(id response) {
        NSLog(@"车辆dics%@",response);
        if ([response[@"code"] integerValue] == 1) {
            NSDictionary *result=[response objectForKey:@"result"];
            NSString *default_id=[result objectForKey:@"default"];
            NSArray *arrCar=[result objectForKey:@"list"];
            if (arrCar.count == 0) {
            }else
            {
                for (NSDictionary *dic in arrCar) {
                    if ([default_id isEqualToString:[dic objectForKey:@"id"]]) {
                        self.carDic = dic;
                        NSString *number = self.carDic[@"c_plate_num"];
                        NSString *name = self.carDic[@"c_brand"];
                        NSString *type = self.carDic[@"c_type"];
                        carMessageLabel.text = [NSString stringWithFormat:@"%@/%@/%@",number?number:@"",name?name:@"",[type integerValue]!=0?[CarInfo carType:[type integerValue]]:@""];
                        selectCarType = [self.carDic[@"c_type"] integerValue]; // 设置车类型
                    }
                }
            }
        } else {
            
        }
        
    } failBlock:^(NSError *error) {
        
    }];
}
#pragma mark 获取起止时间

// 获取起至时间
- (void)fetchStartStopTime
{
    
    startReminderTime = @"09:30";
    endReminderTime = @"17:30";
    
    [NetworkHelper postWithAPI:ServerTime parameter:nil successBlock:^(id response) {
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        if (response) {
            NSDictionary *dic = response;
            if ([dic[@"code"] integerValue] == 1) {
                NSDictionary *dics = dic[@"result"];
                endReminderTime = dics[END_TIME];
                startReminderTime  = dics[START_TIME];
                [userD setObject:startReminderTime forKey:START_TIME];
                [userD setObject:endReminderTime forKey:END_TIME];
                BOOL isBusiness = [self isBusinessTime];
                if (isBusiness) {
                    self.isServerTime = 1;
                }
                else
                {
                    self.isServerTime = 0;
                }
            }
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取服务时间网络错误"];
    }];
}


#pragma mark data

// 初始化数据
- (void)initData
{
    selectTimeWay = 1; // 选择预约方式（即刻）
    selectWashCar = 11; // 洗车方式
    hasWashCoupon = NO; // 判断是否有洗车券
    
    //  价格
    allPrice = 0.0;
    couponPrice = 0.0;
    washSelectPrice = 0.0;
    facialSelectTotalPrice = 0.0;
    appearancePrice = 0.0;
    fullCarPrice = 0.0;
    userObj = [UserObj shareInstance];
    self.location = userObj.currentAddress;
    self.location_lg = [NSString stringWithFormat:@"%f",userObj.currentCoordinate.longitude];
    self.location_lt = [NSString stringWithFormat:@"%f",userObj.currentCoordinate.latitude];
}


- (void)setCouponsPrice
{

    // 没有选择洗车时
    if (selectWashCar == 0) {
        // 有现金券
        if (defaultCouponCashDic) {
            [couponContentLabel setText:defaultCouponCashDic[@"coupons_name"]];
            couponPrice = [defaultCouponCashDic[@"coupons_price"] floatValue]>facialSelectTotalPrice ? facialSelectTotalPrice:[defaultCouponCashDic[@"coupons_price"] floatValue];
            couponsId = defaultCouponCashDic[@"id"];
            
        }else
        {
            [couponContentLabel setText:@"暂无优惠券"];
            couponPrice = 0.0f;
        }
    }else
    {
        // 有洗车券时
        if (defaultCouponWashDic_hasWashCoupon) {
            [couponContentLabel setText:defaultCouponWashDic_hasWashCoupon[@"coupons_name"]];
            couponPrice = washSelectPrice; // 洗车价
            couponsId = defaultCouponWashDic_hasWashCoupon[@"id"];
            
        }else if (defaultCouponCashDic) {
            [couponContentLabel setText:defaultCouponCashDic[@"coupons_name"]];
            couponPrice = [defaultCouponCashDic[@"coupons_price"] floatValue]>facialSelectTotalPrice?facialSelectTotalPrice:[defaultCouponCashDic[@"coupons_price"] floatValue];
            couponsId = defaultCouponCashDic[@"id"];
        }else
        {
            [couponContentLabel setText:@"暂无优惠券"];
             couponPrice = 0.0f;
        }
    }
   
    if (self.selectCouponWashDic) {
        // 洗车券
        if ([_selectCouponWashDic[@"type"] integerValue] == 1) {
            couponPrice = washSelectPrice; //[_selectCouponWashDic[@"coupons_price"] floatValue];
            [couponContentLabel setText:_selectCouponWashDic[@"coupons_name"]];
            // 现金券
        }else if ([_selectCouponWashDic[@"type"] integerValue] == 0) {
            couponPrice = [_selectCouponWashDic[@"coupons_price"] floatValue]>= (facialSelectTotalPrice+washSelectPrice)?(facialSelectTotalPrice+washSelectPrice)-0.01:[_selectCouponWashDic[@"coupons_price"] floatValue];
            [couponContentLabel setText:_selectCouponWashDic[@"coupons_name"]];
            
        }
        couponsId = _selectCouponWashDic[@"id"];
    }
    
    // 总价 = 洗车价 ＋ 美容价 － 优惠券价
    allPrice = washSelectPrice+facialSelectTotalPrice-couponPrice;
    
    if (facialSelectTotalPrice > 0.f || washSelectPrice > 0.f) {
        if (allPrice <= 0) {
            allPrice = 0.01f;
            couponPrice = couponPrice - 0.01f;
        }
    }
    
    [washPriceLabel setText:[NSString stringWithFormat: @"%.2f",washSelectPrice]];
    [priceTotelContentLabel setText:[NSString stringWithFormat:@"¥:  %.2f",allPrice]];
    [facialPriceLabel setText:[NSString stringWithFormat:@"%.2f",facialSelectTotalPrice]];
    [couponPriceLabel setText:[NSString stringWithFormat:@"%.2f",couponPrice==0.0?0.00:-couponPrice]];
}

// 更新了界面后更新数据
- (void)upData
{
    // 洗车选择
    for (NSDictionary *dic in self.washArray) {
        if ([dic[@"id"] integerValue] == 1) {
            // 车型判断
            switch (selectCarType) {
                case 1:
                {
                    appearancePrice = [dic[@"p_price"] floatValue];
                }
                    break;
                    
                default:
                {
                    appearancePrice = [dic[@"p_price2"] floatValue];
                }
                    break;
            }
            washSelectCombo = dic; // 初始化选择套餐
            
            [waiguanLabel setText:dic[@"p_name"]];
        }
        
        if ([dic[@"id"] integerValue] == 2) {
            
            switch (selectCarType) {
                case 1:
                {
                    fullCarPrice = [dic[@"p_price"] floatValue];
                }
                    break;
                    
                default:
                {
                    fullCarPrice = [dic[@"p_price2"] floatValue];
                }
                    break;
            }
             [allWashLabel setText:dic[@"p_name"]];
        }
        
    }

    washSelectPrice = appearancePrice; // 设置默认为外观价格
    
    [self setCouponsPrice]; //  设置优惠券价格
    
  
}



// 获取优惠券
- (void)fetchCoupons
{
    [NetworkHelper postWithAPI:YouhuiSelect_API parameter:@{@"uid":userObj.uid} successBlock:^(id response) {
        if (response) {
            NSDictionary *responseDic = response;
            if ([responseDic[@"code"] integerValue] == 1) {
                NSArray *couponArray = responseDic[@"result"];
                // 获取单个优惠券
                
                NSDate *tempTime = nil; // 临时时间
                
                for (NSDictionary *couponDic in couponArray) {
                    DLog(@"%@",couponDic);
                    // 未使用
                    if ([couponDic[@"state"] integerValue] == 0) {
                        // 是洗车券
                        if ([couponDic[@"type"] integerValue] == 1) {
                            hasWashCoupon = YES; //  是不是洗车券
                            defaultCouponWashDic_hasWashCoupon = couponDic;
                            
                        } else if ([couponDic[@"type"] integerValue] == 0) {
                            // 没有洗车券
                            
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                            [formatter setDateStyle:NSDateFormatterMediumStyle];
                            [formatter setTimeStyle:NSDateFormatterShortStyle];
                            [formatter setDateFormat:@"YYYY-MM-dd"];
                            NSTimeZone* timeZone = [NSTimeZone localTimeZone];
                            [formatter setTimeZone:timeZone];
                            NSDate* date = [formatter dateFromString:couponDic[@"expired_time"]];// 结束时间
                            // 临时时间
                            if (tempTime == nil) {
                                tempTime = date;
                                defaultCouponCashDic = couponDic; // 优惠券
                            }else
                            {
                                // 对比时间
                                NSDate *compDate = [tempTime earlierDate:date];
                                
                                if ([compDate isEqualToDate:date]) {
                                    if (defaultCouponCashDic) {
                                        defaultCouponCashDic = nil;
                                    }
                                    tempTime = date;
                                    defaultCouponCashDic = couponDic; // 优惠券
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                }
            }else
            {
                [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
            }
        }
        
        [self upData]; // 更新数据
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取优惠券失败"];
    }];
}



// 获取数据
- (void)fetchData
{
    [SVProgressHUD show];
    mainScrollView.userInteractionEnabled = NO;
    [NetworkHelper postWithAPI:API_Washinfo parameter:@{@"uid":userObj.uid} successBlock:^(id response) {
        [SVProgressHUD dismiss];
          mainScrollView.userInteractionEnabled = YES;
        NSDictionary *responseDic = response;
        if (responseDic!= nil) {
            NSDictionary *resultDic = responseDic[@"result"];
            if (responseDic != nil) {
                self.washArray = resultDic[@"washinfo"];
                [self fetchCoupons];
            }
        }
//        [self upData];
   
    } failBlock:^(NSError *error) {
         mainScrollView.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:@"获取洗车方式网络错误"];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}



#pragma mark ViewDelegate


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

//txtview的提示内容展示
- (void)textViewDidChange:(UITextView *)textView {
    if (txtView.text.length==0){//textview长度为0
        if ([textView.text isEqualToString:@""]) {//判断是否为删除键
            labtxtviewpl.hidden=NO;//隐藏文字
        }else{
            labtxtviewpl.hidden=YES;
        }
    }else{//textview长度不为0
        if (txtView.text.length==1){//textview长度为1时候
            if ([textView.text isEqualToString:@""]) {//判断是否为删除键
                labtxtviewpl.hidden=NO;
            }else{//不是删除
                labtxtviewpl.hidden=YES;
            }
        }else{//长度不为1时候
            labtxtviewpl.hidden=YES;
        }
    }
    [self contentSizeToFit];
    labtxtviewpl.center = CGPointMake(txtView.frame.size.width * 0.5, 15);
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    labtxtviewpl.text = @"";
    control.userInteractionEnabled = YES;
    
    
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:facialFiled]) {
       
        DIYSelectTableViewController *DIY = [[DIYSelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//        FaicalSelectTableViewController *DIY = [[FaicalSelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        DIY.washType = selectWashCar;
        DIY.selectCarType = selectCarType;
        DIY.selectDIYDic = self.diyDic;
        
        WS(weakself)
        DIY.diyServers = ^(NSDictionary *diydic){
            weakself.diyDic = diydic;
            facialFiled.text = @"已选择";
            facialSelectTotalPrice =  [diydic[@"price"] floatValue];
            [self setCouponsPrice]; //  设置优惠券价格
//            allPrice = facialSelectTotalPrice+washSelectPrice-couponPrice;
//            [priceTotelContentLabel setText:[NSString stringWithFormat:@"¥:  %.2f",allPrice]];
//            [facialPriceLabel setText:[NSString stringWithFormat:@"%.2f",facialSelectTotalPrice]];
        };
        
        
        
       
        
        [self.navigationController pushViewController:DIY animated:YES];
        return NO;
    }
    return YES;
}

#pragma mark  ui

- (void)userInfoUI
{
    // 用户信息视图
    userView = [UIView new];
    userView.backgroundColor=[UIColor whiteColor];
    //    userView.layer.cornerRadius = 3.0;
    userView.layer.borderWidth=0.5;
    userView.layer.borderColor=kUIColorFromRGB(0xd9d9d9).CGColor;
    [mainScrollView addSubview:userView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        //        make.edges.equalTo(self.view);
        make.height.mas_equalTo(309);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(mainScrollView.mas_top).mas_offset(20);
    }];
    
    [self carMessageUI]; // 车信息
    [self addressUI];    // 地址
    [self timeSelect];   // 时间
    [self washCarPro];   // 洗车项目
    
    [self facialUI];     // 美容选择
    [self addWashPriceLabel]; // 添加洗车价格label
    [self couponUI];     //优惠券
    [self totalPriceUI]; // 总价
    
    
}

- (void)initView{
    
    
    
    bottomView = [UIView new];
    bottomView.backgroundColor=[UIColor whiteColor];
    //    bottomView.layer.cornerRadius = 3.0;
    bottomView.layer.borderWidth=0.5;
    bottomView.layer.borderColor=kUIColorFromRGB(0xd9d9d9).CGColor;
    [mainScrollView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(mainScrollView);
        make.height.mas_equalTo(330);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(userView.mas_bottomMargin).mas_offset(20);
    }];
    
    UILabel *labTishi=[[UILabel alloc] init];
    labTishi.text=@"详细停车位置";
    [labTishi setFont:[UIFont systemFontOfSize:14]];
    labTishi.textColor=kUIColorFromRGB(0x5c5c5c);
    [bottomView addSubview:labTishi];
    [labTishi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_top).mas_offset(20);
        make.left.mas_equalTo(bottomView.mas_left).mas_offset(10);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *labTishiDetail=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 210, 15)];
    labTishiDetail.text=@"简单说明您爱车的位置，每次预约更轻松";
    labTishiDetail.font=[UIFont systemFontOfSize:10];
    labTishiDetail.textColor=kUIColorFromRGB(0xa3a3a3);
    [bottomView addSubview:labTishiDetail];
    [labTishiDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labTishi.mas_bottomMargin).mas_offset(5);
        make.left.mas_equalTo(bottomView.mas_left).mas_offset(10);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(20);
    }];
    
    imgHome =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bottomView.bounds)-100, 20, 40, 40)];
    imgHome.image=[UIImage imageNamed:@"xbb_803"];
    imgHome.userInteractionEnabled = YES;
    [bottomView addSubview:imgHome];
    [imgHome addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeOnTouch:)]];
    [imgHome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_top).mas_offset(20);
        make.right.mas_equalTo(mainScrollView.bounds.size.width).mas_offset(-60);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    
    imgCompany =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bottomView.bounds)-50, 20, 40, 40)];
    imgCompany.image=[UIImage imageNamed:@"xbb_805"];
    imgCompany.userInteractionEnabled = YES;
    [bottomView addSubview:imgCompany];
    [imgCompany addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyOnTouch:)]];
    
    [imgCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_top).mas_offset(20);
        make.right.mas_equalTo(mainScrollView.bounds.size.width).mas_offset(-15);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    
    
    
    
    txtView=[[UITextView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bottomView.bounds)/2-100, 80, 200, 200)];
    txtView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    txtView.delegate=self;
    txtView.keyboardType=UIKeyboardTypeDefault;
    txtView.font = [UIFont systemFontOfSize:14];
    
    labtxtviewpl=[[UILabel alloc] initWithFrame:CGRectMake(15, 90, 170, 20)];
    labtxtviewpl.text=@"请输入车辆所停位置";
    labtxtviewpl.textAlignment = NSTextAlignmentCenter;
    labtxtviewpl.textColor=kUIColorFromRGB(0xc6c6c6);
    [txtView addSubview:labtxtviewpl];
    
    
    
    
    
    if (txtView.text.length) {
        labtxtviewpl.hidden = YES;
    }
    
    [bottomView addSubview:txtView];
    [txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labTishiDetail.mas_bottomMargin).mas_offset(20);
        make.centerX.mas_equalTo(bottomView);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(200);
    }];
    
    [labtxtviewpl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(txtView);
        make.width.mas_equalTo(txtView.bounds.size.width);
        make.height.mas_equalTo(30);
    }];
    
    
    
    
    
    viewVoids = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bottomView.bounds)/2-100, 80, 200, 200)];
    //    viewVoids.backgroundColor = [UIColor redColor];
    
    
    
    UIButton *btnVoid= [[UIButton alloc] initWithFrame:CGRectMake(50, 35, 100, 100)];
    btnVoid.userInteractionEnabled = YES;
    //btnVoid.backgroundColor=[UIColor blueColor];
    [btnVoid setBackgroundImage:[UIImage imageNamed:@"mc1.png"] forState:UIControlStateNormal];
    [btnVoid addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    [btnVoid addTarget:self action:@selector(btnUp:) forControlEvents:UIControlEventTouchUpInside];
    
    btnsound=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnVoid.frame) - 25, btnVoid.frame.origin.y + 10, 39, 24)];
    [btnsound setBackgroundImage:[UIImage imageNamed:@"sounds1.png"] forState:UIControlStateNormal];
    btnsound.hidden=YES;
    btnsound.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnsound setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [btnsound addTarget:self action:@selector(bofang) forControlEvents:UIControlEventTouchUpInside];
    
    [viewVoids addSubview:btnVoid];
    

    [viewVoids addSubview:imgVoids];
    [viewVoids addSubview:btnsound];
    
    UILabel *labAn=[[UILabel alloc] initWithFrame:CGRectMake(0, 150, 200, 20)];
    labAn.textAlignment=NSTextAlignmentCenter;
    labAn.textColor=kUIColorFromRGB(0x00977c);
    labAn.text=@"按住添加语音";
    [viewVoids addSubview:labAn];
    viewVoids.hidden=YES;
    [bottomView addSubview:viewVoids];
    [viewVoids mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labTishiDetail.mas_bottomMargin).mas_offset(10);
        make.centerX.mas_equalTo(bottomView);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(200);
    }];
    
    UIImageView *imgChangeView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bottomView.bounds)/2+110, 160, 50, 50)];
    imgChangeView.image=[UIImage imageNamed:@"change.png"];
    imgChangeView.userInteractionEnabled=YES;
    UITapGestureRecognizer *changetap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeWay)];
    [imgChangeView addGestureRecognizer:changetap];
    [bottomView addSubview:imgChangeView];
    
    [imgChangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(txtView);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(bottomView.mas_rightMargin).mas_offset(-10);
    }];
    
    
    
    UILabel *labtishi2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bottomView.bounds)/2-100, 290, 200, 20)];
    labtishi2.textAlignment=NSTextAlignmentCenter;
    labtishi2.text=@"尽量完善，如果您知道";
    labtishi2.textColor=kUIColorFromRGB(0x5c5c5c);
    [bottomView addSubview:labtishi2];
    [labtishi2 setFont:[UIFont systemFontOfSize:14]];
    
    [labtishi2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(txtView);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(txtView.mas_bottomMargin).mas_offset(20);
        //        make.right.mas_equalTo(bottomView.mas_rightMargin).mas_offset(-10);
    }];
    
    
    UILabel *labtishi2detail=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bottomView.bounds)/2-150, 310, 310, 20)];
    labtishi2detail.textAlignment=NSTextAlignmentCenter;
    labtishi2detail.textColor=kUIColorFromRGB(0xa3a3a3);
    labtishi2detail.font=[UIFont fontWithName:nil size:10];
    labtishi2detail.text=@"参考：绿水康城 二栋1单元 负二楼c348车位";
    [bottomView addSubview:labtishi2detail];
    
    [labtishi2detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(txtView);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(labtishi2.mas_bottomMargin).mas_offset(5);
        
    }];
    
    UIButton *submitButton = [[UIButton alloc] init];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    submitButton.layer.cornerRadius = 3;
    [submitButton setBackgroundColor:[UIColor colorWithRed:253/255. green:122/255. blue:10/255. alpha:1]];
    //    submitButton.backgroundColor = kUIColorFromRGB(0xc8141c);//[UIColor colorWithRed:123/255. green:209./255. blue:99./255. alpha:1.];
    [mainScrollView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(mainScrollView.bounds.size.width);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(bottomView.mas_bottom).mas_offset(30);
        
    }];
    [mainScrollView setContentSize:CGSizeMake(0, 800)];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self fetchStartStopTime];
    [self initData]; //  初始化数据
    [self initNavi]; // 初始化navigationBar
    [self initUI]; // 初始化ui
    [self fetchCarUserInfo];
    
    [self fetchData]; // 获取数据
    
    // 初始化优惠券
    if (self.selectCouponWashDic) {
        [self setCouponsPrice];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keBoardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
  
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
   
}

// 键盘事件
- (IBAction)keBoardFrameChange:(id)sender
{
    NSNotification *doc = sender;
    NSDictionary *dic = doc.userInfo;
    CGRect rectStart = [dic[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect rectStop = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGFloat height = rectStart.origin.y - rectStop.origin.y;
    
    [UIView animateKeyframesWithDuration:0.25 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y -= height;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

// 初始化
- (void)initUI
{
    [self initPlainView];
    [self userInfoUI];
    [self initView];
    [self setControlUI]; // 设置
}



- (void)setControlUI
{
    control = [[UIControl alloc] initWithFrame:mainScrollView.bounds];
    [mainScrollView addSubview:control];
    [control addTarget:self action:@selector(toHide:) forControlEvents:UIControlEventTouchUpInside];
    control.userInteractionEnabled = NO;
}
- (IBAction)toHide:(id)sender
{
    [txtView resignFirstResponder];
    control.userInteractionEnabled = NO;
}



- (void)initNavi
{
    //导航栏中间
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    UILabel *labtitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 11, 100, 22)];
    labtitle.textColor=[UIColor whiteColor];
    labtitle.textAlignment=NSTextAlignmentCenter;
    labtitle.text= @"增加订单";
    labtitle.font = TITLEFONT;
    [titleView addSubview:labtitle];
    self.navigationItem.titleView=titleView;
    // Do any additional setup after loading the view.
    self.view.backgroundColor=kUIColorFromRGB(0xf4f4f4);
    
    //返回
    UIImageView * img_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_back.png"]];
    img_view.layer.masksToBounds=YES;
    img_view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [img_view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:img_view];
}
- (void)initPlainView
{

    
    mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mainScrollView];
    mainScrollView.backgroundColor =  [UIColor clearColor];//kUIColorFromRGB(0xf6f5fa);
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
//        make.width.mas_equalTo(self.view.bounds.size.width);
//        make.height.mas_equalTo(self.view.bounds.size.height);
//        make.center.mas_equalTo(self.view);
    }];
    [mainScrollView setContentOffset:CGPointMake(0, -64)];

}



- (void)addressUI
{
    // 地址信息标题
    addressTitleLabel = [[XBBListHeadLabel alloc] init];
    addressTitleLabel.text = @"地址信息 :";
    
    [userView addSubview:addressTitleLabel];
    [addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(lineView.mas_top);
        make.left.mas_equalTo(20);
    }];
    
    // 地址信息内容
     addressMessageLabel = [[XBBListContentLabel alloc] init];
    
    addressMessageLabel.text = userObj.currentAddress?userObj.currentAddress:@"";
    [userView addSubview:addressMessageLabel];
    
//    addressMessageLabel.backgroundColor = [UIColor redColor];

    [addressMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(self.view.bounds.size.width - 100 - 30);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(lineView.mas_top);
        make.left.mas_equalTo(addressTitleLabel.mas_rightMargin).mas_offset(20);
    }];
    
    // 线
    lineView_1 = [[UIView alloc] init];
    lineView_1.backgroundColor = kUIColorFromRGB(0xd9d9d9);
    [userView addSubview:lineView_1];
    [lineView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(userView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(addressTitleLabel.mas_bottom);
        make.left.mas_equalTo(userView.mas_left);
    }];

    

}


- (void)timeSelect
{
    
    // 时间信息标题
     timeTitleLabel = [[XBBListHeadLabel alloc] init];
    timeTitleLabel.text = @"方式选择 :";
    
    [userView addSubview:timeTitleLabel];
    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(lineView_1.mas_top);
        make.left.mas_equalTo(20);
    }];
    
    
    // 即刻上门时间选择信息内容
     justLabel = [[XBBListContentLabel alloc] init];
    justLabel.text = @"即刻上门";
    [userView addSubview:justLabel];
    [justLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(lineView_1.mas_top);
        make.left.mas_equalTo(timeTitleLabel.mas_right).mas_offset(10);
    }];
    
    
    UIImage *image = [UIImage imageNamed:@"xbb_168"];//172
     selectWayButtonOne = [[UIButton alloc] init];
    [selectWayButtonOne setImage:image forState:UIControlStateNormal];
    [userView addSubview:selectWayButtonOne];
    [selectWayButtonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
        make.left.mas_equalTo(justLabel.mas_rightMargin).mas_offset(10);
        make.centerY.mas_equalTo(justLabel);
    }];
    
    
    
    
    // 预约
     planLabel = [[XBBListContentLabel alloc] init];
    planLabel.text = @"预约上门";
    [userView addSubview:planLabel];
    [planLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(timeTitleLabel);
        make.left.mas_equalTo(selectWayButtonOne.mas_rightMargin).mas_offset(30);
    }];
    
    
    
    UIImage *image_1 = [UIImage imageNamed:@"xbb_172"];//172
     selectWayButtonTWO = [[UIButton alloc] init];
    [selectWayButtonTWO setImage:image_1 forState:UIControlStateNormal];
    [userView addSubview:selectWayButtonTWO];
    [selectWayButtonTWO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
        make.left.mas_equalTo(planLabel.mas_rightMargin).mas_offset(10);
        make.centerY.mas_equalTo(justLabel);
    }];
    
    
    // 线
    lineView_2 = [[UIView alloc] init];
    lineView_2.backgroundColor = kUIColorFromRGB(0xd9d9d9);
    [userView addSubview:lineView_2];
    [lineView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(userView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(timeTitleLabel.mas_bottom);
        make.left.mas_equalTo(userView.mas_left);
    }];
    selectWayButtonTWO.tag = 2;
    selectWayButtonOne.tag = 1;
    
    [selectWayButtonOne addTarget:self action:@selector(selectWay:) forControlEvents:UIControlEventTouchUpInside];
    [selectWayButtonTWO addTarget:self action:@selector(selectWay:) forControlEvents:UIControlEventTouchUpInside];
    
    UIControl *control_1 = [[UIControl alloc] init];
    [userView addSubview:control_1];
    control_1.tag = 1;
    [control_1 addTarget:self action:@selector(selectWay:) forControlEvents:UIControlEventTouchUpInside];
    UIControl *control_2 = [[UIControl alloc] init];
    [userView addSubview:control_2];
    control_2.tag = 2;
    //    control_1.backgroundColor = [UIColor redColor];
    [control_2 addTarget:self action:@selector(selectWay:) forControlEvents:UIControlEventTouchUpInside];
    [control_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(timeTitleLabel.mas_rightMargin).mas_offset(10);
        make.centerY.mas_equalTo(timeTitleLabel);
    }];
    //     control_2.backgroundColor = [UIColor redColor];
    [control_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(userView.mas_rightMargin).mas_offset(-10);
        make.centerY.mas_equalTo(timeTitleLabel);
    }];
    

}

// 选择时间
- (IBAction)selectWay:(UIButton *)sender
{
    DLog(@"");
    
    if (sender.tag != selectTimeWay) {
        selectTimeWay = sender.tag;
    }
    if (selectTimeWay == 2) {
        [selectWayButtonOne setImage:[UIImage imageNamed:@"xbb_172"] forState:UIControlStateNormal];
        [selectWayButtonTWO setImage:[UIImage imageNamed:@"xbb_168"] forState:UIControlStateNormal];
        
        AddPlanOrderViewController *plan = [[AddPlanOrderViewController alloc] init];
//        plan.timePlan = [self.planTime copy];
        WS(weakself)
        plan.planTime = ^(NSString *planTime) {
            weakself.planTime = planTime;
            // 小于0
            if (planTime == nil) {
                [selectWayButtonOne setImage:[UIImage imageNamed:@"xbb_168"] forState:UIControlStateNormal];
                [selectWayButtonTWO setImage:[UIImage imageNamed:@"xbb_172"] forState:UIControlStateNormal];
                selectTimeWay = 1;
                [planLabel setText:@"预约上门"];
                [planLabel setFont:[UIFont systemFontOfSize:14.]];
                
            }else
            {
                [planLabel setText:planTime];
                [planLabel setFont:[UIFont systemFontOfSize:10.]];
                [planLabel setNumberOfLines:2];
            }
        };
        [self.navigationController pushViewController:plan animated:YES];
        
        
    }else
    {
        [planLabel setText:@"预约上门"];
        [planLabel setFont:[UIFont systemFontOfSize:14.]];
        [selectWayButtonOne setImage:[UIImage imageNamed:@"xbb_168"] forState:UIControlStateNormal];
        [selectWayButtonTWO setImage:[UIImage imageNamed:@"xbb_172"] forState:UIControlStateNormal];
    }
    
    
    
}

- (void)washCarPro
{
    // 时间信息标题
    washTitleLabel = [[XBBListHeadLabel alloc] init];
    washTitleLabel.text = @"洗车选择 :";
    
    [userView addSubview:washTitleLabel];
    [washTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(lineView_2.mas_top);
        make.left.mas_equalTo(20);
    }];
    
    

    
    // 外观清洗选择信息内容
     waiguanLabel = [[XBBListContentLabel alloc] init];
    waiguanLabel.tag = 11;
     waiguanLabel.text = @"外观清洗";
    waiguanLabel.userInteractionEnabled = YES;
    // 标志一
    UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectWashWay:)];
    [waiguanLabel addGestureRecognizer:tap_1];
    
    
    
    [userView addSubview: waiguanLabel];
    [waiguanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(washTitleLabel.mas_centerY);
        make.left.mas_equalTo(timeTitleLabel.mas_right).mas_offset(10);
    }];
//
    
    UIImage *image = [UIImage imageNamed:@"xbb_168"];//172
     washSelectButtonOne = [[UIButton alloc] init];
    [washSelectButtonOne setImage:image forState:UIControlStateNormal];
    [userView addSubview:washSelectButtonOne];
    [washSelectButtonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
        make.left.mas_equalTo(waiguanLabel.mas_rightMargin).mas_offset(10);
        make.centerY.mas_equalTo(washTitleLabel);
    }];
    
    // 预约
    allWashLabel= [[XBBListContentLabel alloc] init];
    allWashLabel.tag = 22;
    allWashLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectWashWay:)];
    [allWashLabel addGestureRecognizer:tap_2];
    
    allWashLabel.text = @"整车清洗";
    [userView addSubview:allWashLabel];
    [allWashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(lineView_2.mas_top);
        make.left.mas_equalTo(selectWayButtonOne.mas_rightMargin).mas_offset(30);
    }];
    
    
    
    UIImage *image_1 = [UIImage imageNamed:@"xbb_172"];//172
     washSelectButtonTWO = [[UIButton alloc] init];
    [washSelectButtonTWO setImage:image_1 forState:UIControlStateNormal];
    [userView addSubview:washSelectButtonTWO];
    [washSelectButtonTWO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
        make.left.mas_equalTo(allWashLabel.mas_rightMargin).mas_offset(10);
        make.centerY.mas_equalTo(washTitleLabel);
    }];
    
    
    // 线
    lineView_3 = [[UIView alloc] init];
    lineView_3.backgroundColor = kUIColorFromRGB(0xd9d9d9);
    [userView addSubview:lineView_3];
    [lineView_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(userView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(washTitleLabel.mas_bottom);
        make.left.mas_equalTo(userView.mas_left);
    }];
    
    washSelectButtonOne.tag = 11;
    washSelectButtonTWO.tag = 22;

    [washSelectButtonOne addTarget:self action:@selector(selectWashWay:) forControlEvents:UIControlEventTouchUpInside];
    [washSelectButtonTWO addTarget:self action:@selector(selectWashWay:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)selectWashWay:(id)sendero
{
   
    UIView *sender = nil;
    if ([sendero isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sendero;
        sender = tap.view;
    }else
    {
        sender = sendero;
    }
    
    if (sender.tag != selectWashCar) {
        
        selectWashCar = sender.tag;
        
        if (selectWashCar == 22) {
            
            
            DLog(@"222222222");
            [washSelectButtonOne setImage:[UIImage imageNamed:@"xbb_172"] forState:UIControlStateNormal];
            [washSelectButtonTWO setImage:[UIImage imageNamed:@"xbb_168"] forState:UIControlStateNormal];
        }else
        {
            [washSelectButtonOne setImage:[UIImage imageNamed:@"xbb_168"] forState:UIControlStateNormal];
            [washSelectButtonTWO setImage:[UIImage imageNamed:@"xbb_172"] forState:UIControlStateNormal];
        }

        
    }else if((sender.tag == selectWashCar && [sender isEqual:washSelectButtonOne])||(sender.tag == selectWashCar && sender.tag == washSelectButtonOne.tag)) {
        selectWashCar = 0;
         [washSelectButtonOne setImage:[UIImage imageNamed:@"xbb_172"] forState:UIControlStateNormal];
        DLog(@"======")
    } else if ((sender.tag == selectWashCar && [sender isEqual:washSelectButtonTWO])||(sender.tag == selectWashCar && sender.tag == washSelectButtonTWO.tag)) {
         selectWashCar = 0;
         [washSelectButtonTWO setImage:[UIImage imageNamed:@"xbb_172"] forState:UIControlStateNormal];
    }
    
#pragma mark 洗车价格调整
    

    
    switch (selectWashCar) {
        case 0:
        {
            washSelectPrice = 0;
            washSelectCombo = nil;
        }
            break;
        case 11:
        {
            washSelectPrice = appearancePrice;
            
            for (NSDictionary *dic in self.washArray) {
                if ([dic[@"id"] integerValue] == 1) {
                    washSelectCombo = dic;
                }
            }
        }
            
            break;
        case 22:
        {
            washSelectPrice = fullCarPrice;
            for (NSDictionary *dic in self.washArray) {
                if ([dic[@"id"] integerValue] == 2) {
                    washSelectCombo = dic;
                    
                }
            }
        }
            
            break;
        default:
            break;
    }
    
    [self setCouponsPrice]; //  设置优惠券价格
    
//    [washPriceLabel setText:[NSString stringWithFormat: @"%.2f",washSelectPrice]];
//    allPrice = facialSelectTotalPrice+washSelectPrice-couponPrice;
//    [priceTotelContentLabel setText:[NSString stringWithFormat:@"¥:  %.2f",allPrice]];

}
- (void)facialUI
{
    // 美容选择
    facialTitleLabel= [[XBBListHeadLabel alloc] init];
    facialTitleLabel.text = @"美容选择 :";
    
    [facialTitleLabel adjustsFontSizeToFitWidth];
    [userView addSubview:facialTitleLabel];
    [facialTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(lineView_3.mas_top);
        make.left.mas_equalTo(20);
    }];
    
    
    facialFiled = [[UITextField alloc] init];
    facialFiled.delegate = self;
    [userView addSubview:facialFiled];
    facialFiled.text = @"美容选择";
    facialFiled.font = [UIFont systemFontOfSize:14];
    facialFiled.textColor = [UIColor grayColor];
    [facialFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(facialTitleLabel);
        make.left.mas_equalTo(carTitleLabel.mas_rightMargin).mas_offset(20);
    }];
    
    
    UIImage *image = [UIImage imageNamed:@"xbb_141"];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageV.image = image;
    [userView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(mainScrollView.bounds.size.width).mas_offset(-image.size.width * 2);
        make.centerY.mas_equalTo(facialFiled);
    }];
    
    
    facialPriceLabel = [[XBBListContentLabel alloc] init];
    [facialPriceLabel setTextColor:[UIColor colorWithRed:253/255. green:122/255. blue:10/255. alpha:1]];
    facialPriceLabel.text = @"0.00";
    [facialPriceLabel setTextAlignment:NSTextAlignmentRight];
    facialPriceLabel.backgroundColor = [UIColor clearColor];
    [userView addSubview:facialPriceLabel];
    [facialPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(imageV);
        make.right.mas_equalTo(imageV.mas_leftMargin).mas_offset(-20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    

}

- (void)couponUI
{
    
    
    lineView_4 = [[UIView alloc] init];
    lineView_4.backgroundColor = kUIColorFromRGB(0xd9d9d9);
    [userView addSubview:lineView_4];
    [lineView_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(userView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(facialTitleLabel.mas_bottom);
        make.left.mas_equalTo(userView.mas_left);
    }];

    couponTitle = [[XBBListHeadLabel alloc] init];
    [couponTitle setText:@"优惠券 :"];
    [userView addSubview:couponTitle];
    [couponTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(lineView_4);
    }];
    
    couponContentLabel = [[XBBListContentLabel alloc] init];
    couponContentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toCouponsViewControllerAction:)];
    [couponContentLabel addGestureRecognizer:tap];
    [couponContentLabel setText:@"暂无优惠券"];
    [userView addSubview:couponContentLabel];
    [couponContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(couponTitle);
        make.left.mas_equalTo(couponTitle.mas_rightMargin).mas_offset(20);
    }];
    
    
    couponPriceLabel = [[XBBListContentLabel alloc] init];
    [couponPriceLabel setTextAlignment:NSTextAlignmentRight];
    [couponPriceLabel setTextColor:[UIColor colorWithRed:253/255. green:122/255. blue:10/255. alpha:1]];
    [couponPriceLabel setBackgroundColor:[UIColor clearColor]];
    [couponPriceLabel setText:@"0.00"];
    [userView addSubview:couponPriceLabel];
    [couponPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(facialPriceLabel);
        make.centerY.mas_equalTo(couponContentLabel);
        make.width.mas_equalTo(facialPriceLabel);
        make.height.mas_equalTo(facialPriceLabel);
    }];
    
    
    
    
    lineView_5 = [[UIView alloc] init];
    lineView_5.backgroundColor = kUIColorFromRGB(0xd9d9d9);
    [userView addSubview:lineView_5];
    [lineView_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(userView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(couponTitle.mas_bottom);
        make.left.mas_equalTo(userView.mas_left);
    }];
    
    
    
}

- (void)addWashPriceLabel
{
    washPriceLabel = [[XBBListContentLabel alloc] init];
    [washPriceLabel setTextAlignment:NSTextAlignmentRight];
    [washPriceLabel setTextColor:[UIColor colorWithRed:253/255. green:122/255. blue:10/255. alpha:1]];
    [washPriceLabel setBackgroundColor:[UIColor clearColor]];
    [washPriceLabel setText:@"0.00"];
//    DLog(@"%@",[[UIDevice currentDevice] model]);
//    DLog(@"%f",[[UIScreen mainScreen]bounds].size.height);
    if ([[UIScreen mainScreen]bounds].size.height > 568.0 ) {
        [userView addSubview:washPriceLabel];
        [washPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(facialPriceLabel);
            make.centerY.mas_equalTo(waiguanLabel);
            make.width.mas_equalTo(facialPriceLabel);
            make.height.mas_equalTo(facialPriceLabel);
        }];
    }
}


- (void)totalPriceUI
{
    priceTotalTitle = [[XBBListHeadLabel alloc] init];
    [priceTotalTitle setText:@"总金额 :"];
    [userView addSubview:priceTotalTitle];
    [priceTotalTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(lineView_5);
    }];
    
    priceTotelContentLabel = [[XBBListContentLabel alloc] init];
    [priceTotelContentLabel setFont:[UIFont systemFontOfSize:20]];
    [priceTotelContentLabel setTextColor:[UIColor redColor]];
    switch (selectCarType) {
        case 1:
            
            break;
            
        default:
            break;
    }
    
    [priceTotelContentLabel setText:@"¥:  0.00"];
    
    
    
    
    [userView addSubview:priceTotelContentLabel];
    [priceTotelContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(priceTotalTitle);
        make.left.mas_equalTo(priceTotalTitle.mas_rightMargin).mas_offset(20);
    }];
}






//#pragma mark 查看订单信息
//- (void)checkOrderInfo{
//    NSLog(@"查看订单信息");
//    CheckOnderViewController *checkorderVC = [[CheckOnderViewController alloc] init];
//    checkorderVC.p_ids = self.p_id;
//    checkorderVC.order_location = self.location;
//    checkorderVC.c_id = self.c_id;
//    checkorderVC.uid = [UserObj shareInstance].uid;
//    [self.navigationController pushViewController:checkorderVC animated:YES];
//}
//
////即刻添加订单
//- (void)addOrderjike{
//    if (!self.location_lg.length || !self.location_lt.length) {
//        [SVProgressHUD showErrorWithStatus:@"未获取到您的位置"];
//        return;
//    }
//    NSData *data=[[NSData alloc] initWithContentsOfURL:urlPlay];
//    NSLog(@"data   ===  %@",data);
//    NSMutableDictionary *dicOrder=[NSMutableDictionary dictionary];
//    [dicOrder setObject:[UserObj shareInstance].uid forKey:@"uid"];
//    [dicOrder setObject:self.location?self.location:@"" forKey:@"location"];
//    [dicOrder setObject:self.location_lg forKey:@"location_lg"];
//    [dicOrder setObject:self.location_lt forKey:@"location_lt"];
//    [dicOrder setObject:txtView.text?txtView.text:@"" forKey:@"remark"];
//    [dicOrder setObject:self.p_id forKey:@"p_ids"];
////    [dicOrder setObject:[self.total_price substringFromIndex:1] forKey:@"total_price"];
//    [dicOrder setObject:self.c_id forKey:@"c_ids"];
////    NSLog(@"dicorder%@",dicOrder);
//    
//    
//    
//    PayTableViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayTableViewController"];
//    viewController.data = data;
//    viewController.dic = [dicOrder copy];
//    [self.navigationController pushViewController:viewController animated:YES];
//    
//
//
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark adjust

- (void)contentSizeToFit {
    if([txtView.text length]>0) {
        CGSize contentSize = txtView.contentSize;
        //NSLog(@"w:%f h%f",contentSize.width,contentSize.height);
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        if(contentSize.height <= txtView.frame.size.height) {
            CGFloat offsetY = (txtView.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
        else {
            newSize = txtView.frame.size;
            offset = UIEdgeInsetsZero;
            CGFloat fontSize = 18;
            while (contentSize.height > txtView.frame.size.height) {
                [txtView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                contentSize = txtView.contentSize;
            }
            newSize = contentSize;
        }
        [txtView setContentSize:newSize];
        [txtView setContentInset:offset];
    }
}

- (float) fileSizeAtPath:(NSString*) filePath{
    
    AVURLAsset* audioAsset =[AVURLAsset  URLAssetWithURL:[NSURL URLWithString:filePath] options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}


#pragma mark audion


- (IBAction)btnDown:(id)sender
{
    [self audio];
    //创建录音文件，准备录音
    if ([recorder prepareToRecord]) {
        //开始
        [recorder record];
    }
    NSLog(@"录音开始");
    btnsound.hidden=YES;
    
}
- (IBAction)btnUp:(id)sender
{
    double cTime = recorder.currentTime;
    if (cTime > 1) {//如果录制时间<2 不发送
        NSLog(@"发出去%@",urlPlay);
        btnsound.hidden = NO;
        AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:urlPlay options:nil];
        CMTime audioDuration = audioAsset.duration;
        float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
        [btnsound setTitle:[NSString stringWithFormat:@"%d", (int)ceil(audioDurationSeconds)] forState:UIControlStateNormal];
        
    }else {
        //        alertAudio=[CustamViewController createAlertViewTitleStr:@"录音时间太短" withMsg:nil widthDelegate:self withCancelBtn:nil withbtns:nil];
        //        [alertAudio show];
        //         [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1];
        [SVProgressHUD showErrorWithStatus:@"录音时间太短"];
        //删除记录的文件
        [recorder deleteRecording];
        //删除存储的
    }
    [recorder stop];
    
}

//播放音频
- (void)bofang{
    
    if (self.avPlay.playing) {
        [self.avPlay stop];
        return;
    }
    
    NSLog(@"播放url%@",urlPlay);
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlPlay error:nil];
    self.avPlay = player;
    
    [self.avPlay play];
}


//创建录音文件
- (void)audio
{
    NSError *error;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    //Setup the audioSession for playback and record.
    //We could just use record and then switch it to playback leter, but
    //since we are going to do both lets set it up once.
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    //Activate the session
    [audioSession setActive:YES error: &error];
    
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HHmmss"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"time%@",locationString);
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/remark.aac", strUrl]];
    urlPlay = url;
    NSLog(@"urlplay%@",urlPlay);
    NSError *serror;
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&serror];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}

#pragma mark actions

- (IBAction)toCouponsViewControllerAction:(id)sender
{
    MyCouponsViewController *vc = [[MyCouponsViewController alloc] init];
    vc.couponsBlock = ^(NSDictionary *couponDic){
        if (_selectCouponWashDic) {
            _selectCouponWashDic = nil;
        }
        _selectCouponWashDic = couponDic;
        [self setCouponsPrice];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)changeWay{
    if (!txtView.hidden) {
        txtView.hidden=YES;
        viewVoids.hidden=NO;
    }else{
        txtView.hidden=NO;
        viewVoids.hidden=YES;
    }
}

- (void)scrolltap{
    [txtView resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [txtView resignFirstResponder];
}


#pragma mark 时间判断


// 时间限制
- (BOOL)isBusinessTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSArray *arr = [currentDateStr componentsSeparatedByString:@":"];
    int modelH = [arr[0] intValue];
    int modelM = [arr[1] intValue];
    
    NSArray *startTime = [startReminderTime componentsSeparatedByString:@":"];
    NSArray *endTime = [endReminderTime componentsSeparatedByString:@":"];
    
    int startTimeHH = [startTime[0] intValue];
    int endTimeHH = [endTime[0]intValue];
    int startTimeMM = [startTime[1]intValue];
    int endTimeMM = [endTime[1]intValue];
    if (modelH >= startTimeHH && modelH <= endTimeHH) {
        if ((modelH == startTimeHH && modelM < startTimeMM)||(endTimeHH == modelH && modelM > endTimeMM)) {
            return NO;
        }
        return YES;
    }
    return NO;
}


- (IBAction)submitOrder:(id)sender
{
    // 设置默认车辆
    UserObj *user=[UserObj shareInstance];
    if ([user.c_id integerValue]== 0 ||[user.c_id integerValue] == 1 ) {
        UIAlertView *alert = [CustamViewController createAlertViewTitleStr:@"请设置默认车辆" withMsg:nil widthDelegate:self withCancelBtn:@"取消" withbtns:@"去设置"];
        [alert show];
        return;
    }
    
    if (([self.carDic[@"c_type"] integerValue] == 0)||self.carDic== nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的车辆信息不够完整" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去完善", nil];
        alert.tag = 112211;
        [alert show];
        return;
    }
    
    if (selectTimeWay == 1) {
        
        // 超出时间
        if (self.isServerTime == 0) {
            NSString *message = [NSString stringWithFormat:@"请在%@ -- %@之间下单",startReminderTime?startReminderTime:@"9:30",endReminderTime?endReminderTime:@"17:30"];
            UIAlertView *alert = [CustamViewController createAlertViewTitleStr:@"即刻上门下单提示" withMsg:message widthDelegate:self withCancelBtn:@"确定" withbtns:nil];
            [alert show];
            return;
        }
        
    }
    // 洗车数组
    NSMutableArray *p_arr = [NSMutableArray array];
    NSMutableArray *p_ids = [NSMutableArray array];
    
    if (washSelectCombo) {
        [p_arr addObject:washSelectCombo];
        [p_ids addObject:washSelectCombo[@"id"]]; // 添加id
    }
    NSArray *diyArr = _diyDic[@"diy"];
    if (diyArr) {
        for (NSDictionary *diy_dic in diyArr) {
            [p_arr addObject:diy_dic];
            [p_ids addObject:diy_dic[@"id"]];
        }
    }
    NSArray *waxArray = _diyDic[@"wax"];
    if (waxArray) {
        for (NSDictionary *dic_wax in waxArray) {
            [p_ids addObject:dic_wax[@"id"]];
            [p_arr addObject:dic_wax];
        }
    }
    NSArray *noWaxArray = _diyDic[@"noWash"];
    if (noWaxArray) {
        for (NSDictionary *dic_noWash in noWaxArray) {
            [p_arr addObject:dic_noWash];
            [p_ids addObject:dic_noWash[@"id"]];
        }
    }

    // 产品ids
    NSString *p_idss = [p_ids componentsJoinedByString:@","];

    if (self.diyDic) {
        
        
        NSArray *diyComs = self.diyDic[@"diyCom"];
        NSArray *waxs = self.diyDic[@"wax"];
        NSArray *diys = self.diyDic[@"diy"];
        
        
        // 判断
        if (selectWashCar == 0 && (diyComs.count > 0 || waxs.count > 0 || diys.count > 0)) {
            [SVProgressHUD showErrorWithStatus:@"您选择的美容项目有必须洗车项目"];
            return;
        }
    }

    // 位置信息
    if ([self.location length] < 1 || [self.location_lt length] < 1 || [self.location_lg length] < 1) {
        [SVProgressHUD showErrorWithStatus:@"位置获取错误"];
        return;
    }
    
    // 车辆信息
    if (self.carDic == nil) {
        [SVProgressHUD showErrorWithStatus:@"车辆信息获取错误"];
        return;
    }

    
    
    NSMutableDictionary *orderDic = [NSMutableDictionary dictionary];
    [orderDic setObject:[UserObj shareInstance].uid?[UserObj shareInstance].uid:@"" forKey:@"uid"];
    [orderDic setObject:self.location?self.location:@"" forKey:@"location"];
    [orderDic setObject:self.location_lg?self.location_lg:@"" forKey:@"location_lg"];
    [orderDic setObject:self.location_lt?self.location_lt:@"" forKey:@"location_lt"];
    [orderDic setObject:txtView.text?txtView.text:@"" forKey:@"remark"];
    [orderDic setObject:p_idss forKey:@"p_ids"];
    [orderDic setObject:[NSString stringWithFormat:@"%.2f",allPrice]? [NSString stringWithFormat:@"%.2f",allPrice]:@"0"forKey:@"total_price"];
    [orderDic setObject:couponsId?couponsId:@"" forKey:@"coupons_id"];
//    [orderDic setObject:<#(nonnull id)#> forKey:@"order_reg_id"];

    [orderDic setObject:self.planTime?self.planTime:@"" forKey:@"plan_time"];
    [orderDic setObject:self.carDic?self.carDic[@"id"]:@"" forKey:@"c_ids"];
 
    // 支付页面跳转
    PayTableViewController *pay = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayTableViewController"];
    pay.carType = selectCarType; //  选择的车类型
    pay.dic_prama = orderDic; // 字典参数
    pay.pro_Dics = [p_arr copy]; // 数组
    // 录音数据
    NSData *data=[[NSData alloc] initWithContentsOfURL:urlPlay];
    pay.price = allPrice; // 全部的价格
    pay.data = data; // 录音
    pay.carInfo = self.carDic; //
    pay.location = self.location;
    pay.couponprice = couponPrice;
    [self.navigationController pushViewController:pay animated:YES];
}
- (void)dismiss:(id)sender {
    [alertAudio dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)homeOnTouch:(id)sender {
    if ([UserObj shareInstance].homeCoordinate.latitude == 0) {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CarportTableViewController"] animated:YES];
        return;
    }
    
    labtxtviewpl.text = @"";
    if (isHome == NO) {
        [imgHome setImage:[UIImage imageNamed:@"xbb_804"]];
        txtView.text = [UserObj shareInstance].homeDetailAddress;
        [addressMessageLabel setText:[UserObj shareInstance].homeAddress];
        self.location =  [UserObj shareInstance].homeAddress;
        self.location_lt = [NSString stringWithFormat:@"%@", @([UserObj shareInstance].homeCoordinate.latitude)];
        self.location_lg = [NSString stringWithFormat:@"%@", @([UserObj shareInstance].homeCoordinate.longitude)];
        isHome = YES;
    }else
    {
        isHome = NO;
        [imgHome setImage:[UIImage imageNamed:@"xbb_803"]];
        txtView.text = nil;
        [addressMessageLabel setText:[UserObj shareInstance].currentAddress];
        self.location =  [UserObj shareInstance].currentAddress;
        self.location_lt = [NSString stringWithFormat:@"%@", @([UserObj shareInstance].currentCoordinate.latitude)];
        self.location_lg = [NSString stringWithFormat:@"%@", @([UserObj shareInstance].currentCoordinate.longitude)];
    }
    [imgCompany setImage:[UIImage imageNamed:@"xbb_805"]];
    isCompany = NO;
    
  
}

- (void)companyOnTouch:(id)sender {
    if ([UserObj shareInstance].companyCoordinate.latitude == 0) {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CarportTableViewController"] animated:YES];
        return;
    }
    
    labtxtviewpl.text = @"";
    if (isCompany == NO) {
        [imgCompany setImage:[UIImage imageNamed:@"xbb_806"]];
        isCompany = YES;

        txtView.text = [UserObj shareInstance].companyDetailAddress;
        self.location = [UserObj shareInstance].companyAddress;
        [addressMessageLabel setText:[UserObj shareInstance].companyAddress];
        self.location_lt = [NSString stringWithFormat:@"%@", @([UserObj shareInstance].companyCoordinate.latitude)];
        self.location_lg = [NSString stringWithFormat:@"%@", @([UserObj shareInstance].companyCoordinate.longitude)];
        
    }else
    {
        isCompany = NO;
        [imgCompany setImage:[UIImage imageNamed:@"xbb_805"]];
        
        txtView.text = nil;
        [addressMessageLabel setText:[UserObj shareInstance].currentAddress];
        self.location =  [UserObj shareInstance].currentAddress;
        self.location_lt = [NSString stringWithFormat:@"%@", @([UserObj shareInstance].currentCoordinate.latitude)];
        self.location_lg = [NSString stringWithFormat:@"%@", @([UserObj shareInstance].currentCoordinate.longitude)];
    }
    [imgHome setImage:[UIImage imageNamed:@"xbb_803"]];
    isHome = NO;
}



#pragma mark - Animation

- (void)bgImage
{
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bgImageView.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:self.bgImageView];
    
    
}


- (void)startAnimation
{
    // 先创建两个
    [self creatAnimationImageView];
    [self creatAnimationImageView];
    
    //  然后下面的用定时器，随机一个时间添加一个出来
    CGFloat duration = [self getRandomTimeWithMin:1 max:3];
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(creatAnimationImageView) userInfo:nil repeats:YES];
}

// 创建一个imageView，并且开始动画,透明度慢慢变成1,然后随机移动位置 ，然后透明度再变成0，然后移除出视图
- (UIImageView *)creatAnimationImageView
{
    // 得到一个随机图片
    UIImage *image = [self getRandomImage];
    CGPoint point = [self getRandomPoint];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    imageView.center = point;
    imageView.alpha = 0;
    // 将imageView插入到背景图上
    [self.view insertSubview:imageView aboveSubview:self.bgImageView];
    
    // 开始动画
    [UIView animateWithDuration:[self getRandomTimeWithMin:2 max:4] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.alpha = 1.0;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:[self getRandomTimeWithMin:6 max:15] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            imageView.center = [self getRandomPoint];
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:[self getRandomTimeWithMin:2 max:4] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                imageView.alpha = 0;
            }completion:^(BOOL finished) {
                [imageView removeFromSuperview];
            }];
        }];
    }];
    
    return imageView;
}

// 取一个随机的图片
- (UIImage *)getRandomImage
{
    NSInteger index = arc4random()%5 + 1;
    NSString *imageString = [NSString stringWithFormat:@"login_%d", (int)index];
    UIImage *image = [UIImage imageNamed:imageString];
    return image;
}

// 取一个随机的坐标，在视图范围之内
- (CGPoint)getRandomPoint
{
    NSInteger width = self.view.frame.size.width;
    NSInteger height = self.view.frame.size.height;
    CGFloat x = arc4random() % width;
    CGFloat y = arc4random() % height;
    CGPoint point = CGPointMake(x, y);
    return point;
}

// 取一个10到20的随机数
- (NSTimeInterval)getRandomTimeWithMin:(NSInteger)min max:(NSInteger)max
{
    NSTimeInterval time = arc4random() % (max - min) + min;
    return time;
}

#pragma mark  memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
