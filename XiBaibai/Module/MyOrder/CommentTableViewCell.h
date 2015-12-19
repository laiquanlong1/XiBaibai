//
//  CommentTableViewCell.h
//  XiBaibai
//
//  Created by xbb01 on 15/12/19.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *commentStar;

@property (weak, nonatomic) IBOutlet UILabel *commentContent;

@end
