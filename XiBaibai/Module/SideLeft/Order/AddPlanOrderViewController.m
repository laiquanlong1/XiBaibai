//
//  AddPlanOrderViewController.m
//  XBB
//
//  Created by Daniel on 15/8/21.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "AddPlanOrderViewController.h"
#import "TimeCollectionViewCell.h"
#import "UserObj.h"
#import "MJExtension.h"
#import "TimeConfigModel.h"
#import "CheckOnderViewController.h"

@interface AddPlanOrderViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>{

    UICollectionView *timeCollectview;//时间段

    NSMutableArray *_dateBtnArr; // 时间按钮数组
    NSDictionary *dateDic; // 时间字典
    int dateSelectedIndex; // 选择的时间下标
    NSInteger timeSegementId; // 选择的天
    NSIndexPath *_selectedIndexPath; // 选择的cell
    
    NSArray *timeArray;
    NSString *currentTime; // 当前时间
    
    NSString *selectTime;
    
    TimeConfigModel *selectTimeConfig;

}

@end

@implementation AddPlanOrderViewController


- (void)initTimeSelect
{
    if (self.timePlan) {
        timeArray = [self.timePlan componentsSeparatedByString:@" "];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"MM月dd日";
        if ([[timeArray firstObject] isEqualToString:[fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * 2]]]) {
            dateSelectedIndex = 2;
        }else if([[timeArray firstObject] isEqualToString:[fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60]]]) {
            dateSelectedIndex = 1;
        }else if([[timeArray firstObject] isEqualToString:@"今天"]) {
            dateSelectedIndex = 0;
        }
        [self dateBtnOnTouch:_dateBtnArr[dateSelectedIndex]];
    }
}


#pragma mark selectTimeAndBackAction


/**
 * @brief 返回
 * @detail 返回
 **/
- (void)back{
    self.planTime(nil);
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * @brief 确定选择时间
 * @detail 确定选择时间
 **/
- (IBAction)sure:(id)sender
{
    if ([selectTime length]<1 ||[selectTime isEqualToString:@""] || [selectTime isEqual:[NSNull class]]) {
        [SVProgressHUD showErrorWithStatus:@"请选择时间"];
        return;
    }
    NSString *timeString = [NSString stringWithFormat:@"%@,%ld",selectTime,selectTimeConfig.timeConfigId];
    self.planTime(timeString);
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 初始化视图


- (void)setNavigationBarControl
{
    self.showNavigation = YES;
    UIImage *leftImage = [UIImage imageNamed:@"back_xbb"];
    if (XBB_IsIphone6_6s) {
        leftImage = [UIImage imageNamed:@"back_xbb6"];
    }
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.userInteractionEnabled = YES;
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
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
    
    

    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width - 55., 28, 50, 30)];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14.]];
    [self.xbbNavigationBar addSubview:rightButton];
    [rightButton addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

/**
 * @brief 初始化
 * @detail 初始化视图
 **/
- (void)initView{

    self.title = @"预约时间";
    self.view.backgroundColor = kUIColorFromRGB(0xf4f4f4);
    
 
    //全局滚动视图
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    mainScrollView.userInteractionEnabled = YES;
    mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds),705);
    [mainScrollView setDelegate:self];
    //mainScrollView.backgroundColor=[UIColor redColor];
    [self.view addSubview:mainScrollView];
    
    //选择时间
    UIView *viewChoseTime = [[UIView alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth(self.view.bounds), 205)];
    viewChoseTime.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:viewChoseTime];
    
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";
    NSArray *dateArr = @[@"今天", [fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60]], [fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * 2]]];
    _dateBtnArr = [NSMutableArray array];
    
    // 时间选择
    for (int i = 0; i < dateArr.count; i++) {
        UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dateBtn.frame = CGRectMake(i * (self.view.frame.size.width / 3), 0, self.view.frame.size.width / 3, 40);
        
        [dateBtn setTitle:dateArr[i] forState:UIControlStateNormal];
        dateBtn.tag = i;
        dateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [dateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [dateBtn setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
        [viewChoseTime addSubview:dateBtn];
        if (i) {
            dateBtn.backgroundColor = [UIColor whiteColor];
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, dateBtn.frame.size.height)];
            lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
            [dateBtn addSubview:lineView];
        } else {
            dateBtn.backgroundColor = XBB_NavBar_Color;
            dateBtn.selected = YES;
        }
        [dateBtn addTarget:self action:@selector(dateBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [_dateBtnArr addObject:dateBtn];
    }

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
   //[flowLayout setItemSize:CGSizeMake(CGRectGetWidth(self.view.bounds)/4-2, 50)];//设置cell的尺寸
   [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
//    flowLayout.sectionInset = UIEdgeInsetsMake(.5, .5, 0, 0);//设置其边界
    flowLayout.minimumInteritemSpacing = 0.5;//竖 间隔
    flowLayout.minimumLineSpacing = 0.5;//横排间隔
    //创建时间段UICollectionView CGFloat top, CGFloat left, CGFloat bottom, CGFloat right
    timeCollectview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.bounds), 165) collectionViewLayout:flowLayout];
    timeCollectview.scrollEnabled = NO;
    timeCollectview.tag = 990;
    timeCollectview.backgroundColor = [UIColor whiteColor];
    //注册
    [timeCollectview registerClass:[TimeCollectionViewCell class]forCellWithReuseIdentifier:@"cell"];

    timeCollectview.dataSource=self;
    timeCollectview.delegate=self;
    [viewChoseTime addSubview:timeCollectview];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, timeCollectview.frame.origin.y, self.view.frame.size.width, 0.5)];
    lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
    [viewChoseTime addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeCollectview.frame), self.view.frame.size.width, 0.5)];
    lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
    [viewChoseTime addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(timeCollectview.frame) + timeCollectview.frame.size.height / 3, self.view.frame.size.width, 0.5)];
    lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
    [viewChoseTime addSubview:lineView];
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(timeCollectview.frame) + timeCollectview.frame.size.height / 3 * 2, self.view.frame.size.width, 0.5)];
    lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
    [viewChoseTime addSubview:lineView];
    lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(timeCollectview.frame) + timeCollectview.frame.size.width * 0.25, CGRectGetMinY(timeCollectview.frame), 0.5, timeCollectview.frame.size.height)];
    lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
    [viewChoseTime addSubview:lineView];
    lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(timeCollectview.frame) + timeCollectview.frame.size.width * 0.5, CGRectGetMinY(timeCollectview.frame), 0.5, timeCollectview.frame.size.height)];
    lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
    [viewChoseTime addSubview:lineView];
    lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(timeCollectview.frame) + timeCollectview.frame.size.width * 0.75, CGRectGetMinY(timeCollectview.frame), 0.5, timeCollectview.frame.size.height)];
    lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
    [viewChoseTime addSubview:lineView];
    
    UIView *viewXian=[[UIView alloc] initWithFrame:CGRectMake(0, 220, CGRectGetWidth(self.view.bounds), 0.5)];
    viewXian.backgroundColor = kUIColorFromRGB(0xdfdfdf);
    [mainScrollView addSubview:viewXian];
}
#pragma mark - 下半部分
- (void)dateBtnOnTouch:(UIButton *)sender {
    for (UIButton *temp in _dateBtnArr) {
        temp.selected = NO;
        if (temp != sender)
            temp.backgroundColor = [UIColor whiteColor];
    }

    sender.selected = YES;
    sender.backgroundColor = XBB_NavBar_Color;
    dateSelectedIndex = (int)sender.tag;
    
    [timeCollectview deselectItemAtIndexPath:_selectedIndexPath animated:YES];
    [timeCollectview reloadData];
}

- (void)initData{
    long time = [self getTimeStamp:[NSDate date]];
    NSLog(@"---%ld",time);
    [NetworkHelper postWithAPI:Time_select_make_API parameter:@{@"day":[NSString stringWithFormat:@"%ld", time]} successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [TimeConfigModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"timeConfigId": @"id"};
            }];
            NSMutableArray *oneArr = [NSMutableArray array];
            NSMutableArray *twoArr = [NSMutableArray array];
            NSMutableArray *threeArr = [NSMutableArray array];
            for (NSDictionary *temp in response[@"result"][@"one"]) {
                [oneArr addObject:[TimeConfigModel objectWithKeyValues:temp]];
            }
            for (NSDictionary *temp in response[@"result"][@"two"]) {
                [twoArr addObject:[TimeConfigModel objectWithKeyValues:temp]];
            }
            for (NSDictionary *temp in response[@"result"][@"three"]) {
                [threeArr addObject:[TimeConfigModel objectWithKeyValues:temp]];
            }
            dateDic = @{@"one": oneArr, @"two": twoArr, @"three": threeArr};
            currentTime = dateDic[@"currenttime"];
            [timeCollectview reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

//时间戳
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

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self setNavigationBarControl];
    [self initTimeSelect]; // 选择的时间
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - collectionView delegate
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView{
    
    return 1;
}
//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return 12;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake((self.view.frame.size.width - 1.5) * 0.25, 55);
}

// 选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (dateSelectedIndex) {
        case 0:
            if (indexPath.row < [dateDic[@"one"] count]) {
                return YES;
            }
            break;
        case 1:
            if (indexPath.row < [dateDic[@"two"] count]) {
                return YES;
            }
            break;
        default:
            if (indexPath.row < [dateDic[@"three"] count]) {
                return YES;
            }
            break;
    }
    return NO;
}

//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndexPath = indexPath;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";

    TimeCollectionViewCell * cell = (TimeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    cell.labYesNo.text = @"已选择";
    
    switch (dateSelectedIndex) {
        case 0: {
            TimeConfigModel *model = dateDic[@"one"][indexPath.row];
            timeSegementId = model.timeConfigId;
            selectTimeConfig = model;
            selectTime = [NSString stringWithFormat:@"今天 %@",cell.labtime.text];
        }
            break;
        case 1: {
            TimeConfigModel *model = dateDic[@"two"][indexPath.row];
            timeSegementId = model.timeConfigId;
            selectTime = [NSString stringWithFormat:@"%@ %@",[fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60]],cell.labtime.text];
            cell.backgroundColor = XBB_NavBar_Color; // 背景色
            selectTimeConfig = model;
        }
            break;
        default: {
            TimeConfigModel *model = dateDic[@"three"][indexPath.row];
            timeSegementId = model.timeConfigId;
            selectTime = [NSString stringWithFormat:@"%@ %@",[fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * 2]],cell.labtime.text];
            cell.backgroundColor = XBB_NavBar_Color; // 背景色
            selectTimeConfig = model;
        }
            break;
    }
}


// 取消选择
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    TimeCollectionViewCell * cell = (TimeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.labYesNo.text = @"可预约";
    cell.backgroundColor = kUIColorFromRGB(0xFFFFFF);

}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    TimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (!cell) {
        DLog(@"无法创建CollectionViewCell");
    }
    cell.labYesNo.text = @"";
    cell.labtime.text = @"";
    cell.selected = NO;
    cell.userInteractionEnabled = YES;
    TimeConfigModel *model = nil;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";
    
    switch (dateSelectedIndex) {
        case 0:
            if (indexPath.row < [dateDic[@"one"] count]) {

                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH:mm"];
                NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
                NSArray *arr = [currentDateStr componentsSeparatedByString:@":"];
                NSInteger modelH = [arr[0] integerValue];
                NSInteger modelM = [arr[1] integerValue];
                

                model = dateDic[@"one"][indexPath.row];
                cell.labtime.text = model.time;
                NSArray *time = [model.time componentsSeparatedByString:@"-"];
                if ([[time firstObject] integerValue] < modelH || ([[time firstObject] integerValue] == modelH && [[time lastObject] integerValue] < modelM)) {
                    cell.isYesNo = YES;
                    cell.labYesNo.text = @"不可预约";
                    cell.userInteractionEnabled = NO;
                }else
                {
                    cell.isYesNo = NO;
                    cell.labYesNo.text = @"可预约";
                }
                if ([[timeArray lastObject] isEqualToString:cell.labtime.text]&&[[timeArray firstObject] isEqualToString:@"今天"]) {
                     cell.selected = YES;
                    cell.labYesNo.text = @"已选择";
                    self.planTime = nil;
                }
                
            }
            break;
        case 1:
            if (indexPath.row < [dateDic[@"two"] count]) {
                model = dateDic[@"two"][indexPath.row];
                cell.labtime.text = model.time;
                cell.labYesNo.text = @"可预约";
                
                if ([[timeArray lastObject] isEqualToString:cell.labtime.text]&&[[timeArray firstObject] isEqualToString:[fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60]]]) {
                    cell.selected = YES;
                    cell.labYesNo.text = @"已选择";
                    self.planTime = nil;
                }
            }
    
            break;
        case 2:
            if (indexPath.row < [dateDic[@"three"] count]) {
                model = dateDic[@"three"][indexPath.row];
                cell.labtime.text = model.time;
                cell.labYesNo.text = @"可预约";
                if ([[timeArray lastObject] isEqualToString:cell.labtime.text]&&[[timeArray firstObject] isEqualToString:[fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * 2]]]) {
                    cell.selected = YES;
                    cell.labYesNo.text = @"已选择";
                    self.planTime = nil;
                }
            }
            break;
        default:
            cell.labtime.text=@"";
            cell.labYesNo.text=[NSString stringWithFormat:@""];
            cell.backgroundColor = [UIColor lightGrayColor];
            break;
    }
    
   
   
    return cell;
}


@end
