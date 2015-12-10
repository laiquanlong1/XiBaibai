//
//  DIYTableViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/11/24.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "FacialSelectTableViewController.h"
//#import "FacialTableViewCell.h"
#import "XBBListHeadLabel.h"
#import "AddOrderDetailTableViewCell.h"


@interface FaicalSelectTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel         *_totalPriceLabel;
    float           _totalPrice; // 总共的价格
    UIView          *barView;
    XBBListHeadLabel  *priceTotalTitle;
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *waxArr; // 打蜡
@property (nonatomic, copy) NSArray *noWashArr; // 不需要洗车



@property (nonatomic, strong) NSMutableArray *selectwaxArray;//选择的产品
@property (nonatomic, strong) NSMutableArray *selectnoWashArr;// 选择的不用洗车项目

@end

@implementation FaicalSelectTableViewController

#pragma mark 初始化数据
- (void)initData
{
    _selectwaxArray = [NSMutableArray array]; // 选择的打蜡项目
    _selectnoWashArr = [NSMutableArray array]; // 选择的非必洗项目
}

// 从订单页传过来的
- (void)hasDataToPre
{
    if (self.selectDIYDic) {
        _totalPrice = [_selectDIYDic[@"price"] floatValue];
        _selectnoWashArr = _selectDIYDic[@"noWash"];
        _selectwaxArray = _selectDIYDic[@"wax"];
    }
}


#pragma mark 获取数据

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
                self.waxArr = resultDic[@"wax"][@"result"];
                self.noWashArr = resultDic[@"notwash"][@"result"];
                [self alphaToOne];
                [self.tableView reloadData];
            } else {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

#pragma mark view

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

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width- XBB_Screen_width/3, 0, XBB_Screen_width/3, barView.bounds.size.height)];
    [button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = XBB_NavBar_Color;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:XBB_Bg_Color forState:UIControlStateNormal];
    [barView addSubview:button];
    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, XBB_Screen_width, XBB_Screen_height-64.-barView.frame.size.height);
    [self alphatoZero];
}
- (void)addAllPrice
{
    priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",_totalPrice>0?_totalPrice:0.00];
}


- (void)addtabview
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64., XBB_Screen_width, XBB_Screen_height-64.-44.) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = XBB_Bg_Color;
 
    [self.tableView registerNib:[UINib nibWithNibName:@"AddOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"facial"];
    self.tableView.separatorColor = kUIColorFromRGB(0xdddddd);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addtabview];
    [self addTabBar];
    [self setNavigationBarControl];
    [self initData]; //  初始化数据
    [self hasDataToPre]; // 有数据的情况
    [self fetchData]; // 获取数据
    
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

- (IBAction)backViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.noWashArr) {
        switch (section) {
            case 0:
            {
                return @"打蜡";
            }
                break;
            case 1:
            {
                return @"非必洗项目";
            }
                break;
            case 2:
            {
                
            }
                break;
                
            default:
                break;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return [_waxArr count];
        }
            break;
        case 1:
        {
            return [_noWashArr count];
        }
            break;
            
        default:
            break;
    }
    
#warning Incomplete implementation, return the number of rows
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            
            /**
             * @brief 美容部分
             * @detail 美容部分
             **/
        case 0:
        {
            static NSString *identity = @"facial";
            AddOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
            if (!cell) {
                cell = [[AddOrderDetailTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:identity];
            }
            cell.tag = 11;
            
            // 默认选择
            UIImageView *imageV = cell.selectImageView;
            [imageV setImage:[UIImage imageNamed:@"xbb_172"]];
            cell.selectImageView = imageV;
            for (NSDictionary *dic in self.selectwaxArray) {
                if ([dic isEqualToDictionary:self.waxArr[indexPath.row]]) {
                    UIImageView *imageV = cell.selectImageView;
                    [imageV setImage:[UIImage imageNamed:@"xbb_168"]];
                    cell.selectImageView = imageV;
                    cell.tag = 22;
                }
            }
            [CustamViewController  setUpCellLayoutMargins:cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDictionary *dic = self.waxArr[indexPath.row];
            
            // 轿车类型(显示价格)
            switch (self.selectCarType) {
                case 1:
                {
                    NSString *string_1 = dic[@"p_name"];
                    cell.titleLabel.text = string_1;
                    
//                    NSMutableAttributedString *attrI =[[NSMutableAttributedString alloc] initWithString:string_1] ;
                    //            [attrI addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string_1 length])];
//                    [attrI addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [string_1 length])];
                    
                    NSString *string_2 = [NSString stringWithFormat:@"      %@",dic[@"p_price"]];
//                    NSMutableAttributedString *attrS =[[NSMutableAttributedString alloc] initWithString:string_2] ;
//                    [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string_2 length])];
//                    [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [string_2 length])];
//                    
//                    [attrI appendAttributedString:attrS];
                    cell.priceLabel.text = string_2;
                }
                    break;
                    
                default:
                {
//                    NSString *string_1 = dic[@"p_info"];
//                    NSMutableAttributedString *attrI =[[NSMutableAttributedString alloc] initWithString:string_1] ;
                    
                    NSString *string_1 = dic[@"p_name"];
                    cell.titleLabel.text = string_1;
                    //            [attrI addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string_1 length])];
//                    [attrI addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [string_1 length])];
                    
                    NSString *string_2 = [NSString stringWithFormat:@"      %@",dic[@"p_price2"]];
//                    NSMutableAttributedString *attrS =[[NSMutableAttributedString alloc] initWithString:string_2] ;
//                    [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string_2 length])];
//                    [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [string_2 length])];
//                    
//                    [attrI appendAttributedString:attrS];
//                    cell.facialNameLabel.attributedText = attrI;
                    cell.priceLabel.text = string_2;
                }
                    break;
            }
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
            if (self.selectwaxArray) {
                for (NSDictionary *dic_hasSelectwax in self.selectwaxArray) {
                    DLog(@"%@",self.selectwaxArray);
                    if ([dic isEqualToDictionary:dic_hasSelectwax]) {
                        DLog(@"");
                    }
                }
            }
            return cell;
        }
            break;
            
            /**
             * @brief 非必洗
             * @detail 非必洗
             **/
            
        case 1:
        {
            
            static NSString *identity = @"facial";
            AddOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
            if (!cell) {
                cell = [[AddOrderDetailTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"facial"];
            }
            cell.tag = 11;
            UIImageView *imageV = cell.selectImageView;
            [imageV setImage:[UIImage imageNamed:@"xbb_172"]];
            cell.selectImageView = imageV;
            for (NSDictionary *dic in self.selectnoWashArr) {
                if ([dic isEqualToDictionary:self.noWashArr[indexPath.row]]) {
                    UIImageView *imageV = cell.selectImageView;
                    [imageV setImage:[UIImage imageNamed:@"xbb_168"]];
                    cell.selectImageView = imageV;
                    cell.tag = 22;
                }
            }
            
            [CustamViewController  setUpCellLayoutMargins:cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDictionary *dic = self.noWashArr[indexPath.row];
            switch (self.selectCarType) {
                case 1:
                {
//                    NSString *string_1 = dic[@"p_info"];
//                    NSMutableAttributedString *attrI =[[NSMutableAttributedString alloc] initWithString:string_1] ;
//                    [attrI addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [string_1 length])];
                    
                    NSString *string_2 = [NSString stringWithFormat:@"      %@",dic[@"p_price"]];
                    
//                    NSMutableAttributedString *attrS =[[NSMutableAttributedString alloc] initWithString:string_2] ;
//                    [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string_2 length])];
//                    [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [string_2 length])];
                    
//                    [attrI appendAttributedString:attrS];
//                    cell.facialNameLabel.attributedText = attrI;
                    cell.priceLabel.text = string_2;
                }
                    break;
                    
                default:
                {
//                    NSString *string_1 = dic[@"p_info"];
//                    NSMutableAttributedString *attrI =[[NSMutableAttributedString alloc] initWithString:string_1] ;
//                    [attrI addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [string_1 length])];
//                    
                    NSString *string_2 = [NSString stringWithFormat:@"      %@",dic[@"p_price2"]];
//                    NSMutableAttributedString *attrS =[[NSMutableAttributedString alloc] initWithString:string_2] ;
//                    [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string_2 length])];
//                    [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [string_2 length])];
//                    
//                    [attrI appendAttributedString:attrS];
                    
//                    cell.facialNameLabel.attributedText = attrI;
                    cell.priceLabel.text = string_2;
                }
                    break;
            }
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
            return cell;
        }
        default:
            break;
    }
    
    
    return nil;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
            
            /**
             * @brief 打蜡
             * @detail 打蜡选项
             **/
        case 0:
        {
            
            AddOrderDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (self.washType == 0 && cell.tag == 11) {
                
                [SVProgressHUD showErrorWithStatus:@"此项目必须洗车"];
                
                break;
            }
            
            for (int i = 0; i < self.waxArr.count; i++) {
                NSIndexPath *inde = [NSIndexPath indexPathForRow:i inSection:0];
                AddOrderDetailTableViewCell *cell_1 = [tableView cellForRowAtIndexPath:inde];
                // 选择的不是同一个产品
                if (![cell_1 isEqual:cell]) {
                    cell_1.tag = 11;
                    UIImageView *imageV = cell_1.selectImageView;
                    [imageV setImage:[UIImage imageNamed:@"xbb_172"]];
                    cell_1.selectImageView = imageV;
                }else
                {
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
                }
                
                
            }
            
            for (NSDictionary *dic in self.selectwaxArray) {
                // 车型
                switch (self.selectCarType) {
                    case 1:
                    {
                        float price = [dic[@"p_price"] floatValue];
                        _totalPrice -= price;
                        
                        
                    }
                        break;
                        
                    default:
                    {
                        float price = [dic[@"p_price2"] floatValue];
                        _totalPrice -= price;
                    }
                        break;
                }
                
                [self.selectwaxArray removeObject:dic];
            }
            if (cell.tag == 22) {
                NSDictionary *dic = self.waxArr[indexPath.row];
                switch (self.selectCarType) {
                    case 1:
                    {
                        float price = [dic[@"p_price"] floatValue];
                        _totalPrice += price;
                        
                        
                    }
                        break;
                        
                    default:
                    {
                        float price = [dic[@"p_price2"] floatValue];
                        _totalPrice += price;
                    }
                        break;
                }
                [self.selectwaxArray addObject:dic];
                
            }
            
            if (self.selectwaxArray) {
                DLog(@"%@",self.selectwaxArray);
            }
            [_totalPriceLabel setText:[NSString stringWithFormat:@"%.2f",_totalPrice]];
            [self addAllPrice];
        }
            break;
      
            
            /**
             * @brief 不需要洗车选项
             * @detail 打蜡选项
             **/
        case 1:
        {
            AddOrderDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            
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
            
            DLog(@"%ld",cell.tag);
            if (cell.tag == 22) {
                [self.selectnoWashArr addObject:self.noWashArr[indexPath.row]];
                NSDictionary *dic = self.noWashArr[indexPath.row];
                switch (self.selectCarType) {
                    case 1:
                    {
                        float price = [dic[@"p_price"] floatValue];
                        _totalPrice += price;
                        
                        
                    }
                        break;
                        
                    default:
                    {
                        float price = [dic[@"p_price2"] floatValue];
                        _totalPrice += price;
                    }
                        break;
                }
                
                
            }else
            {
                if (self.selectnoWashArr) {
                    
                    for (NSDictionary *dic_1 in self.selectnoWashArr) {
                        if ([dic_1 isEqualToDictionary:self.noWashArr[indexPath.row]]) {
                            switch (self.selectCarType) {
                                case 1:
                                {
                                    float price = [dic_1[@"p_price"] floatValue];
                                    _totalPrice -= price;
                                    
                                    
                                }
                                    break;
                                    
                                default:
                                {
                                    float price = [dic_1[@"p_price2"] floatValue];
                                    _totalPrice -= price;
                                }
                                    break;
                            }
                            [_totalPriceLabel setText:[NSString stringWithFormat:@"%.2f",_totalPrice]];
                            [self.selectnoWashArr removeObject:dic_1];
                            DLog(@"%f   %@",_totalPrice,_totalPriceLabel.text);
                            DLog(@"%@",self.selectnoWashArr);
                            break;
                        }
                    }
                }
            }
            [_totalPriceLabel setText:[NSString stringWithFormat:@"%.2f",_totalPrice]];
            [self addAllPrice];
            DLog(@"%f   %@",_totalPrice,_totalPriceLabel.text);
            DLog(@"%@",self.selectnoWashArr);
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark action
- (IBAction)submit:(id)sender
{
    if (self.washType == 0 && _selectwaxArray.count > 0) {
        [SVProgressHUD showErrorWithStatus:@"您选择的项目必须选择洗车"];
        return;
    }
    NSMutableDictionary *selectDic = [NSMutableDictionary dictionary];
    [selectDic setObject:@(_totalPrice) forKey:@"price"];
    [selectDic setObject:_selectwaxArray forKey:@"wax"];
    [selectDic setObject:_selectnoWashArr forKey:@"noWash"];
    self.diyServers(selectDic);
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backAction:(id)sender
{
    if (self.washType == 0 && _selectwaxArray.count > 0) {
        [SVProgressHUD showErrorWithStatus:@"您选择的项目必须选择洗车"];
        return;
    }
    NSMutableDictionary *selectDic = [NSMutableDictionary dictionary];
    [selectDic setObject:@(_totalPrice) forKey:@"price"];
    [selectDic setObject:_selectwaxArray forKey:@"wax"];
    [selectDic setObject:_selectnoWashArr forKey:@"noWash"];
    self.diyServers(selectDic);
    [self.navigationController popViewControllerAnimated:YES];
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
