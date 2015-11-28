//
//  CheckOnderViewController.m
//  XiBaibai
//
//  Created by mazi on 15/9/22.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "CheckOnderViewController.h"
#import "DMLineView.h"

@interface CheckOnderViewController (){
    UIView *viewOrderPay;
    UIScrollView *mainScrollView;
}


@property (strong,nonatomic) UILabel *labTitle;
@property (strong,nonatomic) UILabel *labMoney;
@property (strong,nonatomic) UILabel *labTimeX;
@property (strong,nonatomic) UILabel *labAddressX;
@property (strong,nonatomic) UILabel *labModelX;
@property (strong,nonatomic) UILabel *labUser;
@property (strong,nonatomic) UILabel *labUserPhoneX;

@end

@implementation CheckOnderViewController

- (void)initView{
    self.view.backgroundColor = kUIColorFromRGB(0xf6f5fa);
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"订单确认";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = title;
    //返回
    UIImageView * img_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_back.png"]];
    img_view.layer.masksToBounds=YES;
    img_view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fanhui)];
    [img_view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:img_view];
    
    //    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    mainScrollView = [UIScrollView new];
    mainScrollView.scrollEnabled = YES;
    mainScrollView.backgroundColor = kUIColorFromRGB(0xf6f5fa);
//    mainScrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *viewInfo = [UIView new];
    viewInfo.layer.borderColor = kUIColorFromRGB(0xd9d9d9).CGColor;
    viewInfo.layer.borderWidth = 0.5;
    viewInfo.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    [mainScrollView addSubview:viewInfo];
    [viewInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.equalTo(mainScrollView);
        make.height.mas_equalTo(mainScrollView);
    }];
    
    //    self.orderinfoview = [OrderInfoView initOrderInfoView];
    //    [viewInfo addSubview:self.orderinfoview];
    
    UIView *viewOrderInfo = [UIView new];
    [viewInfo addSubview:viewOrderInfo];
    [viewOrderInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(viewInfo.mas_width);
        make.height.mas_equalTo(155);
        make.top.mas_equalTo(viewInfo.mas_top).mas_offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UIImageView *imgViewtitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_45.png"]];
    [viewOrderInfo addSubview:imgViewtitle];
    [imgViewtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(20);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(30);
        
    }];
    
    self.labTitle = [UILabel new];
    self.labTitle.textColor = kUIColorFromRGB(0x1a1a1a);
    self.labTitle.text = @"上门洗车";
    [viewOrderInfo addSubview:self.labTitle];
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(55);
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(20);
    }];
    
    self.labMoney = [UILabel new];
    self.labMoney.text = @"￥30";
    self.labMoney.textColor = kUIColorFromRGB(0xde3635);
    [viewOrderInfo addSubview:self.labMoney];
    [self.labMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(20);
        make.right.mas_equalTo(viewOrderInfo.mas_right).mas_offset(-20);
    }];
    
    DMLineView *lineView = [[DMLineView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.lineWidth = 1;
    lineView.lineColor = kUIColorFromRGB(0xcccccc);
    lineView.dottedGap = 2;
    lineView.dotted = YES;
    [viewOrderInfo addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
        make.right.mas_equalTo(viewOrderInfo.mas_right).mas_offset(-20);
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(50);
        make.height.mas_equalTo(1);
    }];
    
    
    UILabel *labTime = [UILabel new];
    labTime.font = [UIFont systemFontOfSize:14];
    labTime.textColor = kUIColorFromRGB(0xb7b7b7);
    labTime.text = @"时间：";
    [viewOrderInfo addSubview:labTime];
    [labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(65);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
    }];
    
    self.labTimeX = [UILabel new];
    self.labTimeX.font = [UIFont systemFontOfSize:14];
    self.labTimeX.textColor = kUIColorFromRGB(0x1a1a1a);
    self.labTimeX.text = @"2015年8月26日 13：00-14：00";
    [viewOrderInfo addSubview:self.labTimeX];
    [self.labTimeX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(65);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(65);
    }];
    
    UILabel *labAddress = [UILabel new];
    labAddress.font = [UIFont systemFontOfSize:14];
    labAddress.textColor = kUIColorFromRGB(0xb7b7b7);
    labAddress.text = @"地点：";
    [viewOrderInfo addSubview:labAddress];
    [labAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(95);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
    }];
    
    self.labAddressX = [UILabel new];
    self.labAddressX.font = [UIFont systemFontOfSize:14];
    self.labAddressX.textColor = kUIColorFromRGB(0x1a1a1a);
    self.labAddressX.text = @"四川省成都市高新区天府三街香年广场";
    [viewOrderInfo addSubview:self.labAddressX];
    [self.labAddressX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(95);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(65);
    }];
    
    UILabel *labModel = [UILabel new];
    labModel.font = [UIFont systemFontOfSize:14];
    labModel.textColor = kUIColorFromRGB(0xb7b7b7);
    labModel.text = @"型号：";
    [viewOrderInfo addSubview:labModel];
    [labModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(125);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
    }];
    
    self.labModelX = [UILabel new];
    self.labModelX.font = [UIFont systemFontOfSize:14];
    self.labModelX.textColor = kUIColorFromRGB(0x1a1a1a);
    self.labModelX.text = @"川A07D11 标志508 银灰";
    [viewOrderInfo addSubview:self.labModelX];
    [self.labModelX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewOrderInfo.mas_top).mas_offset(125);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(65);
    }];
    
    
    DMLineView *lineView2 = [[DMLineView alloc] init];
    lineView2.backgroundColor = [UIColor whiteColor];
    lineView2.lineWidth = 1;
    lineView2.lineColor = kUIColorFromRGB(0xcccccc);
    lineView2.dottedGap = 2;
    lineView2.dotted = YES;
    [viewOrderInfo addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
        make.right.mas_equalTo(viewOrderInfo.mas_right).mas_offset(-20);
        make.bottom.mas_equalTo(viewOrderInfo.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *labUserName = [UILabel new];
    labUserName.textColor = kUIColorFromRGB(0xb7b7b7);
    labUserName.text = @"用户：";
    labUserName.font = [UIFont systemFontOfSize:14];
    [viewOrderInfo addSubview:labUserName];
    [labUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView2.mas_top).mas_offset(10);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
    }];
    
    self.labUser = [UILabel new];
    self.labUser.text = @"洗白白";
    self.labUser.font = [UIFont systemFontOfSize:14];
    [viewOrderInfo addSubview:self.labUser];
    [self.labUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView2.mas_top).mas_offset(10);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(65);
    }];
    
    UILabel *labUserPhone = [UILabel new];
    labUserPhone.textColor = kUIColorFromRGB(0xb7b7b7);
    labUserPhone.text = @"电话：";
    labUserPhone.font = [UIFont systemFontOfSize:14];
    [viewOrderInfo addSubview:labUserPhone];
    [labUserPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labUserName.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
    }];
    
    self.labUserPhoneX = [UILabel new];
    self.labUserPhoneX.text = @"手机号";
    self.labUserPhoneX.font = [UIFont systemFontOfSize:14];
    [viewOrderInfo addSubview:self.labUserPhoneX];
    [self.labUserPhoneX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labUser.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(65);
    }];
  
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(1);
    }];
//    mainScrollView.hidden = YES;
    if (self.flag) {
        UILabel *labPlanTime = [UILabel new];
        labPlanTime.textColor = kUIColorFromRGB(0xb7b7b7);
        labPlanTime.font = [UIFont systemFontOfSize:14];
        labPlanTime.text = @"预约时间：";
        [viewOrderInfo addSubview:labPlanTime];
        [labPlanTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(labUserPhone.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(viewOrderInfo.mas_left).mas_offset(20);
        }];
        
        UILabel *labTimePlan = [UILabel new];
        labTimePlan.font = [UIFont systemFontOfSize:14];
        labTimePlan.text = self.timePlan;
        [viewOrderInfo addSubview:labTimePlan];
        [labTimePlan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.labUserPhoneX.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(labPlanTime.mas_right).mas_offset(0);
        }];
    }
}

- (void)initData{
    [SVProgressHUD show];
    //请求用户信息
    [NetworkHelper postWithAPI:Select_user_API parameter:@{@"uid":self.uid} successBlock:^(id response) {
        NSLog(@"response %@",response);
        if([response[@"result"][@"uname"] isEqualToString:@""])
        self.labUser.text = @"洗白白";
        else
        self.labUser.text = response[@"result"][@"uname"];
        self.labUserPhoneX.text = response[@"result"][@"iphone"];
        [SVProgressHUD dismiss];
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"信息有误"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    long timedate = [self getTimeStamp:[NSDate date]];
    NSString *str=[NSString stringWithFormat:@"%ld",timedate];//时间戳
    NSTimeInterval time=[str doubleValue]-28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    self.labTimeX.text = currentDateStr;
    
    self.labAddressX.text = self.order_location;
    
    //查询车辆信息
    [NetworkHelper postWithAPI:car_select parameter:@{@"uid":self.uid} successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[@"code"] integerValue] == 1) {
            NSDictionary *result=[response objectForKey:@"result"];
            NSString *default_id=[result objectForKey:@"default"];
            NSArray *arrCar=[result objectForKey:@"list"];
            for (NSDictionary *dic in arrCar) {
                if ([default_id isEqualToString:[dic objectForKey:@"id"]]) {
                    self.labModelX.text = [NSString stringWithFormat:@"%@  %@  %@",dic[@"c_brand"],dic[@"c_color"],dic[@"c_plate_num"]];
                }
            }
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"信息有误"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //请求产品标题
    [NetworkHelper postWithAPI:API_orderName_price parameter:@{@"p_ids":self.p_ids} successBlock:^(id response) {
        [SVProgressHUD dismiss];
        self.labTitle.text = response[@"result"][@"order_name"];
        NSLog(@"pro %@",response);
        self.labMoney.text = [NSString stringWithFormat:@"%@",response[@"result"][@"order_price"]];
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"信息有误"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//时间戳？
-(long)getTimeStamp:(NSDate *)date
{
    if(date==nil)
    {
        date =[NSDate date];
    }
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    return (long)[localeDate timeIntervalSince1970];
}

@end
