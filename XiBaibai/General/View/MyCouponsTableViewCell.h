//
//  MyCouponsTableViewCell.h
//  XBB
//
//  Created by Daniel on 15/9/2.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 优惠券
 * @detail 优惠券cell
 **/
@interface MyCouponsTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel *labFuhao;
@property (strong,nonatomic) UILabel *labMoney; // 金额
@property (strong,nonatomic) UILabel *labTitle;
@property (strong,nonatomic) UILabel *labValtime;
@property (strong,nonatomic) UILabel *labRemark;

@end
