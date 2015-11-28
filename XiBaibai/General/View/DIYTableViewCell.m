//
//  DIYTableViewCell.m
//  XBB
//
//  Created by mazi on 15/9/12.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "DIYTableViewCell.h"

@implementation DIYTableViewCell

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
        self.labTitle = [UILabel new];
        self.labTitle.textColor = kUIColorFromRGB(0xb3b3b3);
        [self.contentView addSubview:self.labTitle];
        [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.imgView = [UIImageView new];
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];

    }
    
    return self;
}

@end
