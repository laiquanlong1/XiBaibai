//
//  SystemMsgTableViewCell.h
//  XBB
//
//  Created by Apple on 15/9/3.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 系统消息视图
 * @detail <#description#>
 **/
@interface SystemMsgTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end
