//
//  OrderDetailCompleteViewController.m
//  XBB
//
//  Created by Apple on 15/9/5.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "OrderDetailCompleteViewController.h"
#import "DMLineView.h"
#import "OrderTopView.h"
#import "StarView.h"
#import <UIImage+BlurredFrame.h>
#import "CommentViewController.h"
#import "MWPhotoBrowser.h"

@interface OrderDetailCompleteViewController () <MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) NSDictionary *orderInfo;
@property (strong, nonatomic) NSArray *beforeMWPhotoArr, *afterMWPhotoArr;

@end

@implementation OrderDetailCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self initView];
    [self fetchOrderDetailFromWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backOnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchOrderDetailFromWeb {
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:OrderSelect_detail_API parameter:@{@"order_id":self.order_id} successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            self.orderInfo = response[@"result"];
            [self initView];
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

- (void)initView {
    self.contentScrollView.backgroundColor = kUIColorFromRGB(0xF6F5FA);
    UIView *topBackView = [UIView new];
    topBackView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:topBackView];
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.right.offset(0);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(108 + 174);
    }];
    OrderTopView *orderTop = [OrderTopView orderTopView];
    [topBackView addSubview:orderTop];
    [orderTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.offset(5);
        make.right.offset(-5);
        make.height.mas_equalTo(orderTop.frame.size.height);
    }];

    orderTop.titleLabel.text = _orderInfo[@"order_name"];
    orderTop.priceLabel.text = [NSString stringWithFormat:@"%@", _orderInfo[@"total_price"]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY.MM.dd HH:mm";
    orderTop.dateLabel.text = [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_orderInfo[@"pay_time"] integerValue]]];
    orderTop.addressLabel.text = _orderInfo[@"location"];
    orderTop.modelLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _orderInfo[@"c_brand"], _orderInfo[@"c_color"], _orderInfo[@"c_plate_num"]];
    orderTop.orderNO.text = _orderInfo[@"order_num"];
    NSString *str;
    switch ([_orderInfo[@"order_state"] integerValue]) {
        case 0:
            str = @"未付款";
            break;
        case 1:
            str = @"派单中";
            break;
        case 2:
            str = @"已派单";
            break;
        case 3:
            str = @"在路上";
            break;
        case 4:
            str = @"进行中";
            break;
        case 5:
            str = @"未评价";
            break;
        case 6:
            str = @"已评价";
            break;
        case 7:
            str = @"已取消";
            break;
        default:
            str = @"未知";
            break;
    }
    orderTop.orderState.text = str;
    
    
    DMLineView *topLine = [DMLineView new];
    topLine.lineWidth = 1;
    topLine.dotted = YES;
    topLine.dottedGap = 2;
    topLine.backgroundColor = [UIColor whiteColor];
    topLine.lineColor = kUIColorFromRGB(0xDFDFDF);
    [topBackView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderTop.mas_bottom).offset(0);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *payTypeTipsLbl = [UILabel new];
    payTypeTipsLbl.font = [UIFont systemFontOfSize:14];
    payTypeTipsLbl.text = @"支付方式：";
    payTypeTipsLbl.textColor = kUIColorFromRGB(0xACACAC);
    [topBackView addSubview:payTypeTipsLbl];
    [payTypeTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLine.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
    }];
    if ([_orderInfo[@"pay_type"] integerValue] == 0) {
        payTypeTipsLbl.text = @"支付方式：支付宝";
    }
    
    UILabel *payDateTipsLbl = [UILabel new];
    payDateTipsLbl.font = payTypeTipsLbl.font;
    payDateTipsLbl.textColor = payTypeTipsLbl.textColor;
    payDateTipsLbl.text = @"支付时间：";
    [topBackView addSubview:payDateTipsLbl];
    [payDateTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payTypeTipsLbl);
        make.top.equalTo(payTypeTipsLbl.mas_bottom).offset(10);
    }];
    UILabel *payDateLbl = [UILabel new];
    payDateLbl.font = payDateTipsLbl.font;
    payDateLbl.text = [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_orderInfo[@"pay_time"] integerValue]]];
    [topBackView addSubview:payDateLbl];
    [payDateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payDateTipsLbl.mas_right).offset(3);
        make.top.equalTo(payDateTipsLbl);
    }];
    
    UILabel *payMoneyTipsLbl = [UILabel new];
    payMoneyTipsLbl.font = payTypeTipsLbl.font;
    payMoneyTipsLbl.textColor = payTypeTipsLbl.textColor;
    payMoneyTipsLbl.text = @"支付金额：";
    [topBackView addSubview:payMoneyTipsLbl];
    [payMoneyTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payDateTipsLbl);
        make.top.equalTo(payDateTipsLbl.mas_bottom).offset(10);
    }];
    UILabel *payMoneyLbl = [UILabel new];
    payMoneyLbl.font = payDateTipsLbl.font;
    payMoneyLbl.textColor = kUIColorFromRGB(0xE05A58);
    payMoneyLbl.text = [NSString stringWithFormat:@"%@", _orderInfo[@"pay_num"]];
    [topBackView addSubview:payMoneyLbl];
    [payMoneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payMoneyTipsLbl.mas_right).offset(3);
        make.top.equalTo(payMoneyTipsLbl);
    }];
    
    if([_orderInfo[@"pay_num"] integerValue] == 0){
        payMoneyLbl.text = @"未支付";
        [payDateLbl removeFromSuperview];
    }
    
    [topBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(payMoneyLbl.mas_bottom).offset(20);
    }];
    
    UIView *topTopLine = [UIView new];
    topTopLine.backgroundColor = kUIColorFromRGB(0xDFDFDF);
    [topBackView addSubview:topTopLine];
    [topTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    UIView *topBottomLine = [UIView new];
    topBottomLine.backgroundColor = kUIColorFromRGB(0xDFDFDF);
    [topBackView addSubview:topBottomLine];
    [topBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *middleBackView = [UIView new];
    middleBackView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:middleBackView];
    [middleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(topBackView);
        make.top.equalTo(topBackView.mas_bottom).offset(15);
        make.left.right.equalTo(topBackView);
    }];

    UIImageView *avatarImageView = [UIImageView new];
    avatarImageView.clipsToBounds = YES;
    avatarImageView.layer.cornerRadius = 30;
    avatarImageView.image = [UIImage imageNamed:@"xi1"];
    [middleBackView addSubview:avatarImageView];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.left.offset(15);
    }];
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, _orderInfo[@"emp_img"]]]];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.text = _orderInfo[@"emp_name"];
    [middleBackView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarImageView.mas_right).offset(10);
        make.bottom.equalTo(avatarImageView.mas_centerY);
    }];
    
    UILabel *summaryLabel = [UILabel new];
    summaryLabel.font = nameLabel.font;
    summaryLabel.text = _orderInfo[@"emp_num"];
    [middleBackView addSubview:summaryLabel];
    [summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(avatarImageView.mas_centerY);
    }];
    
    UILabel *scoreLabel = [UILabel new];
    scoreLabel.font = [UIFont systemFontOfSize:14];
    scoreLabel.textAlignment = NSTextAlignmentRight;
    scoreLabel.text = [NSString stringWithFormat:@"%@分", _orderInfo[@"star"]];
    [middleBackView addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.centerY.equalTo(avatarImageView);
    }];

    StarView *starView = [StarView starView];
    starView.score = [_orderInfo[@"star"] floatValue];
    [middleBackView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(95, 14));
        make.centerY.equalTo(scoreLabel);
        make.right.equalTo(scoreLabel.mas_left).offset(-5);
    }];
    
    [nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-155);
    }];
    [summaryLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-155);
    }];
    
    DMLineView *middleDotted1Line = [DMLineView new];
    middleDotted1Line.backgroundColor = [UIColor whiteColor];
    middleDotted1Line.lineColor = kUIColorFromRGB(0xDFDFDF);
    middleDotted1Line.lineWidth = 1;
    middleDotted1Line.dotted = YES;
    middleDotted1Line.dottedGap = 2;
    [middleBackView addSubview:middleDotted1Line];
    [middleDotted1Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.mas_equalTo(1);
        make.top.equalTo(avatarImageView.mas_bottom).offset(15);
    }];
    
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imgView = [UIImageView new];
        imgView.clipsToBounds = YES;
        imgView.layer.borderColor = kUIColorFromRGB(0xDFDFDF).CGColor;
        imgView.backgroundColor = [UIColor whiteColor];
        imgView.layer.borderWidth = 0.5f;
        [middleBackView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15 + i * 2);
            make.top.equalTo(middleDotted1Line.mas_bottom).offset(15 + 2 * (3 - i));
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        UIImageView *imgRightView = [UIImageView new];
        imgRightView.clipsToBounds = YES;
        imgRightView.layer.borderColor = kUIColorFromRGB(0xDFDFDF).CGColor;
        imgRightView.backgroundColor = [UIColor whiteColor];
        imgRightView.layer.borderWidth = 0.5f;
        [middleBackView addSubview:imgRightView];
        [imgRightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-(15 + i * 2));
            make.top.equalTo(middleDotted1Line.mas_bottom).offset(15 + 2 * (3 - i));
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        if (i == 2) {
            imgView.image = [UIImage imageNamed:@"1@icon_27"];
            imgView.image = [imgView.image applyLightEffectAtFrame:CGRectMake(0, imgView.image.size.height * 0.75, imgView.image.size.width, 25 * 0.25)];
            UILabel *beforeLable = [UILabel new];
            beforeLable.font = [UIFont systemFontOfSize:13];
            beforeLable.textAlignment = NSTextAlignmentCenter;
            beforeLable.text = @"处理前";
            [imgView addSubview:beforeLable];
            [beforeLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.offset(0);
                make.height.mas_equalTo(25);
            }];
            __weak UIImageView *tempImgLeft = imgView;
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beforeImageOnTouch:)]];
            imgView.userInteractionEnabled = YES;
            [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, [[[NSString stringWithFormat:@"%@", _orderInfo[@"car_wash_before_img"]] componentsSeparatedByString:@","] firstObject]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                tempImgLeft.image = [image applyLightEffectAtFrame:CGRectMake(0, image.size.height * 0.75, image.size.width, image.size.height * 0.25)];
            }];
            
            imgRightView.image = [UIImage imageNamed:@"1@icon_27"];
            imgRightView.image = [imgRightView.image applyLightEffectAtFrame:CGRectMake(0, imgRightView.image.size.height * 0.75, imgRightView.image.size.width, 25 * 0.25)];
            UILabel *afterLable = [UILabel new];
            afterLable.font = [UIFont systemFontOfSize:13];
            afterLable.textAlignment = NSTextAlignmentCenter;
            afterLable.text = @"处理后";
            [imgRightView addSubview:afterLable];
            [imgRightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(afterImageOnTouch:)]];
            imgRightView.userInteractionEnabled = YES;
            [afterLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.offset(0);
                make.height.mas_equalTo(25);
            }];
            __weak UIImageView *tempImgRight = imgRightView;
            [imgRightView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, [[[NSString stringWithFormat:@"%@", _orderInfo[@"car_wash_before_img"]] componentsSeparatedByString:@","] firstObject]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                tempImgRight.image = [image applyLightEffectAtFrame:CGRectMake(0, image.size.height * 0.75, image.size.width, image.size.height * 0.25)];
            }];
            
            UILabel *vsLabel = [UILabel new];
            vsLabel.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
            vsLabel.textColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1];
            vsLabel.textAlignment = NSTextAlignmentCenter;
            vsLabel.text = @"VS";
            vsLabel.clipsToBounds = YES;
            vsLabel.layer.cornerRadius = 20;
            [middleBackView addSubview:vsLabel];
            [vsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.centerX.equalTo(middleBackView);
                make.centerY.equalTo(imgView);
            }];
        }
    }
    
    UILabel *suggestLabel = [UILabel new];
    suggestLabel.font = [UIFont systemFontOfSize:14];
    suggestLabel.textColor = [UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1];
    suggestLabel.text = @"建议";
    [middleBackView addSubview:suggestLabel];
    [suggestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(middleDotted1Line.mas_bottom).offset(140);
    }];
    DMLineView *suggestDottedLine = [DMLineView new];
    suggestDottedLine.backgroundColor = [UIColor whiteColor];
    suggestDottedLine.lineColor = kUIColorFromRGB(0xDFDFDF);
    suggestDottedLine.lineWidth = 1;
    suggestDottedLine.dotted = YES;
    suggestDottedLine.dottedGap = 2;
    [middleBackView addSubview:suggestDottedLine];
    [suggestDottedLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(suggestLabel.mas_right).offset(10);
        make.right.offset(-15);
        make.height.mas_equalTo(1);
        make.centerY.equalTo(suggestLabel);
    }];
    UIView *lastView;
    
    NSArray *adviceArr = [_orderInfo[@"list_ad"] isKindOfClass:[NSArray class]]? _orderInfo[@"list_ad"]: nil;
    NSArray *proposalArr = [_orderInfo[@"list_pr"] isKindOfClass:[NSArray class]]? _orderInfo[@"list_pr"]: nil;
    for (int i = 0; i < adviceArr.count; i ++) {
        NSDictionary *dic = adviceArr[i];
        UIView *background = [UIView new];
        background.backgroundColor = [UIColor clearColor];
        [middleBackView addSubview:background];
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            if (lastView)
                make.top.equalTo(lastView.mas_bottom).offset(15);
            else
                make.top.equalTo(suggestLabel.mas_bottom).offset(15);
        }];
        UIImageView *logoImgView = [UIImageView new];
        logoImgView.clipsToBounds = YES;
        logoImgView.layer.cornerRadius = 8;
        [logoImgView sd_setImageWithURL:ImgURLWithImgName(dic[@"ad_img"])];
        [background addSubview:logoImgView];
        [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(0);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];
        UILabel *titleLbl = [UILabel new];
        titleLbl.font = [UIFont systemFontOfSize:15];
        titleLbl.text = dic[@"ad_title"];
        [background addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(logoImgView.mas_right).offset(5);
            make.top.equalTo(logoImgView);
            make.right.offset(0);
        }];
        UILabel *summaryLbl = [UILabel new];
        summaryLbl.font = [UIFont systemFontOfSize:13];
        summaryLbl.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        summaryLbl.text = dic[@"ad_content"];
        summaryLbl.numberOfLines = 2;
        [background addSubview:summaryLbl];
        [summaryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLbl);
            make.right.equalTo(titleLbl);
            make.top.equalTo(titleLbl.mas_bottom).offset(5);
        }];
        [background mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(logoImgView.mas_bottom);
        }];
        
        lastView = background;
    }
    if (adviceArr.count == 0)
        lastView = suggestDottedLine;
    
    UILabel *hintLabel = [UILabel new];
    hintLabel.font = [UIFont systemFontOfSize:14];
    hintLabel.textColor = [UIColor colorWithRed:0.86 green:0.22 blue:0.2 alpha:1];
    hintLabel.text = @"温馨提示";
    [middleBackView addSubview:hintLabel];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(lastView.mas_bottom).offset(20);
    }];
    DMLineView *hintDottedLine = [DMLineView new];
    hintDottedLine.backgroundColor = [UIColor whiteColor];
    hintDottedLine.lineColor = [UIColor colorWithRed:0.86 green:0.22 blue:0.2 alpha:1];
    hintDottedLine.lineWidth = 1;
    hintDottedLine.dotted = YES;
    hintDottedLine.dottedGap = 2;
    [middleBackView addSubview:hintDottedLine];
    [hintDottedLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hintLabel.mas_right).offset(10);
        make.right.offset(-15);
        make.height.mas_equalTo(1);
        make.centerY.equalTo(hintLabel);
    }];
    lastView = nil;
    for (int i = 0; i < proposalArr.count; i ++) {
        NSDictionary *dic = proposalArr[i];
        UIView *background = [UIView new];
        background.backgroundColor = [UIColor clearColor];
        [middleBackView addSubview:background];
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            if (lastView)
                make.top.equalTo(lastView.mas_bottom).offset(15);
            else
                make.top.equalTo(hintLabel.mas_bottom).offset(15);
        }];
        UIImageView *logoImgView = [UIImageView new];
        logoImgView.clipsToBounds = YES;
        logoImgView.layer.cornerRadius = 22.5f;
        [logoImgView sd_setImageWithURL:ImgURLWithImgName(dic[@"pr_img"])];
        [background addSubview:logoImgView];
        [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(0);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];

        UILabel *summaryLbl = [UILabel new];
        summaryLbl.font = [UIFont systemFontOfSize:13];
        summaryLbl.text = dic[@"pr_content"];
        summaryLbl.numberOfLines = 3;
        [background addSubview:summaryLbl];
        [summaryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(logoImgView.mas_right).offset(5);
            make.centerY.equalTo(logoImgView);
            make.right.offset(0);
        }];
        [background mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(logoImgView.mas_bottom);
        }];
        
        lastView = background;
    }
    if (proposalArr.count == 0)
        lastView = hintDottedLine;
    
    [middleBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(20);
    }];
    
    UIView *middleTopLine = [UIView new];
    middleTopLine.backgroundColor = kUIColorFromRGB(0xDFDFDF);
    [middleBackView addSubview:middleTopLine];
    [middleTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.mas_equalTo(0.5f);
    }];
    UIView *middleBottomLine = [UIView new];
    middleBottomLine.backgroundColor = kUIColorFromRGB(0xDFDFDF);
    [middleBackView addSubview:middleBottomLine];
    [middleBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_equalTo(0.5f);
    }];
    
    UIView *bottomBackView = [UIView new];
    bottomBackView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:bottomBackView];
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(middleBackView);
        make.top.equalTo(middleBackView.mas_bottom).offset(15);
        make.bottom.offset(0);
    }];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setTitle:@"评价" forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commentButton.backgroundColor = [UIColor colorWithRed:0.15 green:0.76 blue:0.65 alpha:1];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [commentButton addTarget:self action:@selector(commentOnTouch) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackView addSubview:commentButton];
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.mas_equalTo(43);
    }];
    [bottomBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(commentButton.mas_bottom);
    }];
    
    if([_orderInfo[@"order_reg_id"] integerValue] == 0){
        NSLog(@"%ld",[_orderInfo[@"order_reg_id"] integerValue]);
        [middleBackView removeFromSuperview];
    }
}

- (void)commentOnTouch {
    CommentViewController *viewcontroller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CommentViewController"];
    [viewcontroller setValue:_orderInfo[@"emp_name"] forKey:@"emp_name"];
    [viewcontroller setValue:_orderInfo[@"emp_img"] forKey:@"emp_img"];
    [viewcontroller setValue:_orderInfo[@"emp_num"] forKey:@"emp_num"];
    [viewcontroller setValue:_orderInfo[@"order_reg_id"] forKey:@"emp_id"];
    [viewcontroller setValue:_orderInfo[@"id"] forKey:@"order_id"];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (void)afterImageOnTouch:(UITapGestureRecognizer *)sender {
    NSArray *imgNameArr = [_orderInfo[@"car_wash_end_img"] componentsSeparatedByString:@","];
    if (imgNameArr.count) {
        NSMutableArray *photos = [NSMutableArray array];
        for (NSString *temp in imgNameArr) {
            MWPhoto *photo = [[MWPhoto alloc] initWithURL:ImgURLWithImgName(temp)];
            [photos addObject:photo];
        }
        self.afterMWPhotoArr = [NSArray arrayWithArray:photos];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.view.tag = 1;
        [self.navigationController pushViewController:browser animated:YES];
    }
    
}

- (void)beforeImageOnTouch:(UITapGestureRecognizer *)sender {
    NSArray *imgNameArr = [_orderInfo[@"car_wash_before_img"] componentsSeparatedByString:@","];
    if (imgNameArr.count) {
        NSMutableArray *photos = [NSMutableArray array];
        for (NSString *temp in imgNameArr) {
            MWPhoto *photo = [[MWPhoto alloc] initWithURL:ImgURLWithImgName(temp)];
            [photos addObject:photo];
        }
        self.beforeMWPhotoArr = [NSArray arrayWithArray:photos];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        [self.navigationController pushViewController:browser animated:YES];
    }
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if (photoBrowser.view.tag == 1) {
        return self.afterMWPhotoArr.count;
    } else {
        return self.beforeMWPhotoArr.count;
    }
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (photoBrowser.view.tag == 1) {
        return self.afterMWPhotoArr[index];
    } else {
        return self.beforeMWPhotoArr[index];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
