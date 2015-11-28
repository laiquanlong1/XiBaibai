//
//  MyCouponsTableViewCell.m
//  XBB
//
//  Created by Daniel on 15/9/2.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "MyCouponsTableViewCell.h"

@implementation MyCouponsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         UIImageView *cellBacgroundimgview = [UIImageView new];
        cellBacgroundimgview.image = [UIImage imageNamed:@"1@icon_youhuiquanCell.png"];
        [self.contentView addSubview:cellBacgroundimgview];
        [cellBacgroundimgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView).mas_offset(0);
            make.centerY.mas_equalTo(self.contentView).mas_offset(0);
           
            make.left.mas_equalTo(self.contentView).mas_offset(5);
            make.right.mas_equalTo(self.contentView).mas_offset(-5);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-5);
            
        }];
        self.labFuhao = [[UILabel alloc] init];
        [cellBacgroundimgview addSubview:self.labFuhao];
        self.labFuhao.textColor = kUIColorFromRGB(0xf2a135);
        [self.labFuhao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(65);
        }];
        
        self.labMoney = [UILabel new];
        [self.labMoney setTextAlignment:NSTextAlignmentCenter];
        self.labMoney.textColor = kUIColorFromRGB(0xeea245);
        self.labMoney.font = [UIFont boldSystemFontOfSize:40];
        [cellBacgroundimgview addSubview:self.labMoney];
        [self.labMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(45);
            make.width.mas_equalTo(110);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = kUIColorFromRGB(0xdbdadb);
        [cellBacgroundimgview addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(90);
            make.top.mas_equalTo(cellBacgroundimgview.mas_top).mas_offset(20);
            make.left.mas_equalTo(cellBacgroundimgview.mas_left).mas_offset(110);
        }];
        
        self.labTitle = [UILabel new];
        self.labTitle.textColor = kUIColorFromRGB(0x5c5c5c);
        [cellBacgroundimgview addSubview:self.labTitle];
        [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cellBacgroundimgview.mas_left).mas_offset(140);
            make.top.mas_equalTo(cellBacgroundimgview.mas_top).mas_offset(20);
        }];
        
        self.labValtime = [UILabel new];
        self.labValtime.textColor = kUIColorFromRGB(0x5c5c5c);
        [cellBacgroundimgview addSubview:self.labValtime];
        [self.labValtime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cellBacgroundimgview.mas_left).mas_offset(140);
            make.top.mas_equalTo(cellBacgroundimgview.mas_top).mas_offset(55);
        }];
        
        
        self.labRemark = [UILabel new];
        self.labRemark.textColor = kUIColorFromRGB(0x5c5c5c);
        [cellBacgroundimgview addSubview:self.labRemark];
        [self.labRemark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cellBacgroundimgview.mas_left).mas_offset(140);
            make.top.mas_equalTo(cellBacgroundimgview.mas_top).mas_offset(90);
        }];
    }
    
    return self;
}
@end
