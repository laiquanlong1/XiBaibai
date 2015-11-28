//
//  MyOrderTableViewCell.h
//  XBB
//
//  Created by Apple on 15/8/30.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
#import "OrderTopView.h"

/**
 * @brief 订单
 * @detail 订单信息
 **/

#define MyOrderTableViewCellHeightAll 318
#define MyOrderTableViewCellHeightNoneBottom 193
#define MyOrderTableViewCellHeightReady 238
@class UIImageViewOfDesignable;
@interface MyOrderTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageViewOfDesignable *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *scoreBackgroundView;

@property (strong, nonatomic) OrderTopView *topView;
@property (strong, nonatomic) StarView *scoreView;

@end
