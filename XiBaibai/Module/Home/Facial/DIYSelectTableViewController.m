//
//  FacialTableViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/11/9.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "DIYSelectTableViewController.h"
#import "DIYTableViewCell.h"
#import "FacialTableViewCell.h"
#import "FacialDIYTableViewCell.h"
#import "DiyModel.h"
#import <MJExtension.h>
#import "WebViewController.h"



@interface DIYSelectTableViewController () <FacialDIYTableViewCellDelegate>
{
    UIImageView     *_bgImageView;
    UILabel         *_totalPriceLabel;
    float     _totalPrice; // 总共的价格
    
    
}
//@property (nonatomic, copy) NSArray *waxArr; // 打蜡
@property (nonatomic, copy) NSArray *comboArr; //  组合套餐
@property (nonatomic, copy) NSArray *listArr; // diy
//@property (nonatomic, copy) NSArray *noWashArr;
@property (nonatomic, copy) NSMutableArray *diyModels; //

@property (nonatomic, copy) NSMutableArray *hasSelectDiyArray;


//@property (nonatomic, strong) NSMutableArray *selectwaxArray;//选择的产品
//@property (nonatomic, strong) NSMutableArray *selectnoWashArr;// 选择的不用洗车项目
@property (nonatomic, strong) NSMutableArray *selectDIYPids; //


@property (nonatomic, strong, nullable) NSMutableArray *selectAllDIY;

@property (nonatomic, strong, nullable) UITableView *myTableView;
@end

@implementation DIYSelectTableViewController
#pragma mark data


// 从订单页传过来的
- (void)hasDataToPre
{
    if (self.selectDIYDic) {
        _totalPrice = [_selectDIYDic[@"price"] floatValue];
        _selectAllDIY = _selectDIYDic[@"diy"];
//        _selectnoWashArr = _selectDIYDic[@"noWash"];
//        _selectwaxArray = _selectDIYDic[@"wax"];
//        [selectDic setObject:_selectDIYPids forKey:@"diyCom"];
        _selectDIYPids = _selectDIYDic[@"diyCom"];
    }
}



- (void)fetchData
{
    [SVProgressHUD show];  // 展示进度条
    [NetworkHelper postWithAPI:API_SelectWax parameter:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [response copy];
        if (dic) {
            if ([response[@"code"] integerValue] == 1) {
                [SVProgressHUD dismiss];
                NSDictionary *resultDic = dic[@"result"];
                self.comboArr = resultDic[@"group"];
//                self.waxArr = resultDic[@"wax"][@"result"];
                self.listArr = resultDic[@"list"];
                
//                self.noWashArr = resultDic[@"notwash"][@"result"];
                [self.tableView reloadData];
            } else {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
    
}


#pragma mark action
- (IBAction)submit:(id)sender
{
//    if (self.washType == 0 && (_selectwaxArray.count > 0 || _selectDIYPids.count > 0 || _selectAllDIY.count > 0)) {
//        [SVProgressHUD showErrorWithStatus:@"您选择的项目必须选择洗车"];
//        return;
//    }
    if (self.washType == 0 && ( _selectDIYPids.count > 0 || _selectAllDIY.count > 0)) {
        [SVProgressHUD showErrorWithStatus:@"您选择的项目必须选择洗车"];
        return;
    }
    NSMutableDictionary *selectDic = [NSMutableDictionary dictionary];
    [selectDic setObject:@(_totalPrice) forKey:@"price"];
    [selectDic setObject:_selectAllDIY forKey:@"diy"];
//    [selectDic setObject:_selectwaxArray forKey:@"wax"];
//    [selectDic setObject:_selectnoWashArr forKey:@"noWash"];
    [selectDic setObject:_selectDIYPids forKey:@"diyCom"];
    self.diyServers(selectDic);
    [self.navigationController popViewControllerAnimated:YES];
    DLog(@"");
}
- (IBAction)backAction:(id)sender
{
//    if (self.washType == 0 && (_selectwaxArray.count > 0 || _selectDIYPids.count > 0 || _selectAllDIY.count > 0)) {
//        [SVProgressHUD showErrorWithStatus:@"您选择的项目必须选择洗车"];
//        return;
//    }
    if (self.washType == 0 && (_selectDIYPids.count > 0 || _selectAllDIY.count > 0)) {
        [SVProgressHUD showErrorWithStatus:@"您选择的项目必须选择洗车"];
        return;
    }
    NSMutableDictionary *selectDic = [NSMutableDictionary dictionary];
    [selectDic setObject:@(_totalPrice) forKey:@"price"];
    [selectDic setObject:_selectAllDIY forKey:@"diy"];
//    [selectDic setObject:_selectwaxArray forKey:@"wax"];
//    [selectDic setObject:_selectnoWashArr forKey:@"noWash"];
    [selectDic setObject:_selectDIYPids forKey:@"diyCom"];
    self.diyServers(selectDic);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark view
- (void)initView
{
    self.title = self.naviTitle?self.naviTitle:@"DIY选择";
    //返回
    UIImageView * img_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_back.png"]];
    img_view.layer.masksToBounds=YES;
    img_view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
    [img_view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:img_view];
    self.view.backgroundColor = kUIColorFromRGB(0xf4f4f4);
}

- (void)bgView
{
    _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImageView.image = [UIImage imageNamed:@"背景"];
    _bgImageView.alpha = 0.5;
    
    
    [self.tableView.backgroundView setUserInteractionEnabled:NO];
    self.tableView.backgroundView =_bgImageView;
    
    
}

- (void)initData
{
    _totalPrice = 0;
//    self.selectwaxArray = [NSMutableArray array];
//    self.selectnoWashArr = [NSMutableArray array];
    _selectDIYPids = [NSMutableArray array];
    _selectAllDIY = [NSMutableArray array];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self hasDataToPre];// 已经有数据
    [self initView]; // navi
//    [self bgView];
    [self.tableView registerNib:[UINib nibWithNibName:@"FacialTableViewCell" bundle:nil] forCellReuseIdentifier:@"facial"];
    [self.tableView registerClass:[FacialDIYTableViewCell class] forCellReuseIdentifier:@"cell"];
//    
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        self.waxArr = @[@{@"id":@"23",@"p_info":@"普通蜡",@"p_price":@"88",@"p_price2":@"98",@"p_wimg":@"",@"p_ximg":@""},@{@"id":@"25",@"p_info":@"有色蜡",@"p_price":@"128",@"p_price2":@"148",@"p_wimg":@"",@"p_ximg":@""},@{@"id":@"34",@"p_info":@"天然植物油打蜡",@"p_price":@"258",@"p_price2":@"298",@"p_wimg":@"",@"p_ximg":@""}];
//        self.listArr = @[@{@"id":@"6",@"p_info":@"金属条上光",@"p_price":@"9",@"p_price2":@"0",@"p_wimg":@"./Uplode/xbb_w01.png",@"p_ximg":@"./Uplode/xbb_x01.png"},@{@"id":@"7",@"p_info":@"轮胎润养",@"p_price":@"9",@"p_price2":@"9",@"p_wimg":@"./Uplode/xbb_w02.png",@"p_ximg":@"./Uplode/xbb_x02.png"},@{@"id":@"8",@"p_info":@"整车水泥处理",@"p_price":@"38",@"p_price2":@"38",@"p_wimg":@"./Uplode/xbb_w03.png",@"p_ximg":@"./Uplode/xbb_x03.png"},@{@"id":@"9",@"p_info":@"玻璃防雾处理(半车)",@"p_price":@"18",@"p_price2":@"0",@"p_wimg":@"./Uplode/xbb_w04.png",@"p_ximg":@"./Uplode/xbb_x04.png"},@{@"id":@"11",@"p_info":@"轮胎润养",@"p_price":@"9",@"p_price2":@"9",@"p_wimg":@"./Uplode/xbb_w02.png",@"p_ximg":@"./Uplode/xbb_x02.png"},@{@"id":@"13",@"p_info":@"整车水泥处理",@"p_price":@"38",@"p_price2":@"38",@"p_wimg":@"./Uplode/xbb_w03.png",@"p_ximg":@"./Uplode/xbb_x03.png"},@{@"id":@"14",@"p_info":@"金属条上光",@"p_price":@"9",@"p_price2":@"0",@"p_wimg":@"./Uplode/xbb_w01.png",@"p_ximg":@"./Uplode/xbb_x01.png"},@{@"id":@"15",@"p_info":@"轮胎润养",@"p_price":@"9",@"p_price2":@"9",@"p_wimg":@"./Uplode/xbb_w02.png",@"p_ximg":@"./Uplode/xbb_x02.png"},@{@"id":@"17",@"p_info":@"整车水泥处理",@"p_price":@"38",@"p_price2":@"38",@"p_wimg":@"./Uplode/xbb_w03.png",@"p_ximg":@"./Uplode/xbb_x03.png"},@{@"id":@"18",@"p_info":@"玻璃防雾处理(半车)",@"p_price":@"18",@"p_price2":@"0",@"p_wimg":@"./Uplode/xbb_w04.png",@"p_ximg":@"./Uplode/xbb_x04.png"},@{@"id":@"19",@"p_info":@"轮胎润养",@"p_price":@"9",@"p_price2":@"9",@"p_wimg":@"./Uplode/xbb_w02.png",@"p_ximg":@"./Uplode/xbb_x02.png"},@{@"id":@"33",@"p_info":@"整车水泥处理",@"p_price":@"38",@"p_price2":@"38",@"p_wimg":@"./Uplode/xbb_w03.png",@"p_ximg":@"./Uplode/xbb_x03.png"},@{@"id":@"35",@"p_info":@"轮胎润养",@"p_price":@"9",@"p_price2":@"9",@"p_wimg":@"./Uplode/xbb_w02.png",@"p_ximg":@"./Uplode/xbb_x02.png"},@{@"id":@"36",@"p_info":@"整车水泥处理",@"p_price":@"36",@"p_price2":@"38",@"p_wimg":@"./Uplode/xbb_w03.png",@"p_ximg":@"./Uplode/xbb_x03.png"}];
//        self.comboArr = @[@{@"groupName":@"车窗套餐",@"pro_ids":@[@{@"id":@"7"},@{@"id":@"8"},@{@"id":@"11"}]},@{@"groupName":@"划痕处理",@"pro_ids":@[@{@"id":@"14"},@{@"id":@"17"},@{@"id":@"19"},@{@"id":@"33"}]},@{@"groupName":@"玻璃除雾",@"pro_ids":@[@{@"id":@"6"},@{@"id":@"9"},@{@"id":@"13"},@{@"id":@"15"},@{@"id":@"18"}]}];
//        self.noWashArr = @[@{@"id":@"20",@"p_info":@"内饰SPA",@"p_price":@"158",@"p_price2":@"198",@"p_wimg":@"",@"p_ximg":@""},@{@"id":@"21",@"p_info":@"发动机舱干洗",@"p_price":@"158",@"p_price2":@"158",@"p_wimg":@"",@"p_ximg":@""},@{@"id":@"22",@"p_info":@"天然植物油打蜡",@"p_price":@"158",@"p_price2":@"158",@"p_wimg":@"",@"p_ximg":@""}];
//        
//        
//    });
    
    
    self.tableView.allowsMultipleSelection = YES;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    //    self.tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        [self fetchData]; // 获取数据
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (_comboArr) {
        switch (section) {
            case 2:
            {
                return @"打蜡";
            }
                break;
            case 0:
            {
                return @"套餐";
            }
                break;
            case 1:
            {
                return @"DIY";
            }
                break;
            case 3:
            {
                return @"非必洗项目";
            }
                break;
                
            default:
                break;
        }
    }
    return nil;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (_comboArr) {
        
        
        switch (section) {
            case 2:
                //            return self.waxArr.count;
                break;
            case 0:
                return self.comboArr.count;
                break;
            case 1:
                return 1;
                break;
            case 3:
                //            return self.noWashArr.count;
                break;
            default:
                break;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.myTableView = tableView;
    switch (indexPath.section) {
            
            
//            /**
//             * @brief 美容部分
//             * @detail 美容部分
//             **/
//        case 2:
//        {
//            static NSString *identity = @"facial";
//            FacialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
//            if (!cell) {
//                cell = [[FacialTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:identity];
//            }
//            cell.tag = 11;
//            
//            // 默认选择
//            UIImageView *imageV = cell.selectImageView;
//            [imageV setImage:[UIImage imageNamed:@"xbb_172"]];
//            cell.selectImageView = imageV;
//            for (NSDictionary *dic in self.selectwaxArray) {
//                if ([dic isEqualToDictionary:self.waxArr[indexPath.row]]) {
//                    UIImageView *imageV = cell.selectImageView;
//                    [imageV setImage:[UIImage imageNamed:@"xbb_168"]];
//                    cell.selectImageView = imageV;
//                    cell.tag = 22;
//                }
//            }
//            [CustamViewController  setUpCellLayoutMargins:cell];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            NSDictionary *dic = self.waxArr[indexPath.row];
//            
//            // 轿车类型(显示价格)
//            switch (self.selectCarType) {
//                case 1:
//                {
//                    NSString *string_1 = dic[@"p_info"];
//                    NSMutableAttributedString *attrI =[[NSMutableAttributedString alloc] initWithString:string_1] ;
//                    //            [attrI addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string_1 length])];
//                    [attrI addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [string_1 length])];
//                    
//                    NSString *string_2 = [NSString stringWithFormat:@"      %@",dic[@"p_price"]];
//                    NSMutableAttributedString *attrS =[[NSMutableAttributedString alloc] initWithString:string_2] ;
//                    [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string_2 length])];
//                    [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [string_2 length])];
//                    
//                    [attrI appendAttributedString:attrS];
//                    cell.facialNameLabel.attributedText = attrI;
//                }
//                    break;
//                    
//                default:
//                {
//                    NSString *string_1 = dic[@"p_info"];
//                    NSMutableAttributedString *attrI =[[NSMutableAttributedString alloc] initWithString:string_1] ;
//                    //            [attrI addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string_1 length])];
//                    [attrI addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [string_1 length])];
//                    
//                    NSString *string_2 = [NSString stringWithFormat:@"      %@",dic[@"p_price2"]];
//                    NSMutableAttributedString *attrS =[[NSMutableAttributedString alloc] initWithString:string_2] ;
//                    [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string_2 length])];
//                    [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [string_2 length])];
//                    
//                    [attrI appendAttributedString:attrS];
//                    cell.facialNameLabel.attributedText = attrI;
//                }
//                    break;
//            }
//            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
//            
//            
//            
//            
//            if (self.selectwaxArray) {
//                for (NSDictionary *dic_hasSelectwax in self.selectwaxArray) {
//                    DLog(@"%@",self.selectwaxArray);
//                    if ([dic isEqualToDictionary:dic_hasSelectwax]) {
//                        DLog(@"");
//                    }
//                }
//            }
//            
//            
//            
//
//            return cell;
//        }
//            break;
//            
            
            /**
             * @brief 套餐
             * @detail 套餐
             **/
        case 0:
        {
            
            static NSString *identity = @"facial";
            FacialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
            if (!cell) {
                cell = [[FacialTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"facial"];
            }
            cell.tag = 11;
            UIImageView *imageV = cell.selectImageView;
            [imageV setImage:[UIImage imageNamed:@"xbb_172"]];
            cell.selectImageView = imageV;
            for (NSArray *dic in _selectDIYPids) {
                if ([dic isEqual:self.comboArr[indexPath.row][@"pro_ids"]]) {
                    UIImageView *imageV = cell.selectImageView;
                    [imageV setImage:[UIImage imageNamed:@"xbb_168"]];
                    cell.selectImageView = imageV;
                    cell.tag = 22;
                }
            }
            
            
            [CustamViewController  setUpCellLayoutMargins:cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDictionary *dic = self.comboArr[indexPath.row];
            
            cell.facialNameLabel.text = dic[@"groupName"];
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
            
            return cell;
        }
            break;
            
            
            
            /**
             * @brief DIY
             * @detail DIY
             **/
        case 1:
        {
            
            static NSString *identity = @"cell";
            FacialDIYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
            if (!cell) {
                cell = [[FacialDIYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            }
            
            [CustamViewController  setUpCellLayoutMargins:cell];
            
            [cell configCell:self.listArr andWashType:self.washType andSelectPids:self.selectAllDIY.count > 0 ? self.selectAllDIY:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
            cell.tag = 11;
            return cell;
        }
            break;
            
            /**
             * @brief 非必洗
             * @detail 非必洗
             **/
//            
//        case 3:
//        {
//            
//            static NSString *identity = @"facial";
//            FacialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
//            if (!cell) {
//                cell = [[FacialTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"facial"];
//            }
//            cell.tag = 11;
//            UIImageView *imageV = cell.selectImageView;
//            [imageV setImage:[UIImage imageNamed:@"xbb_172"]];
//            cell.selectImageView = imageV;
//            for (NSDictionary *dic in self.selectnoWashArr) {
//                if ([dic isEqualToDictionary:self.noWashArr[indexPath.row]]) {
//                    UIImageView *imageV = cell.selectImageView;
//                    [imageV setImage:[UIImage imageNamed:@"xbb_168"]];
//                    cell.selectImageView = imageV;
//                    cell.tag = 22;
//                }
//            }
//            
//            [CustamViewController  setUpCellLayoutMargins:cell];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            NSDictionary *dic = self.noWashArr[indexPath.row];
//            switch (self.selectCarType) {
//                case 1:
//                {
//                    NSString *string_1 = dic[@"p_info"];
//                    NSMutableAttributedString *attrI =[[NSMutableAttributedString alloc] initWithString:string_1] ;
//                    [attrI addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [string_1 length])];
//                    
//                    NSString *string_2 = [NSString stringWithFormat:@"      %@",dic[@"p_price"]];
//                    NSMutableAttributedString *attrS =[[NSMutableAttributedString alloc] initWithString:string_2] ;
//                    [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string_2 length])];
//                    [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [string_2 length])];
//                    
//                    [attrI appendAttributedString:attrS];
//                    cell.facialNameLabel.attributedText = attrI;
//                }
//                    break;
//                    
//                default:
//                {
//                    NSString *string_1 = dic[@"p_info"];
//                    NSMutableAttributedString *attrI =[[NSMutableAttributedString alloc] initWithString:string_1] ;
//                    [attrI addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [string_1 length])];
//                    
//                    NSString *string_2 = [NSString stringWithFormat:@"      %@",dic[@"p_price2"]];
//                    NSMutableAttributedString *attrS =[[NSMutableAttributedString alloc] initWithString:string_2] ;
//                    [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string_2 length])];
//                    [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [string_2 length])];
//                    
//                    [attrI appendAttributedString:attrS];
//                    
//                    cell.facialNameLabel.attributedText = attrI;
//                }
//                    break;
//            }
//            
//            
//            
//            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
//            return cell;
//        }
//            
//            
        default:
            break;
    }
    
   
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
//            
//            /**
//             * @brief 打蜡
//             * @detail 打蜡选项
//             **/
//        case 2:
//        {
//           
//            FacialTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            if (self.washType == 0 && cell.tag == 11) {
//                
//                [SVProgressHUD showErrorWithStatus:@"此项目必须洗车"];
//                
//                break;
//            }
//
//            for (int i = 0; i < self.waxArr.count; i++) {
//                NSIndexPath *inde = [NSIndexPath indexPathForRow:i inSection:2];
//                FacialTableViewCell *cell_1 = [tableView cellForRowAtIndexPath:inde];
//                // 选择的不是同一个产品
//                if (![cell_1 isEqual:cell]) {
//                    cell_1.tag = 11;
//                    UIImageView *imageV = cell_1.selectImageView;
//                    [imageV setImage:[UIImage imageNamed:@"xbb_172"]];
//                    cell_1.selectImageView = imageV;
//                }else
//                {
//                    if (cell.tag == 22) {
//                        
//                        UIImageView *imageV = cell.selectImageView;
//                        [imageV setImage:[UIImage imageNamed:@"xbb_172"]];
//                        cell.selectImageView = imageV;
//                        cell.tag = 11;
//                    }else
//                    {
//                        UIImageView *imageV = cell.selectImageView;
//                        [imageV setImage:[UIImage imageNamed:@"xbb_168"]];
//                        cell.selectImageView = imageV;
//                        cell.tag = 22;
//                    }
//                }
//                
//                
//            }
//            
//            for (NSDictionary *dic in self.selectwaxArray) {
//                // 车型
//                switch (self.selectCarType) {
//                    case 1:
//                    {
//                        float price = [dic[@"p_price"] floatValue];
//                        _totalPrice -= price;
//                        
//                        
//                    }
//                        break;
//                        
//                    default:
//                    {
//                        float price = [dic[@"p_price2"] floatValue];
//                        _totalPrice -= price;
//                    }
//                        break;
//                }
//                
//                [self.selectwaxArray removeObject:dic];
//            }
//            if (cell.tag == 22) {
//                NSDictionary *dic = self.waxArr[indexPath.row];
//                switch (self.selectCarType) {
//                    case 1:
//                    {
//                        float price = [dic[@"p_price"] floatValue];
//                        _totalPrice += price;
//                        
//                        
//                    }
//                        break;
//                        
//                    default:
//                    {
//                        float price = [dic[@"p_price2"] floatValue];
//                        _totalPrice += price;
//                    }
//                        break;
//                }
//                [self.selectwaxArray addObject:dic];
//                
//            }
//            
//            if (self.selectwaxArray) {
//                DLog(@"%@",self.selectwaxArray);
//            }
//            [_totalPriceLabel setText:[NSString stringWithFormat:@"%.2f",_totalPrice]];
//        }
//            break;
            
            /**
             * @brief 组合
             * @detail 组合选项
             **/
        case 0:
        {
            
          
            
            // 获取到点击的cell
            FacialTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            // 如果洗车类型未选择的话进行此代码
            if (self.washType == 0 && cell.tag == 11) {
                
                [SVProgressHUD showErrorWithStatus:@"此项目必须洗车"];
                
                break;
            }
            
            // 换取图片(tag = 22时是选择状态  tag = 11时是未选择状态)
            if (cell.tag == 22) {
                UIImageView *imageV = cell.selectImageView;
                [imageV setImage:[UIImage imageNamed:@"xbb_172"]];
                cell.selectImageView = imageV;
                cell.tag = 11;
            }else
            {
                UIImageView *imageV = cell.selectImageView;
                [imageV setImage:[UIImage imageNamed:@"xbb_168"]];
                cell.selectImageView = imageV;
                cell.tag = 22;
            }
            
            
            // 在选择状态的时候进行的操作
            if (cell.tag == 22) {
                
            
                
                // 获取到选择的项目字典(数据模式)
                // @[@{@"groupName":@"车窗套餐",@"pro_ids":@[@{@"id":@"7"}...]}]
                NSDictionary *dic = self.comboArr[indexPath.row];
                
                // 获取数组(数据模式)
                // @[@{@"id":@"17"}...]
                NSArray *datas = dic[@"pro_ids"];
  
                // 如果选择的组合存在（选中状态）进行删除数据操作
                if (datas.count > 0) {
                    // 迭代数据进行操作
                    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        // 数据模式 @{@"id":@"2"}...
                        NSDictionary *dic = obj;
                        
                        // 如果选择的diy数组存在(数据模式) @[@{@"id":@"1"}...]
                        if (_selectAllDIY.count > 0) {
                            
                            // 获取选择的diy数目
                            NSUInteger count = _selectAllDIY.count;
                            
                            // 进行迭代判断删除
                            while (count) {
                                // 获取到单个选择的diy
                                // @{@"id":@"6",@"p_info":@"金属条上光",@"p_price":@"9",@"p_price2":@"0",@"p_wimg":@"./Uplode/xbb_w01.png",@"p_ximg":@"./Uplode/xbb_x01.png"}
                                NSDictionary *dic_dic =  _selectAllDIY[count -1];
                                
                                // 进行id对照对上就减去价格
                                if ([dic_dic[@"id"] integerValue] == [dic[@"id"] integerValue]) {
                                    
                                    // 从总价里面减去价格
                                    float price = [dic_dic[@"p_price"] floatValue];
                                    _totalPrice -= price;
                                    
                                    // 从单个diy里面删除数据
                                    [_selectAllDIY removeObject:dic_dic];
                                }
                                // 循环条件缩小范围
                                count -- ;
                            }
                            
                        }
                    }];
                }
                // 添加到数组
                [_selectDIYPids addObject:datas]; // diy
                
                
                // 组合数据添加
                for (NSDictionary *dic_datas in datas) {
                    NSInteger id_datas = [dic_datas[@"id"] integerValue];
                    
                    for (NSDictionary *dic_listDic in self.listArr) {
                        // 获取列表中的id
                        NSInteger id_list = [dic_listDic[@"id"] integerValue];
                        if (id_datas == id_list) {
                            // 添加到选择的DIY数组
                            [_selectAllDIY addObject:dic_listDic];
                            
                            float price = [dic_listDic[@"p_price"] floatValue];
                            _totalPrice += price;
                        }
                    }
                }
                
                // 进行界面更新
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDIYCange object:nil userInfo:@{@"p_ids":_selectAllDIY}];
            
            // 取消选择
            }else
            {
                if (self.comboArr==nil) {
                    break;
                }
                
                
                // 获取到选择的项目字典(数据模式)
                // @[@{@"groupName":@"车窗套餐",@"pro_ids":@[@{@"id":@"7"}...]}]
                NSDictionary *dic = self.comboArr[indexPath.row];
                
                // 获取数组(数据模式)
                // @[@{@"id":@"17"}...]
                NSArray *datas = dic[@"pro_ids"];
                
                // 删除组合
                [_selectDIYPids removeObject:datas];
                
                // 非空判断
                if (_selectAllDIY == nil) {
                    break;
                }
                
                
                
                
                // 进行遍历
                for (NSDictionary *dic_datas in datas) {
                    NSInteger id_datas = [dic_datas[@"id"] integerValue];
                    
                    NSInteger count = [_selectAllDIY count];
                    while (count>0) {
                        NSDictionary *dic_alldiy = _selectAllDIY[count-1];
                        NSInteger id_alldiy = [dic_alldiy[@"id"] integerValue];
                        if (id_datas == id_alldiy) {
                            [_selectAllDIY removeObject:dic_alldiy];
                            float price = [dic_alldiy[@"p_price"] floatValue];
                            _totalPrice -= price;
                        }
                        count--;
                    }
                }
                // 更新ui
                 [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDIYCange object:nil userInfo:@{@"p_ids":_selectAllDIY}];
         
            }
        }
            break;
            
            /**
             * @brief DIY
             * @detail DIY选项
             **/
        case 1:
        {
            
        }
            break;
//            
//            /**
//             * @brief 不需要洗车选项
//             * @detail 打蜡选项
//             **/
//        case 3:
//        {
//            FacialTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            
//            
//            if (cell.tag == 22) {
//                UIImageView *imageV = cell.selectImageView;
//                [imageV setImage:[UIImage imageNamed:@"xbb_172"]];
//                cell.selectImageView = imageV;
//                cell.tag = 11;
//            }else
//            {
//                UIImageView *imageV = cell.selectImageView;
//                [imageV setImage:[UIImage imageNamed:@"xbb_168"]];
//                cell.selectImageView = imageV;
//                cell.tag = 22;
//            }
//            
//            DLog(@"%ld",cell.tag);
//            if (cell.tag == 22) {
//                [self.selectnoWashArr addObject:self.noWashArr[indexPath.row]];
//                NSDictionary *dic = self.noWashArr[indexPath.row];
//                switch (self.selectCarType) {
//                    case 1:
//                    {
//                        float price = [dic[@"p_price"] floatValue];
//                        _totalPrice += price;
//                        
//                        
//                    }
//                        break;
//                        
//                    default:
//                    {
//                        float price = [dic[@"p_price2"] floatValue];
//                        _totalPrice += price;
//                    }
//                        break;
//                }
//                
//                
//            }else
//            {
//                if (self.selectnoWashArr) {
//                    
//                    for (NSDictionary *dic_1 in self.selectnoWashArr) {
//                        if ([dic_1 isEqualToDictionary:self.noWashArr[indexPath.row]]) {
//                            switch (self.selectCarType) {
//                                case 1:
//                                {
//                                    float price = [dic_1[@"p_price"] floatValue];
//                                    _totalPrice -= price;
//                                    
//                                    
//                                }
//                                    break;
//                                    
//                                default:
//                                {
//                                    float price = [dic_1[@"p_price2"] floatValue];
//                                    _totalPrice -= price;
//                                }
//                                    break;
//                            }
//                            [_totalPriceLabel setText:[NSString stringWithFormat:@"%.2f",_totalPrice]];
//                            [self.selectnoWashArr removeObject:dic_1];
//                            DLog(@"%f   %@",_totalPrice,_totalPriceLabel.text);
//                            DLog(@"%@",self.selectnoWashArr);
//                            break;
//                        }
//                    }
//                }
//            }
//            [_totalPriceLabel setText:[NSString stringWithFormat:@"%.2f",_totalPrice]];
//            DLog(@"%f   %@",_totalPrice,_totalPriceLabel.text);
//            DLog(@"%@",self.selectnoWashArr);
//            
//            
//        }
//            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_comboArr) {
        if (section == 1) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
            view.backgroundColor = [UIColor clearColor];
            
            
            UILabel *label_1 = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, 100, 30)];
            label_1.text = @"DIY总价:";
            label_1.font = [UIFont systemFontOfSize:14];
            [view addSubview:label_1];
            
            _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 , 20, 100, 30)];
            _totalPriceLabel.textColor = [UIColor redColor];
            _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",_totalPrice];
            _totalPriceLabel.font = [UIFont systemFontOfSize:20.];
            [view addSubview:_totalPriceLabel];
            
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 65, view.bounds.size.width, 44)];
            //        button.layer.cornerRadius = 5;
            [button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundColor:[UIColor colorWithRed:253/255. green:122/255. blue:10/255. alpha:1]];
            //        [button setBackgroundColor:kUIColorFromRGB(0xc8141c)];
            [button setTintColor:[UIColor whiteColor]];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [view addSubview:button];
            button.alpha = 0.95;
            
            
            
            return view;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 150;
    }
    return 0;
}

#pragma mark delegate

- (void)tapActionFacialToProD:(NSString *)p_id complete:(void (^)(id))complete
{
    
    
    // 判断
    BOOL isSelect = NO;

    // 遍历所有选择的diy项目
    for (NSDictionary *dic in self.selectAllDIY) {
        if ([dic[@"id"] integerValue] == [p_id integerValue]) {
            isSelect = YES;
        }
    }
    // 全部为空时
    if (isSelect == NO) {
        for (NSDictionary *dic_list in self.listArr) {
            if ([dic_list[@"id"] integerValue] == [p_id integerValue]) {
                if (_washType == 0 ) {
                    [SVProgressHUD showErrorWithStatus:@"DIY项目必须选择洗车"];
                    return;
                }
                [_selectAllDIY addObject:dic_list]; // 添加数组
                // 加价
                float price = [dic_list[@"p_price"] floatValue];
                _totalPrice += price;
                 [_totalPriceLabel setText:[NSString stringWithFormat:@"%.2f",_totalPrice]];
                complete(@{@"id":p_id});
            }
        }
        return;
    }
    
    
    
    // 遍历选择的全部DIY
    for (NSDictionary *dic_id in self.selectAllDIY) {
        if ([dic_id[@"id"]integerValue] == [p_id integerValue]) {
            complete(p_id);
            // 删除
            [_selectAllDIY removeObject:dic_id];
            // 减去价格
            for (NSDictionary *dic_list in self.listArr) {
                NSInteger id_list = [dic_list[@"id"] integerValue]; // 获取id
                if ([p_id integerValue] == id_list) {
                    float price = [dic_list[@"p_price"] floatValue];
                    _totalPrice -= price;
                    [_totalPriceLabel setText:[NSString stringWithFormat:@"%.2f",_totalPrice]];
                    
                    //处理组合数据
                    NSInteger count = [self.selectDIYPids count];
                    while (count > 0) {
                        NSArray *ids = self.selectDIYPids[count - 1];
                        for (NSDictionary *dic_ids in ids) {
                            if ([dic_ids[@"id"] integerValue] == [p_id integerValue]) {
                                // 判断是否是组合数据
                                for (int i = 0; i < self.comboArr.count; i ++) {
                                    DLog(@"%@",self.comboArr);
                                    FacialTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                    if (cell.tag == 22) {
                                        NSDictionary *dic_com  = self.comboArr[i];
                                        NSArray *arr_com = dic_com[@"pro_ids"];
                                        for (NSDictionary *iddic in arr_com) {
                                            if ([iddic[@"id"] integerValue] == [p_id integerValue]) {
                                                // 设置图片
                                                UIImageView *imageV = cell.selectImageView;
                                                [imageV setImage:[UIImage imageNamed:@"xbb_172"]];
                                                cell.selectImageView = imageV;
                                            }
                                            
                                            
                                        }
                                        
                                    }
                                }
                                
                                // 移除组合数组
                                [self.selectDIYPids removeObject:ids];
                                return;
                            }
                        }
                        count -- ;
                    }
                }
            }
            return;
        }
    }
}

- (void)longPressFacialToProD:(NSString *)p_id
{
    WebViewController *viewcontroller = [[WebViewController alloc] init];
    viewcontroller.title = @"DIY产品";
    viewcontroller.urlString = p_id;//@"https://www.baidu.com";
    
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
