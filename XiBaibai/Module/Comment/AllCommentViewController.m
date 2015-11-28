//
//  AllCommentViewController.m
//  XBB
//
//  Created by Daniel on 15/9/2.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "AllCommentViewController.h"
#import "AllCommentTableViewCell.h"
#import "StarView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CommentModel.h"
#import "UserObj.h"
#import <MJExtension.h>

@interface AllCommentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tbView;
@property (nonatomic, assign) BOOL cellHeightCacheEnabled;
@property (strong, nonatomic) NSMutableArray *commentArr;

@end

@implementation AllCommentViewController

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**
     * @brief 标题
     * @detail 标题设置
     **/
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"全部评价";
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
    
    /**
     * @brief 展示评价内容的表视图
     * @detail 设置基本表视图
     **/
    self.tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    self.tbView.backgroundColor = kUIColorFromRGB(0xf6f5fa);
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tbView.estimatedRowHeight = 230;
    self.tbView.fd_debugLogEnabled = YES;
    self.cellHeightCacheEnabled = YES;
    
//    [self.tbView registerClass:[AllCommentTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tbView registerNib:[UINib nibWithNibName:@"AllCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tbView];
//    [self buildTestDataThen:^{
//        self.feedEntitySections = @[].mutableCopy;
//        [self.feedEntitySections addObject:self.prototypeEntitiesFromJSON.mutableCopy];
//        [self.tbView reloadData];
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self fetchCommentFromWeb];
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchCommentFromWeb {
    [NetworkHelper postWithAPI:API_CommentSelect parameter:@{@"uid": [UserObj shareInstance].uid} successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            if (!self.commentArr) {
                self.commentArr = [NSMutableArray array];
            } else {
                [self.commentArr removeAllObjects];
            }
            NSArray *resultArr = response[@"result"];
            [CommentModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"commentId": @"id"};
            }];
            for (NSDictionary *temp in resultArr) {
                [self.commentArr addObject:[CommentModel objectWithKeyValues:temp]];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        [self.tbView reloadData];
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}


#pragma mark - self.tbviewdelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return self.feedEntitySections.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.feedEntitySections[section] count];
    return self.commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[AllCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(AllCommentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.fd_enforceFrameLayout = YES; // Enable to use "-sizeThatFits:"
    CommentModel *model = self.commentArr[indexPath.row];
    
    [cell.imgHeadView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, model.emp_img]]];
    cell.labName.text = model.emp_name;
    cell.labNumber.text = model.emp_num;
    cell.labFen.text = [NSString stringWithFormat:@"%@分", @(model.star)];
    cell.starView.score = model.star;
    NSString *str = model.comment;
    // cell.labContent.text = str;
    //调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:5.0];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    cell.labContent.attributedText = attributedString;
    
    cell.labCar.text = [NSString stringWithFormat:@"%@  %@  %@", model.c_plate_num, model.c_color, model.c_brand];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY.MM.dd HH:mm";
    cell.labTime.text = [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.comment_time]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    tableView
    if (self.cellHeightCacheEnabled) {
        CGFloat height = [tableView fd_heightForCellWithIdentifier:@"cell" cacheByIndexPath:indexPath configuration:^(AllCommentTableViewCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
        return height;
    } else {
        return [tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(AllCommentTableViewCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
}



@end
