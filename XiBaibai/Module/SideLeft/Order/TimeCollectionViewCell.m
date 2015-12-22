//
//  TimeCollectionViewCell.m
//  XBB
//
//  Created by Daniel on 15/8/21.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "TimeCollectionViewCell.h"

@implementation TimeCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.labtime = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.contentView.bounds), 15)];
        self.labtime.textAlignment=NSTextAlignmentCenter;
        self.labtime.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.labtime];
        
        self.labYesNo = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.contentView.bounds), 15)];
        self.labYesNo.textAlignment=NSTextAlignmentCenter;
        self.labYesNo.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.labYesNo];
        self.selected = NO;
    }
    
    return self;
}

- (void)setIsYesNo:(BOOL)isYesNo
{
    if (_isYesNo != isYesNo) {
        _isYesNo = isYesNo;
    }
    if (isYesNo) {
        self.labtime.textColor = [UIColor whiteColor];
        self.labYesNo.textColor = [UIColor whiteColor];
        self.backgroundColor =kUIColorFromRGB(0xcccccc);
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
  
    if (selected) {
        self.labtime.textColor = [UIColor whiteColor];
        self.labYesNo.textColor = [UIColor whiteColor];
        self.backgroundColor = XBB_NavBar_Color; //kUIColorFromRGB(0xfd6b6c);
        
    } else {
        self.labtime.textColor =  XBB_NavBar_Color;
        self.labYesNo.textColor = XBB_NavBar_Color;
        self.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    }
    
}

@end
