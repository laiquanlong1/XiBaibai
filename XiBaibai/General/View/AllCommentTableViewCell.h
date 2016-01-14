//
//  AllCommentTableViewCell.h
//  XBB
//
//  Created by Daniel on 15/9/2.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarView;

/**
 * @brief 评论视图cell
 * @detail 评论视图cell
 **/
@interface AllCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) AllCommentTableViewCell *entity;

@property (weak,nonatomic) IBOutlet UIImageView *imgHeadView;
@property (weak,nonatomic) IBOutlet UILabel *labName;
@property (weak,nonatomic) IBOutlet UILabel *labNumber;
@property (weak,nonatomic) IBOutlet UILabel *labFen;
@property (weak,nonatomic) IBOutlet UILabel *labContent;
@property (weak,nonatomic) IBOutlet UILabel *labCar;
@property (weak,nonatomic) IBOutlet UILabel *labTime;

@property (strong,nonatomic) StarView *starView;
@property (assign,nonatomic) float score;



@end
