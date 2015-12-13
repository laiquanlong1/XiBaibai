//
//  SetCarAddsInfoViewController.h
//  XBB
//
//  Created by mazi on 15/9/4.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetCarAddsInfoViewControllerDelegate <NSObject>

- (void)setAddsInfo:(NSString *)AddsInfo withNum:(NSInteger )num;

@end

@interface SetCarAddsInfoViewController : XBBViewController
@property (assign,nonatomic) NSInteger num;

@property (assign,nonatomic) id<SetCarAddsInfoViewControllerDelegate> delegate;

@end
