//
//  MyCenterViewController.m
//  XBB
//
//  Created by Apple on 15/8/23.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "MyCenterViewController.h"
#import "UserObj.h"
#import "CarInfo.h"
#import "MyCarModel.h"

#import "MJExtension.h"
#import "XBBMyCenterInfoTableViewCell.h"



@interface MyCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate, UITextFieldDelegate,UIPickerViewDelegate>{
    UserObj *userInfo;
    UIImageView *imgView_head;//用户头像
    UILabel *labName;//用户昵称
    UILabel *labSexT;//用户性别
    UILabel *labAgeT;//年龄
    UILabel *labiPhone;//手机
    
    NSString *_age;//选中的年龄
    
    UITableView *carTableView;//车辆信息
    
    
    UIImage *headImage;
    
    NSArray *pickerArray;//年龄选择
    UIView *viewPicker;
    
    //创建全局滚动视图
    UIScrollView *mainScrollView;
    UIView *contentView;
    
    UIImageView *headImageView;
    
   
}


@property (strong, nonatomic) NSMutableArray *carArr;
@property (strong, nonatomic) UITableView *tableView;

@end



static NSString *identifier_1 = @"cell_1";

@implementation MyCenterViewController


- (void)initView{
//    self.view.backgroundColor = [UIColor whiteColor];
////    self.navigationController.navigationBar.barTintColor=kUIColorFromRGB(0xdc3733);
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"我的信息";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.font = [UIFont boldSystemFontOfSize:20];
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
//    //返回
//
//     UIImageView * img_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_back.png"]];
//    img_view.layer.masksToBounds=YES;
//    img_view.userInteractionEnabled=YES;
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fanhui)];
//    [img_view addGestureRecognizer:tap];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:img_view];
//
//    //创建全局滚动视图
////    mainScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    mainScrollView = [UIScrollView new];
//    mainScrollView.backgroundColor=kUIColorFromRGB(0xf6f5fa);
//    [self.view addSubview:mainScrollView];
//    
//    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];


    
#pragma --mark 个人信息视图
//    UIView *userView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 280)];
    UIView *userView = [UIView new];
    userView.backgroundColor=[UIColor whiteColor];
    userView.layer.borderWidth=0.5;
    userView.layer.borderColor=kUIColorFromRGB(0xd9d9d9).CGColor;
    [mainScrollView addSubview:userView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(mainScrollView);
        make.height.mas_equalTo(280);
        make.top.mas_equalTo(mainScrollView.mas_top).mas_offset(20);
    }];
    
    //头像
    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 79)];
    headView.userInteractionEnabled=YES;
    [headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHead:)]];
    [userView addSubview:headView];
    
    UILabel *labhead=[UILabel new];
    labhead.text=@"头像";
    [headView addSubview:labhead];
    [labhead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(15);
    }];
    
    imgView_head = [UIImageView new];
    imgView_head.layer.cornerRadius = 30;
    imgView_head.layer.masksToBounds = YES;
    imgView_head.layer.borderColor=kUIColorFromRGB(0xd9d9d9).CGColor;
    imgView_head.layer.borderWidth= 0.5;
    [headView addSubview:imgView_head];
    [imgView_head mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
    }];
    
    UIImageView *imgArrowView = [UIImageView new];
    imgArrowView.image = [UIImage  imageNamed:@""];
    
    UIView *onelineView=[[UIView alloc] initWithFrame:CGRectMake(0, 79, CGRectGetWidth(self.view.bounds), 0.5)];
    onelineView.backgroundColor=kUIColorFromRGB(0xd9d9d9);
    [userView addSubview:onelineView];
    
    //姓名
    UIView *viewNike=[[UIView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.view.bounds), 49)];
    [viewNike addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeName:)]];
    [userView addSubview:viewNike];
    
    UILabel *labNike=[UILabel new];
    labNike.text=@"昵称";
    [viewNike addSubview:labNike];
    [labNike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
    labName=[UILabel new];
    labName.text=@"姓名";
    labName.textColor=kUIColorFromRGB(0x999999);
//    labName.font=[UIFont boldSystemFontOfSize:20];
    labName.textAlignment=NSTextAlignmentRight;
    [viewNike addSubview:labName];
    [labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(160);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    
    UIView *twolineView=[[UIView alloc] initWithFrame:CGRectMake(0, 129, CGRectGetWidth(self.view.bounds), 0.5)];
    twolineView.backgroundColor=kUIColorFromRGB(0xd9d9d9);
    [userView addSubview:twolineView];

    //性别
    UIView *viewSex=[[UIView alloc] initWithFrame:CGRectMake(0, 130, CGRectGetWidth(self.view.bounds), 49)];
    [viewSex addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSex:)]];
    [userView addSubview:viewSex];
    
    UILabel *labSex=[UILabel new];
    labSex.text=@"性别";
    [viewSex addSubview:labSex];
    [labSex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
    labSexT=[UILabel new];
    labSexT.text=@"性别";
    labSexT.textColor=kUIColorFromRGB(0x999999);
//    labSexT.font=[UIFont boldSystemFontOfSize:20];
    labSexT.textAlignment=NSTextAlignmentRight;
    [viewSex addSubview:labSexT];
    [labSexT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    
    UIView *threelineView=[[UIView alloc] initWithFrame:CGRectMake(0, 179, CGRectGetWidth(self.view.bounds), 0.5)];
    threelineView.backgroundColor=kUIColorFromRGB(0xd9d9d9);
    [userView addSubview:threelineView];
    
    //年龄
    UIView *viewAge=[[UIView alloc] initWithFrame:CGRectMake(0, 180, CGRectGetWidth(self.view.bounds), 49)];
    [viewAge addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAge:)]];
    [userView addSubview:viewAge];
    
    UILabel *labAge=[UILabel new];
    labAge.text=@"年龄";
    [viewAge addSubview:labAge];
    [labAge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
    labAgeT=[UILabel new];
    labAgeT.text=@"年龄";
    labAgeT.textColor=kUIColorFromRGB(0x999999);
//    labAgeT.font=[UIFont boldSystemFontOfSize:20];
    labAgeT.textAlignment=NSTextAlignmentRight;
    [viewAge addSubview:labAgeT];
    [labAgeT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    
    UIView *fourlineView=[[UIView alloc] initWithFrame:CGRectMake(0, 229, CGRectGetWidth(self.view.bounds), 0.5)];
    fourlineView.backgroundColor=kUIColorFromRGB(0xd9d9d9);
    [userView addSubview:fourlineView];

    //手机
    UIView *viewPhone=[[UIView alloc] initWithFrame:CGRectMake(0, 230, CGRectGetWidth(self.view.bounds), 50)];
    [userView addSubview:viewPhone];
    
    UILabel *labPhone=[UILabel new];
    labPhone.text=@"手机";
    [viewPhone addSubview:labPhone];
    [labPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
    labiPhone=[UILabel new];
    //labAgeT.text=@"";
    labiPhone.textColor=kUIColorFromRGB(0x999999);
    labiPhone.textAlignment=NSTextAlignmentRight;
    [viewPhone addSubview:labiPhone];
    [labiPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(160);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
#pragma --mark 车辆信息
    UILabel *labCheInfo=[UILabel new];
    [mainScrollView addSubview:labCheInfo];
    labCheInfo.textColor=kUIColorFromRGB(0x7f7f81);
    labCheInfo.text=@"车辆信息";
    [labCheInfo mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(userView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(100);
        make.left.mas_equalTo(15);
       
    }];
    
    carTableView=[[UITableView alloc] init];
    carTableView.delegate=self;
    carTableView.dataSource=self;
    carTableView.layer.borderWidth=0.5;
    carTableView.scrollEnabled=NO;
    carTableView.layer.borderColor=kUIColorFromRGB(0xd9d9d9).CGColor;
    [mainScrollView addSubview:carTableView];
    [carTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userView.mas_bottom).mas_offset(40);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UILabel *labAddCar=[UILabel new];
    labAddCar.text = @"添加车辆";
    labAddCar.userInteractionEnabled = YES;
    [labAddCar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCar:)]];
    labAddCar.textAlignment = NSTextAlignmentRight;
    [mainScrollView addSubview:labAddCar];
    [labAddCar mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(carTableView.mas_bottom).mas_offset(10);
        
        make.right.mas_equalTo(self.view).mas_offset(-20);
    }];
    
    UIImageView *imgViewAddcar=[UIImageView new];
    imgViewAddcar.userInteractionEnabled = YES;
    [imgViewAddcar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCar:)]];
    [mainScrollView addSubview:imgViewAddcar];
    imgViewAddcar.image=[UIImage imageNamed:@"1@icon_27.png"];
    [imgViewAddcar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(carTableView.mas_bottom).mas_offset(14);
//        make.width.mas_equalTo(0);
//        make.height.mas_equalTo(0);
        make.right.mas_equalTo(mainScrollView.mas_right).mas_offset(-95);
    }];
    
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imgViewAddcar.mas_bottom).mas_offset(50);
    }];
   
}

- (void)initData{
     userInfo = [UserObj shareInstance];
     [imgView_head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, userInfo.imgstring]]];
    labName.text=userInfo.uname;
    NSLog(@"%@",userInfo.age);
    labAgeT.text=userInfo.age;
    labiPhone.text=userInfo.iphone;
    if (userInfo.sex == 1) {
        labSexT.text = @"男";
    }else{
        labSexT.text = @"女";
    }
    
    //请求用户车辆信息
    // http://s-199705.gotocdn.com/Api/index/car_select
    NSMutableDictionary *dicCar=[NSMutableDictionary dictionary];
    [dicCar setValue:userInfo.uid forKey:@"uid"];
    //dicCar setValue:<#(id)#> forKey:<#(NSString *)#>
    [AFHelperViewController POSTJsonDataWithString:car_select withBianLiang:dicCar Block:^(NSDictionary *Dics, NSError *error) {
//        <#code#>
//    }]
//    [AFHelperViewController GetJsonDataWithString:car_select withBianLiang:dicCar Block:^(NSDictionary *dics,NSError *error){
        if (!error) {
            NSLog(@"车辆dics%@",Dics);
            self.carArr = [NSMutableArray new];
            NSDictionary *result=[Dics objectForKey:@"result"];
//            NSString *default_id=[result objectForKey:@"default"];
            NSArray *arrCar=[result objectForKey:@"list"];
            [MyCarModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"carId": @"id"};
            }];
            for (NSDictionary *dic in arrCar) {
                MyCarModel *car=[MyCarModel objectWithKeyValues:dic];
//                car.carId = [[dic objectForKey:@"id"] integerValue];
//                car.add_time = [[dic objectForKey:@"add_time"] integerValue];
//                car.c_color = [dic objectForKey:@"c_color"];
//                car.c_img = [dic objectForKey:@"c_img"];
//                car.c_plate_num = [dic objectForKey:@"c_plate_num"];
//                car.c_remark = [dic objectForKey:@"c_remark"];
//                car.c_type = [[dic objectForKey:@"c_type"] integerValue];
                
                [self.carArr addObject:car];
                [carTableView reloadData];
            }
            //carTableView.frame=CGRectMake(0, 340, CGRectGetWidth(self.view.bounds), [self.carArr count]*70);
            [carTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.view.bounds), [self.carArr count]*70));
            }];
           // mainScrollView.contentSize=CGSizeMake(CGRectGetWidth(self.view.bounds), 340+70*[self.carArr count]+55);
        }else{
            NSLog(@"error%@",error);
        }
    }];

}

- (void)initPicker{
    pickerArray = @[@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39"];
    viewPicker=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 220)];
    viewPicker.backgroundColor=kUIColorFromRGB(0xCCCCCC);
    UILabel *labchangeAge=[UILabel new];
    [viewPicker addSubview:labchangeAge];
    labchangeAge.text=@"出生日期";
    [labchangeAge mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.mas_equalTo(100);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(5);
    }];
    
    UILabel *labSubmitAge=[UILabel new];
    labSubmitAge.textAlignment = NSTextAlignmentRight;
    [viewPicker addSubview:labSubmitAge];
    labSubmitAge.text = @"提交";
    [labSubmitAge mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.mas_equalTo(80);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-20);
    }];
    labSubmitAge.userInteractionEnabled = YES;
    [labSubmitAge addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submitAge:)]];
   
    UIDatePicker *selectPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 216)];
    selectPicker.datePickerMode = UIDatePickerModeDate;
    [selectPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
//    //时间范围，从当前时间————后面3天
//    NSDate *dateMin=[NSDate date];
//    selectPicker.minimumDate=dateMin;
    NSDate *dateMax=[NSDate dateWithTimeIntervalSinceNow:0];
    selectPicker.maximumDate=dateMax;
    
    [selectPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [viewPicker addSubview:selectPicker];
    [self.view addSubview:viewPicker];
}


- (IBAction)backViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"个人信息"];
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

- (void)addTableViewUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64., XBB_Screen_width, XBB_Screen_height - 64.) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = XBB_Bg_Color;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBMyCenterInfoTableViewCell" bundle:nil] forCellReuseIdentifier:identifier_1];
    
    
    
}
- (void)setUpUI

{
    [self setNavigationBarControl];
    [self addTableViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    // Do any additional setup after loading the view.
//    [self initView];
    [self initData];
    [self initPicker];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carDidUpdate:) name:NotificationCarListUpdate object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)carDidUpdate:(NSNotification *)sender {
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fanhui{
    
    [self removeFromParentViewController];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma --mark添加用户车辆
- (void)addCar:(UIGestureRecognizer *)sender{
    UIViewController *addCarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddCarTableViewController"];
    [self.navigationController pushViewController:addCarVC animated:YES];
}



#pragma --mark 个人信息修改
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    viewPicker.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.bounds), self.view.frame.size.width, 220);
    mainScrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
    if (mainScrollView.userInteractionEnabled == NO) {
        mainScrollView.userInteractionEnabled = YES;
    }

}
//修改年龄
//- (void)submitAge:(UIGestureRecognizer *)sender{
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    viewPicker.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.bounds), self.view.frame.size.width, 220);
//    
//    [UIView commitAnimations];
//    
//    //修改agehttp://s-199705.gotocdn.com/Api/index/user_msg_up
//    //    NSString *ages=
//    if([_age isKindOfClass:[NSNull class]] || _age == nil || _age == NULL){
//        _age = @"0";
//    }
//    NSMutableDictionary *dicage = [NSMutableDictionary new];
//    [dicage setObject:userInfo.uid forKey:@"uid"];
//    [dicage setObject:_age forKey:@"age"];
//    labAgeT.text = _age;
//    [NetworkHelper postWithAPI:updateUserInfo parameter:dicage successBlock:^(id response) {
//        if ([response[@"code"] integerValue] == 1) {
//            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//            labAgeT.text = _age;
//            userInfo.age=_age;
//            [UserObj shareInstance].age = _age;
//        } else {
//            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
//        }
//        
//    } failBlock:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"修改失败"];
//    }];
//
//}

- (void)datePickerValueChanged:(UIDatePicker *)picker{
    //获得当前时间：
    NSDate *now=[NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = picker.date;

    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date  toDate:now  options:0];
        
    int days = [comps day];
    NSLog(@"天数===%d",days);
    int years = days/365;
    NSLog(@"年数＝＝%d",years);
    
    _age = [NSString stringWithFormat:@"%d",years];
    mainScrollView.userInteractionEnabled = YES;
    
    
}

//修改年龄
- (void)changeAge:(UIGestureRecognizer *)sender{
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改年龄" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 111;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    // if(offset > 0)
//    viewPicker.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.bounds)-216, self.view.frame.size.width, 216);
//    mainScrollView.frame = CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//    mainScrollView.userInteractionEnabled = NO;
    
}

//修改名字
- (void)changeName:(UIGestureRecognizer *)sender{
    UIAlertView *alert=[CustamViewController createAlertViewTitleStr:@"修改姓名" withMsg:nil widthDelegate:self withCancelBtn:@"取消" withbtns:@"修改"];
    alert.alertViewStyle= UIAlertViewStylePlainTextInput;
    [alert show];
}

// 验证年龄是否是数字
- (BOOL)verifyAge
{
    NSString *string = @"^[0-9]*$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",string];
    return [passWordPredicate evaluateWithObject:_age];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111) {
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            _age = tf.text;
            if (![self verifyAge]||[_age integerValue]< 0 || [_age integerValue] > 200) {
                [SVProgressHUD showErrorWithStatus:@"请输入正确的年龄"];
                return;
            }
            NSMutableDictionary *dicage = [NSMutableDictionary new];
            [dicage setObject:userInfo.uid forKey:@"uid"];
            [dicage setObject:_age forKey:@"age"];
            labAgeT.text = _age;
            [NetworkHelper postWithAPI:updateUserInfo parameter:dicage successBlock:^(id response) {
                if ([response[@"code"] integerValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    labAgeT.text = _age;
                    userInfo.age=_age;
                    [UserObj shareInstance].age = _age;
                } else {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
                
            } failBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"修改失败"];
            }];

            
        }
        
        return;
    }
    
    if (buttonIndex==1) {
        //得到输入框
        UITextField *tf=[alertView textFieldAtIndex:0];
        NSLog(@"%@",tf.text);
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setObject:userInfo.uid forKey:@"uid"];
        [dic setObject:tf.text forKey:@"uname"];
        [NetworkHelper postWithAPI:updateUserInfo parameter:dic successBlock:^(id response) {
            if ([response[@"code"] integerValue] == 1) {
                labName.text=tf.text;
                userInfo.uname=tf.text;
                [UserObj shareInstance].uname = tf.text;
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            } else {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
            
            NSLog(@"respone%@",response);
            
          [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUserSuccessful object:nil];
        } failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }];
    }
}

//修改性别
- (void)changeSex:(UIGestureRecognizer *)sender{
    UIActionSheet *action=[CustamViewController createActionSheetWithTitle:@"选择性别" withDelegate:self withCancel:@"取消" withdetructivebutton:nil withotherbtn:@"男" withothers:@"女"];
    
    [action showInView:self.view];

}

//修改头像
- (void)changeHead:(UIGestureRecognizer *)sender{
    UIActionSheet *action=[CustamViewController createActionSheetWithTitle:@"更换头像" withDelegate:self withCancel:@"取消" withdetructivebutton:nil withotherbtn:@"拍摄" withothers:@"相册选择"];
    [action showInView:self.view];
}

#pragma  --mark 头像修改
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:[NSString stringWithFormat:@"更换头像"]]) {
        if (buttonIndex == 0) {
            //拍照
            [self acquireImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }else if (buttonIndex == 1){
            
            //调用相册
            [self acquireImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }else if(buttonIndex == 2) {
            NSLog(@"取消");
        }
        
    }else if([actionSheet.title isEqualToString:[NSString stringWithFormat:@"选择性别"]]){
        if(buttonIndex==0){
            NSLog(@"男");
//            [AFHelperViewController GetJsonDataWithString:[NSString stringWithFormat:@"http://s-199705.gotocdn.com/Api/index/user_msg_up?id=%@&sex=%@",userInfo.uid,[NSString stringWithFormat:@"1"]] Block:^(NSDictionary *Dics,NSError *error){
//                if (!error) {
//                    NSLog(@"mine DIC%@",Dics);
//                    labSexT.text=@"男";
//                    userInfo.sex=@"1";
//                }else{
//                    NSLog(@"error%@",error);
//                }
//            }];
            [NetworkHelper postWithAPI:updateUserInfo parameter:@{@"uid": [UserObj shareInstance].uid, @"sex": @"1"} successBlock:^(id response) {
                if ([response[@"code"] integerValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    labSexT.text = @"男";
                    [UserObj shareInstance].sex = @"1";
                } else {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
            } failBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"修改失败"];
            }];
        }else if(buttonIndex==1){
            NSLog(@"女");
            [NetworkHelper postWithAPI:updateUserInfo parameter:@{@"uid": [UserObj shareInstance].uid, @"sex": @"2"} successBlock:^(id response) {
                if ([response[@"code"] integerValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    labSexT.text = @"女";
                    [UserObj shareInstance].sex = @"2";
                } else {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
            } failBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"修改失败"];
            }];
//            [AFHelperViewController GetJsonDataWithString:[NSString stringWithFormat:@"http://s-199705.gotocdn.com/Api/index/user_msg_up?id=%@&sex=%@",userInfo.uid,[NSString stringWithFormat:@"2"]] Block:^(NSDictionary *Dics,NSError *error){
//                if (!error) {
//                    NSLog(@"mine DIC%@",Dics);
//                    
//                    labSexT.text=@"女";
//                    userInfo.sex=@"2";
//                }else{
//                    NSLog(@"error%@",error);
//                }
//            }];
        }else{
            NSLog(@"取消");
        }
    }

    
}

- (void)acquireImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    //获取途径
    imagePicker.sourceType = sourceType;
    //解决IOS8调用系统相机出现警告
    imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //是否编辑图片
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark UIImageViewPickerViewConrollerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //得到剪切后的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //保存图片到本地
    [self saveImage:image withName:[NSString stringWithFormat:@"newimage%@",@".jpg"]];
    
//    [self UploadHeadImage];
    [self uploadWithImage:image];
    
    //得到图片路径
    NSString * path = [NSString stringWithFormat:@"%@/newimage.jpg",[self documentFolderPath]];
    //指定显示图片
    
    
    NSIndexPath *ind = [NSIndexPath indexPathForRow:0 inSection:0];
    XBBMyCenterInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:ind];
//    [cell.headImageView setImage:[UIImage imageWithContentsOfFile:path]];
   
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma 上传头像

- (void)uploadWithImage:(UIImage *)image {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:UpdateUserImg_API parameters:@{@"uid": userInfo.uid} constructingBodyWithBlock:^(id <AFMultipartFormData> formData){
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1) name:[NSString stringWithFormat:@"file"] fileName:[NSString stringWithFormat:@"file.jpg"] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject){
        if ([responseObject[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [UserObj shareInstance].imgstring = responseObject[@"file"];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
//        NSLog(@"response %@",responseObject);
//        userInfo.imgstring = responseObject[@"file"][@"file"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUserSuccessful object:nil];
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }];
}

- (void)UploadHeadImage{
    
    //获取图片路径
    NSString * imagePath = [NSString stringWithFormat:@"%@/newimage.jpg",[self documentFolderPath]];
    UIImage *headImage = [UIImage imageWithContentsOfFile:imagePath];
    headImage = [UIImage imageCompressForSizeImage:headImage targetSize:CGSizeMake(60, 60)];
    NSData *imageData = UIImagePNGRepresentation(headImage);
    NSLog(@"passImage:%f",imageData.length/1024.0);
    
    if (imageData != nil) {
        
        [SVProgressHUD showWithStatus:@"上传头像中"];
        
        //将图片转换成Base64字符串
//        NSString *base64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        //设置请求路径
        //NSString *strUrl = @"http://s-199705.gotocdn.com/Api/index/user_msg_u_img";
        
        //设置请求参数
        NSDictionary *parameters = @{@"uid":userInfo.uid};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        AFHTTPRequestOperation *operation = [manager POST:UpdateUserImg_API
                                               parameters:parameters
                                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                    
                              [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"img"] fileName:[NSString stringWithFormat:@"img.jpg"] mimeType:@"image/jpeg"];
                                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                    NSLog(@"post Big success returnedDic%@",responseObject[@"msg"]);
                                                //获取json格式字符串
                                                NSString *jsonStr = operation.responseString;
                                                //字符串编码
                                                NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                                                //将json转换成字典
                                                NSDictionary *dic = [data mutableObjectFromJSONData];
                                    
                                                userInfo.imgstring = [[dic objectForKey:@"result"] objectForKey:@"u_img_name"];
                                               [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUserSuccessful object:nil];
                                               
                                                userInfo.imgstring=[NSString stringWithFormat:@"newimage%@",@".jpg"];
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:@"上传失败"];
                                    NSLog(@"post big file fail error=%@", error);
                                    }];
        [operation start];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        
//        //执行请求
//        [manager POST:UpdateUserImg_API parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            [SVProgressHUD dismiss];
//            
//            //获取json格式字符串
//            NSString *jsonStr = operation.responseString;
//            //字符串编码
//            NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
//            //将json转换成字典
//            NSDictionary *dic = [data mutableObjectFromJSONData];
//            
//            NSLog(@"上传成功/n%@",dic);
//            userInfo.imgstring = [[dic objectForKey:@"result"] objectForKey:@"u_img_name"];
//           [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUserSuccessful object:nil];
//           
////            userInfo.imgstring=[NSString stringWithFormat:@"newimage%@",@".jpg"];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            [SVProgressHUD showErrorWithStatus:@"网络出错!"];
//        }];
    }
}

#pragma mark 保存图片到沙盒

- (void)saveImage:(UIImage*) currentImage withName:(NSString *) name{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:name];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    NSLog(@"+++++++++++%@",fullPathToFile);
    
}

#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}



#pragma --mark tableview的delegate方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    XBBMyCenterInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier_1];
    if (!cell) {
        cell=[[XBBMyCenterInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier_1];
    }
//    cell.headImageView.hidden = YES;
    switch (indexPath.row) {
        case 0:
        {

//     
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    MyCarModel *model = [self.carArr objectAtIndex:indexPath.row];
    NSLog(@"%@",[self.carArr objectAtIndex:indexPath.row]);
    [SVProgressHUD show];
    [self deleteCarFromWebWithCar:model callback:^(bool isSuccess) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            [self.carArr removeObject:model];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

- (void)deleteCarFromWebWithCar:(MyCarModel *)model callback:(void (^)(bool isSuccess))callback {
    [NetworkHelper postWithAPI:Car_Delete_API parameter:@{@"uid": [UserObj shareInstance].uid, @"id": @(model.carId), @"c_plate_num": model.c_plate_num} successBlock:^(id response) {
        if (callback) {
            if ([[response objectForKey:@"code"] integerValue] == 1) {
                callback(YES);
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            } else {
                callback(NO);
                [SVProgressHUD showErrorWithStatus:@"删除失败"];
            }
        }
    } failBlock:^(NSError *error) {
        if (callback) {
            callback(NO);
        }
        [SVProgressHUD showErrorWithStatus:@"删除失败"];
    }];
}
#pragma pickerDegate方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

@end
