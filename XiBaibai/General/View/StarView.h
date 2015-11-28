//
//  StarView.h
//  XBB
//
//  Created by mazi on 15/9/3.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 星级视图
 * @detail 星级视图
 **/
@interface StarView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *starOne;
@property (weak, nonatomic) IBOutlet UIImageView *starTwo;
@property (weak, nonatomic) IBOutlet UIImageView *starThree;
@property (weak, nonatomic) IBOutlet UIImageView *starFour;
@property (weak, nonatomic) IBOutlet UIImageView *starFive;
@property (assign, nonatomic) float score;

+ (id)starView;


@end
