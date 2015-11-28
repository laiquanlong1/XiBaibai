//
//  DIYViewController.m
//  XBB
//
//  Created by Daniel on 15/9/11.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "DIYViewController.h"
#import "DiyModel.h"
#import <MJExtension.h>
#import "DIYTableViewCell.h"
#import "UIButton+WebCache.h"
#import "DMLineView.h"
#import "AddOrderViewController.h"
#import "UserObj.h"
#import "WebViewController.h"
#import "MyCarTableViewController.h"

@interface DIYViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrayTitle;  // 标题数组
@property (strong, nonatomic) NSMutableArray *arrData; // 数据数组
@property (strong, nonatomic) UIScrollView *scrollView; // 滚动视图
@property (strong, nonatomic) UITableView *tbView; // tableView
@property (strong, nonatomic) UIImageView *imgViewgogo; // img
@property (strong, nonatomic) UIView *mainview; // 主视图
@property (strong, nonatomic) UILabel *priceLbl; // 价格lab

@property (assign, nonatomic) NSInteger *base_id; // 基础id

@property (strong, nonatomic) NSMutableArray *dataArr, *traceArr, *windowArr, *unkeepArr, *diyArr, *baseArr, *baseBtnArr, *diyTitleBtnArr, *diyBtnArr, *diySelectedIdArr;


/**
 * @brief 基础套餐选择图片
 * @detail 基础套餐选择图片
 **/
@property (strong, nonatomic) UIImageView *baseSelectedLogoImgView, *diySelectedLogoImgView;

@property (copy, nonatomic) NSString *baseSelectededId;
@property (assign, nonatomic) double price;


/**
 * @brief 临时使用
 * @detail 临时使用
 **/
//@property (nonatomic,strong) UITextView *textView;

@end

@implementation DIYViewController

#pragma mark 初始化视图
/**
 * @brief 初始化视图
 * @detail 初始化视图
 **/
- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.naviTitle?self.naviTitle:@"美容";
    //返回
    UIImageView * img_view=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@icon_back.png"]];
    img_view.layer.masksToBounds=YES;
    img_view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fanhui)];
    [img_view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:img_view];
    
    // scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = kUIColorFromRGB(0xf6f5fa);
    [self.view addSubview:self.scrollView];
    
    
    // 设置选择图片初始化
    self.baseSelectedLogoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xbb_168"]];
    self.diySelectedLogoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xbb_168"]];
}


#pragma mark  初始化数据


- (void)initData{
    
    //  初始化标题数组
    self.arrayTitle = [[NSMutableArray alloc] initWithObjects:@"划痕修复",@"车窗套餐",@"养护", nil];
    
}

- (void)updateContentView {
    for (UIView *temp in self.scrollView.subviews) {
        [temp removeFromSuperview];
    }
    self.priceLbl.text = @"￥0";
    [self.baseBtnArr removeAllObjects];
    [self.diyTitleBtnArr removeAllObjects];
    [self.diyBtnArr removeAllObjects];
    if (!self.baseBtnArr)
        self.baseBtnArr = [NSMutableArray array];
    if (!self.diyTitleBtnArr)
        self.diyTitleBtnArr = [NSMutableArray array];
    if (!self.diyBtnArr)
        self.diyBtnArr = [NSMutableArray array];
    
    UIView *lastView;
    
    UILabel *washCarLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, self.view.frame.size.width - 30, 15)];
    washCarLbl.textColor = [UIColor lightGrayColor];
    washCarLbl.font = [UIFont systemFontOfSize:12];
    washCarLbl.text = @"洗车";
//    [self.scrollView addSubview:washCarLbl];
    lastView = washCarLbl;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame) + 5, self.view.frame.size.width, 0.5)];
    lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
//    [self.scrollView addSubview:lineView];
    lastView = lineView;
    for (int i = 0; i < self.baseArr.count; i++) {
        DiyModel *model = self.baseArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(0, CGRectGetMaxY(lastView.frame), self.view.frame.size.width, 43);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:model.p_name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:@selector(baseOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width - 40, btn.frame.size.height)];
        priceLbl.textAlignment = NSTextAlignmentRight;
        priceLbl.font = [UIFont systemFontOfSize:14];
        priceLbl.textColor = [UIColor orangeColor];
        priceLbl.text = [@"￥" stringByAppendingString:model.p_price];
        [btn addSubview:priceLbl];
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame), self.view.frame.size.width, 0.5)];
        lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
        [self.scrollView addSubview:lineView];
        lastView = lineView;
        [self.baseBtnArr addObject:btn];
    }
    
    UILabel *unkeepLbl = [[UILabel alloc] initWithFrame:CGRectMake(15,  15, self.view.frame.size.width - 30, 15)];
    unkeepLbl.textColor = [UIColor lightGrayColor];
    unkeepLbl.font = [UIFont systemFontOfSize:12];
    unkeepLbl.text = @"美容";
    [self.scrollView addSubview:unkeepLbl];
    lastView = unkeepLbl;
    
    if (self.baseArr.count) {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame) + 5, self.view.frame.size.width, 0.5)];
        lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
        [self.scrollView addSubview:lineView];
        lastView = lineView;
    }
    
    for (int i = 0; i < self.arrayTitle.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, CGRectGetMaxY(lastView.frame), self.view.frame.size.width, 43);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:self.arrayTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        btn.tag = i;
        [btn addTarget:self action:@selector(diyTitleBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame), self.view.frame.size.width, 0.5)];
        lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
        [self.scrollView addSubview:lineView];
        lastView = lineView;
        [self.diyTitleBtnArr addObject:btn];
    }
    
    if (self.arrayTitle.count) {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame) + 12, self.view.frame.size.width, 0.5)];
        lineView.backgroundColor = kUIColorFromRGB(0xdfdfdf);
        [self.scrollView addSubview:lineView];
        lastView = lineView;
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame), self.view.frame.size.width, self.view.frame.size.height)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:bottomView];
    CGFloat itemWidth = (self.view.frame.size.width - 50) * 0.25f;
    CGFloat itemHeight = itemWidth + 20;
    for (int i = 0; i < self.diyArr.count; i++) {
        DiyModel *model = self.diyArr[i];
        UIView *itemBackgroundView = [[UIView alloc] initWithFrame:CGRectMake((i % 4) * (itemWidth + 10) + 10, (i / 4) * (itemHeight + 10) + 10, itemWidth, itemHeight)];
//        itemBackgroundView.backgroundColor = [UIColor lightGrayColor];
        [bottomView addSubview:itemBackgroundView];
        
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemBtn addTarget:self action:@selector(diyItemOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        itemBtn.tag = i;
        itemBtn.backgroundColor = [UIColor clearColor];
        itemBtn.frame = CGRectMake(0, 0, itemBackgroundView.frame.size.width, itemBackgroundView.frame.size.width);
        [itemBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, model.p_wimg]] forState:UIControlStateNormal];
        [itemBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, model.p_ximg]] forState:UIControlStateSelected];
        [itemBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressDiyBtn:)]];
        itemBtn.tag = i;
        [itemBackgroundView addSubview:itemBtn];
        UILabel *itemTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, itemHeight - 20, itemWidth, 20)];
        itemTitleLbl.font = [UIFont systemFontOfSize:12];
        itemTitleLbl.text = model.p_name;
        itemTitleLbl.textAlignment = NSTextAlignmentCenter;
        [itemBackgroundView addSubview:itemTitleLbl];
        UILabel *itemPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, itemBtn.frame.size.height - 18, itemWidth, 18)];
        itemPriceLbl.font = [UIFont systemFontOfSize:12];
        itemPriceLbl.textAlignment = NSTextAlignmentCenter;
        itemPriceLbl.textColor = [UIColor orangeColor];
        itemPriceLbl.text = model.p_price;
        [itemBtn addSubview:itemPriceLbl];
        lastView = itemBackgroundView;
        [self.diyBtnArr addObject:itemBtn];
    }
    
    DMLineView *topLine = [[DMLineView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lastView.frame) + 15, self.view.frame.size.width - 30, 2)];
    topLine.lineWidth = 2;
    topLine.dotted = YES;
    topLine.dottedGap = 2;
    topLine.backgroundColor = [UIColor whiteColor];
    topLine.lineColor = kUIColorFromRGB(0xDFDFDF);
    [bottomView addSubview:topLine];
    
    UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(topLine.frame) + 15, topLine.frame.size.width, 15)];
    tipsLbl.font = [UIFont systemFontOfSize:13];
    tipsLbl.text = @"*长按进入详细介绍";
    [bottomView addSubview:tipsLbl];
    if (!self.priceLbl) {
        self.priceLbl = [[UILabel alloc] init];
        self.priceLbl.textAlignment = NSTextAlignmentRight;
        self.priceLbl.font = [UIFont systemFontOfSize:15];
        self.priceLbl.textColor = [UIColor orangeColor];
    }
    self.priceLbl.frame = CGRectMake(self.view.frame.size.width - 115, tipsLbl.frame.origin.y, 100, 15);
    [bottomView addSubview:self.priceLbl];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(15, CGRectGetMaxY(tipsLbl.frame) + 10, tipsLbl.frame.size.width, 43);
    doneBtn.backgroundColor = [UIColor orangeColor];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneBtn.layer.cornerRadius = 4;
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [doneBtn addTarget:self action:@selector(doneBtnOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:doneBtn];
    lastView = doneBtn;
    
    bottomView.frame = CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y, bottomView.frame.size.width, CGRectGetMaxY(lastView.frame) + 10);
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(bottomView.frame));
}

- (void)doneBtnOnTouch:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 没有车辆时alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"请设置默认车辆"]) {
        if (buttonIndex == 1) {
            MyCarTableViewController *carTableVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyCarTableViewController"];
            [self.navigationController pushViewController:carTableVC animated:YES];
        }
    }
}

#pragma mark 基础选择
- (void)baseOnTouch:(UIButton *)sender {
    for (UIButton *temp in self.baseBtnArr) {
        if (sender != temp) {
            temp.selected = NO;
        }
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        DiyModel *model = self.baseArr[sender.tag];
        self.baseSelectededId = model.diyId;
        self.baseSelectedLogoImgView.frame = CGRectMake(sender.frame.size.width - self.baseSelectedLogoImgView.frame.size.width - 15, sender.frame.size.height * 0.5 - self.baseSelectedLogoImgView.frame.size.height * 0.5, self.baseSelectedLogoImgView.frame.size.width, self.baseSelectedLogoImgView.frame.size.height);
        [sender addSubview:self.baseSelectedLogoImgView];
        self.price += [model.p_price floatValue];
    } else {
        self.baseSelectededId = @"";
        [self.baseSelectedLogoImgView removeFromSuperview];
    }
  
    NSLog(@"%@", self.baseSelectededId);
    
    [self calculatePrice];
}

- (void)handleLongPressDiyBtn:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIButton *btn = (UIButton *)sender.view;
        DiyModel *model = [self.diyArr objectAtIndex:btn.tag];
        WebViewController *viewcontroller = [[WebViewController alloc] init];
        viewcontroller.title = @"DIY产品";
        viewcontroller.urlString = [NSString stringWithFormat:@"http://xbbwx.marnow.com/Weixin/Diy/index?p_id=%@",model.diyId];//@"https://www.baidu.com";
     
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
}

- (void)diyTitleBtnOnTouch:(UIButton *)sender {
    [self.diySelectedIdArr removeAllObjects];
    if (!self.diySelectedIdArr) {
        self.diySelectedIdArr = [NSMutableArray array];
    }
    for (UIButton *temp in self.diyTitleBtnArr) {
        if (sender != temp) {
            temp.selected = NO;
        }
    }
    sender.selected = !sender.selected;
    for (UIButton *temp in self.diyBtnArr) {
        temp.selected = NO;
    }
    if (sender.selected) {
        self.diySelectedLogoImgView.frame = CGRectMake(sender.frame.size.width - self.diySelectedLogoImgView.frame.size.width - 15, sender.frame.size.height * 0.5 - self.diySelectedLogoImgView.frame.size.height * 0.5, self.diySelectedLogoImgView.frame.size.width, self.diySelectedLogoImgView.frame.size.height);
        [sender addSubview:self.diySelectedLogoImgView];
        switch (sender.tag) {
            case 0: {
                for (DiyModel *tempInTrace in self.traceArr) {
                    for (DiyModel *tempInDiy in self.diyArr) {
                        if (tempInDiy == tempInTrace) {
                            UIButton *btn = [self.diyBtnArr objectAtIndex:[self.diyArr indexOfObject:tempInDiy]];
                            btn.selected = YES;
                            [self.diySelectedIdArr addObject:tempInDiy.diyId];
                        }
                    }
                }
            }
                break;
            case 1: {
                for (DiyModel *tempInTrace in self.windowArr) {
                    for (DiyModel *tempInDiy in self.diyArr) {
                        if (tempInDiy == tempInTrace) {
                            UIButton *btn = [self.diyBtnArr objectAtIndex:[self.diyArr indexOfObject:tempInDiy]];
                            btn.selected = YES;
                            [self.diySelectedIdArr addObject:tempInDiy.diyId];
                        }
                    }
                }
            }
                break;
            case 2: {
                for (DiyModel *tempInTrace in self.unkeepArr) {
                    for (DiyModel *tempInDiy in self.diyArr) {
                        if (tempInDiy == tempInTrace) {
                            UIButton *btn = [self.diyBtnArr objectAtIndex:[self.diyArr indexOfObject:tempInDiy]];
                            btn.selected = YES;
                            [self.diySelectedIdArr addObject:tempInDiy.diyId];
                        }
                    }
                }
            }
                break;
            default:
                break;
        }
    } else {
        [self.diySelectedLogoImgView removeFromSuperview];
    }
    NSLog(@"%@", self.diySelectedIdArr);
    [self calculatePrice];
}

- (void)diyItemOnTouch:(UIButton *)sender {
    [self.diySelectedLogoImgView removeFromSuperview];
    for (UIButton *temp in self.diyTitleBtnArr) {
        temp.selected = NO;
    }
    sender.selected = !sender.selected;
    if (!self.diySelectedIdArr) {
        self.diySelectedIdArr = [NSMutableArray array];
    }
    if (sender.selected) {
        DiyModel *model = [self.diyArr objectAtIndex:sender.tag];
        [self.diySelectedIdArr addObject:model.diyId];
    } else {
        DiyModel *model = [self.diyArr objectAtIndex:sender.tag];
        [self.diySelectedIdArr removeObject:model.diyId];
    }
    NSLog(@"%@", self.diySelectedIdArr);
    [self calculatePrice];
}

- (void)calculatePrice {
    self.price = 0;
    for (UIButton *baseBtn in self.baseBtnArr) {
        if (baseBtn.selected) {
            DiyModel *model = [self.baseArr objectAtIndex:[self.baseBtnArr indexOfObject:baseBtn]];
            self.price += [model.p_price doubleValue];
        }
    }
    for (UIButton *diyBtn in self.diyBtnArr) {
        if (diyBtn.selected) {
            DiyModel *model = [self.diyArr objectAtIndex:[self.diyBtnArr indexOfObject:diyBtn]];
            self.price += [model.p_price doubleValue];
        }
    }
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@", @(self.price)];
}

- (void)fetchDiyFromWeb {
    [SVProgressHUD show];  // 展示进度条
    [NetworkHelper postWithAPI:API_selectDIY parameter:nil successBlock:^(id response) {
        NSDictionary *dic = [response copy];
        
        NSLog(@"＝＝＝＝＝＝＝ %@",dic);
        if ([response[@"code"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            self.dataArr = [NSMutableArray array];
            self.traceArr = [NSMutableArray array];
            self.windowArr = [NSMutableArray array];
            self.unkeepArr = [NSMutableArray array];
            self.baseArr = [NSMutableArray array];
            self.diyArr = [NSMutableArray array];
            NSArray *result = response[@"result"][@"list"];
     
//            for (NSDictionary *dic  in result) {
//                NSString *string = dic[@"p_name"];
//                NSString *st = dic[@"id"];
//                 NSLog(@"%@ ==== %@ \n %@\n %@",st,string,dic[@"p_info"],dic[@"p_info_detail"]);
//            }
//           
////            NSLog(@"%@",result[@""])
//            
//            NSArray *arr = response[@"result"][@"group"];
//            for (NSDictionary *dic in arr) {
//                 NSLog(@"美容===  %@   %@",dic[@"pro_ids"],dic[@"groupName"]);
//            }

            [DiyModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"diyId": @"id"};
            }];
//            NSArray *group1IdArr = response[@"result"][@"group"][0][@"pro_ids"];
            NSMutableArray *group1IdArr = [NSMutableArray array];
            for (NSNumber *temp in response[@"result"][@"group"][0][@"pro_ids"]) {
                [group1IdArr addObject:[NSString stringWithFormat:@"%@",temp]];
            }
            NSMutableArray *group2IdArr = [NSMutableArray array];
            for (NSNumber *temp in response[@"result"][@"group"][1][@"pro_ids"]) {
                [group2IdArr addObject:[NSString stringWithFormat:@"%@",temp]];
            }
            NSMutableArray *group3IdArr = [NSMutableArray array];
            for (NSNumber *temp in response[@"result"][@"group"][2][@"pro_ids"]) {
                [group3IdArr addObject:[NSString stringWithFormat:@"%@",temp]];
            }
//            NSArray *group2IdArr = response[@"result"][@"group"][1][@"pro_ids"];
//            NSArray *group3IdArr = response[@"result"][@"group"][2][@"pro_ids"];

            for (NSDictionary *temp in result) {
                DiyModel *model = [DiyModel objectWithKeyValues:temp];
                [self.dataArr addObject:model];
                if ([model.p_type_t integerValue] == 0) {//基础服务
//                    [self.baseArr addObject:model];
                } else if ([model.p_type_t integerValue] == 5) {//diy服务
                    [self.diyArr addObject:model];
                    if ([group1IdArr containsObject:model.diyId]) {
                        [self.traceArr addObject:model];
                    }
                    if ([group2IdArr containsObject:model.diyId]) {
                        [self.windowArr addObject:model];
                    }
                    if ([group3IdArr containsObject:model.diyId]) {
                        [self.unkeepArr addObject:model];
                    }
                }
            }
            [self updateContentView];
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity = @"cell";
    DIYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell = [[DIYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    [CustamViewController  setUpCellLayoutMargins:cell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.labTitle.text = [self.arrayTitle objectAtIndex:indexPath.row];
  
    
   // cell.imgView.image = [UIImage imageNamed:@"xbb_diygogounselected"];
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    DIYTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   // cell.imageView.image = [UIImage imageNamed:@"xbb_diygogoselected"];
    cell.imgView.image = [UIImage imageNamed:@"xbb_diygogoselected"];
    cell.labTitle.textColor = kUIColorFromRGB(0xdc3731);
//    self.imgViewgogo = [UIImageView new];
//    self.imgViewgogo.image =[UIImage imageNamed:@"xbb_diygogoselected"];
//    [cell.contentView addSubview:self.imgViewgogo];
//    [self.imgViewgogo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(cell.contentView.mas_right).mas_offset(-15);
//        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
//    }];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self.imgViewgogo removeFromSuperview];
    DIYTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imgView.image = [UIImage imageNamed:@""];
    cell.labTitle.textColor = kUIColorFromRGB(0xb3b3b3);
}




- (void)viewDidLoad {
    [super viewDidLoad];
    DLog(@"%ld",self.washType);
    
    
    
    // Do any additional setup after loading the view.
    [self initView]; // 初始化视图
    [self initData]; // 初始化标题数组
//    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:self.textView];
    
    [self fetchDiyFromWeb];
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
