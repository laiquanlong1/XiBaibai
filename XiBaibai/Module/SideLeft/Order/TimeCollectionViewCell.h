//
//  TimeCollectionViewCell.h
//  XBB
//
//  Created by Daniel on 15/8/21.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeCollectionViewCell : UICollectionViewCell

@property (strong,nonatomic) UILabel *labtime;
@property (strong,nonatomic) UILabel *labYesNo;
@property (assign,nonatomic) BOOL isYesNo;
@end
