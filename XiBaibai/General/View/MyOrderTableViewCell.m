//
//  MyOrderTableViewCell.m
//  XBB
//
//  Created by Apple on 15/8/30.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.topView = [OrderTopView orderTopView];
    self.topView.backgroundColor = [UIColor clearColor];
    self.topBackgroundView.backgroundColor = [UIColor clearColor];
    [self.topBackgroundView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.scoreView = [StarView starView];
    [self.scoreBackgroundView addSubview:self.scoreView];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
