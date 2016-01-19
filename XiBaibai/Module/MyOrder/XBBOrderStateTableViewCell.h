//
//  XBBOrderStateTableViewCell.h
//  XiBaibai
//
//  Created by xbb01 on 16/1/19.
//  Copyright © 2016年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBBOrderStateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgimageView;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
