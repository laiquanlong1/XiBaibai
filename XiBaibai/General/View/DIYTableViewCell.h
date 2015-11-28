//
//  DIYTableViewCell.h
//  XBB
//
//  Created by mazi on 15/9/12.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * @brief DIY
 * @detail DIY
 **/
@interface DIYTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel *labTitle;
@property (strong,nonatomic) UIImageView *imgView;
@property (nonatomic, assign) NSInteger isSelect;// 是否选择
@end
