//
//  AllCommentTableViewCell.m
//  XBB
//
//  Created by Daniel on 15/9/2.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "AllCommentTableViewCell.h"
#import "StarView.h"

@interface AllCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *starBackGroundView;
@end

@implementation AllCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.starView = [StarView starView];
    [self.starBackGroundView addSubview:self.starView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat totalHeight = 0;
    totalHeight += 165;
    totalHeight += [self.labContent sizeThatFits:size].height;
    return CGSizeMake(size.width, totalHeight);
}
@end
