//
//  FacialDIYTableViewCell.m
//  XiBaibai
//
//  Created by HoTia on 15/11/9.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "FacialDIYTableViewCell.h"
#import "XBBDIYImageView.h"


@interface FacialDIYTableViewCell ()
{
    UILabel *label;
    UILabel *priceLabel;
    NSArray *_dataArr;
    NSInteger _washType; // 洗车类型
    
}

@end

@implementation FacialDIYTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addNotifaction];
    }
    return self;
}

#pragma mark 添加通知通知
- (void)addNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(changeSelect:) name:NotificationDIYCange object:nil];
}



// 改变图片
- (void)changeSelect:(NSNotification *)sender
{
    NSArray *idss = sender.userInfo[@"p_ids"];
    NSArray *subViews = self.contentView.subviews;
    for (UIView *view in subViews) {
        NSArray *sub = view.subviews;
        for (id vi in sub) {
            if ([vi isKindOfClass:[XBBDIYImageView class]]) {
                XBBDIYImageView *imageView = vi;
                // 改变图片
                NSDictionary *dic = _dataArr[view.tag];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, dic[@"p_wimg"]]]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    imageView.image = image;
                }];
            }
        }
    }
    
    DLog(@"%@",idss);
    if (idss.count < 1) {
        return;
    }

    for (NSDictionary *dic_one in idss) {
        // id获取
        NSInteger id_one = [dic_one[@"id"] integerValue];
        
        NSArray *subViews = self.contentView.subviews;
        
        for (UIView *view in subViews) {
            NSArray *subVs = view.subviews;
            for (id vi in subVs) {
                if ([vi isKindOfClass:[XBBDIYImageView class]]) {
                    XBBDIYImageView *imageView = vi;
                    
                    if (imageView.tag == id_one) {
                        imageView.isSelect = 2;
                        // 改变图片
                        NSDictionary *dic = _dataArr[view.tag];
                        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, dic[@"p_ximg"]]]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            imageView.image = image;
                        }];
                    }
                }
            }
        }
        
    }

}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationDIYCange object:nil];

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellIncon:(NSArray *)idss
{
    //    @[@[@{}]];
    DLog(@"%@",idss);
    if (idss.count < 1) {
        return;
    }
    for (NSDictionary *dic_one in idss) {
        // id获取
        NSInteger id_one = [dic_one[@"id"] integerValue];
        
        NSArray *subViews = self.contentView.subviews;
        
        for (UIView *view in subViews) {
            NSArray *subVs = view.subviews;
            for (id vi in subVs) {
                if ([vi isKindOfClass:[XBBDIYImageView class]]) {
                    XBBDIYImageView *imageView = vi;
                    if (imageView.tag == id_one) {
                        // 改变图片
                        NSDictionary *dic = _dataArr[view.tag];
                        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, dic[@"p_ximg"]]]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            imageView.image = image;
                            imageView.isSelect = 1;
                        }];
                    }
                }
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
//    
//    NSMutableArray *ids = [NSMutableArray array];
//    
//    for (NSDictionary *dic_oo in idss) {
//        [ids addObject:dic_oo];
//    }
//    if (_dataArr.count<1) {
//        return;
//    }
//    if (self.contentView.subviews.count<1) {
//        return;
//    }
//    for (int i = 0; i < _dataArr.count; i ++) {
//        UIView *view = self.contentView.subviews[i];
//        
//        
//        
//        //        DLog(@"%ld",view.tag);
//        for (id subView in view.subviews) {
//            if ([subView isKindOfClass:[XBBDIYImageView class]]) {
//                XBBDIYImageView *imageView = subView;
//                
//                NSDictionary *dic = _dataArr[view.tag];
//                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, dic[@"p_wimg"]]]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    imageView.image = image;
//                }];
//                
//                //                DLog(@"%ld",imageView.tag);
//                // 判断
//                for (NSDictionary *dic_id in ids) {
//                    // 选择的产品的id
//                    if ([dic_id[@"id"] integerValue] == imageView.tag) {
//                        //                        DLog(@"%ld",imageView.tag);
//                        
//                        
//                        
//                        
                        // 选取图片
//                        NSDictionary *dic = _dataArr[view.tag];
//                        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, dic[@"p_ximg"]]]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                            imageView.image = image;
//                        }];
//
//                    }
//                }
//            }
//        }
//    }
    
}

- (void)configCell:(NSArray *)dataArr andWashType:(NSInteger)type andSelectPids:(NSArray *)ids
{
    _washType = type;
    _dataArr = dataArr;

    NSArray *subViews = self.contentView.subviews;
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < dataArr.count; i ++) {
        NSDictionary *dic = dataArr[i];
        DLog(@"%@",dic);

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((i%4)*([UIScreen mainScreen].bounds.size.width/4), (i/4)*([UIScreen mainScreen].bounds.size.width/4+15), [UIScreen mainScreen].bounds.size.width/4, [UIScreen mainScreen].bounds.size.width/4+10)];
        
        
        XBBDIYImageView *imageView = [[XBBDIYImageView alloc] init];
        
        imageView.tag = [dic[@"id"] integerValue];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, dic[@"p_wimg"]]]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imageView.noSelectImage = image;
        }];
        [view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view);
            make.top.mas_equalTo(view.mas_top).mas_offset(10);
            make.width.mas_equalTo(view.bounds.size.width/1.2);
            make.height.mas_equalTo(view.bounds.size.width/1.2);
        }];
        
        priceLabel = [[UILabel alloc] init];
        priceLabel.font = [UIFont systemFontOfSize:8];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [UIColor redColor];
        priceLabel.text = [NSString stringWithFormat:@"%.2f",[dic[@"p_price"] floatValue]];
        [view addSubview:priceLabel];
        [priceLabel setTextAlignment:NSTextAlignmentCenter];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view);
            make.top.mas_equalTo(imageView.mas_bottomMargin).mas_offset(-5);
            make.left.mas_equalTo(view.mas_leftMargin);
            make.right.mas_equalTo(view.mas_rightMargin);
        }];
        
        
        
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.text = [NSString stringWithFormat:@"%@",dic[@"p_info"]];
        [view addSubview:label];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view);
            make.top.mas_equalTo(imageView.mas_bottomMargin).mas_offset(15);
            make.left.mas_equalTo(view.mas_leftMargin);
            make.right.mas_equalTo(view.mas_rightMargin);
        }];
        UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longp:)];
        [view addGestureRecognizer:longP];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapP:)];
        [view addGestureRecognizer:tap];
        view.tag = i;
        
        [self.contentView addSubview:view];
        self.frame = CGRectMake(0, 0, self.frame.size.width, view.frame.size.height + view.frame.origin.y +20);
        
        // 重置选择
        if (ids) {
            [self configCellIncon:ids];
        }
        
    }
    UILabel *promptLabel = [[UILabel alloc] init];
    [self.contentView addSubview:promptLabel];
    NSString *promptString = @"* 长按图标查看服务详情 !";
    [promptLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:promptString];
    [attributeString addAttributes: @{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, [promptString length])];
    [attributeString addAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:30],NSBaselineOffsetAttributeName:@(-10.f)} range:NSMakeRange(0, 1)];

    promptLabel.attributedText = attributeString;
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
    }];
    CGRect frame = self.frame;
    frame.size.height += 30;
    self.frame = frame;
    
    
}

- (IBAction)tapP:(id)sender
{
    DLog(@"%@",sender);
    
   
    UITapGestureRecognizer *tap = sender;
    UIView *view = tap.view;
    NSArray *subViews = [view subviews];
    for (id subView in subViews) {
        if ([subView isKindOfClass:[XBBDIYImageView class]]) {
            XBBDIYImageView *imageView = subView;
            if ([self.delegate respondsToSelector:@selector(tapActionFacialToProD:complete:)]) {
                [self.delegate tapActionFacialToProD:[NSString stringWithFormat:@"%ld",imageView.tag] complete:^(id result) {
                    DLog(@"%@",result);
                    
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        
                        if (_washType == 0 ) {
                            [SVProgressHUD showErrorWithStatus:@"DIY项目必须选择洗车"];
                            return;
                        }
                        NSDictionary *dic = _dataArr[view.tag];
                        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, dic[@"p_ximg"]]]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            imageView.image = image;
                        }];
                    }else
                    {
                    DLog(@"----")
                    NSDictionary *dic = _dataArr[view.tag];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, dic[@"p_wimg"]]]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        imageView.image = image;
                    }];
                    }
                } ];
            }
            
            
         
        }
    }
}
- (IBAction)longp:(id)sender
{
   
   
    UILongPressGestureRecognizer *tap = sender;
    
    switch (tap.state) {
        case UIGestureRecognizerStateBegan:
        {
            UIView *view = tap.view;
            NSDictionary *dic = _dataArr[view.tag];
            NSString *urlString = [NSString stringWithFormat:@"http://xbbwx.marnow.com/Weixin/Diy/index?p_id=%@", dic[@"id"]];
            [self.delegate longPressFacialToProD:urlString];
        }
            break;
            
        default:
            break;
    }
    
    
 
 
}

@end
