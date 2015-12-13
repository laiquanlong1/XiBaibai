//
//  SetCarAddsViewController.h
//  XBB
//
//  Created by mazi on 15/9/4.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetCarAddsViewControllerDelegate <NSObject>

- (void)setNowLocation:(NSString *)strLocation withNum:(NSInteger )num;

@end

@interface SetCarAddsViewController : XBBViewController

@property (assign,nonatomic) NSInteger num;

@property (assign,nonatomic) id<SetCarAddsViewControllerDelegate> delegate;

@end
