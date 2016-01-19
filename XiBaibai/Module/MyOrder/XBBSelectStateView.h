//
//  XBBSelectStateView.h
//  XiBaibai
//
//  Created by xbb01 on 16/1/19.
//  Copyright © 2016年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>



@class XBBSelectStateView;


@protocol XBBSelectStateViewDelegate <NSObject>

- (void)changeSelectIndex:(NSUInteger)index;

@end

@interface XBBSelectStateView : UIView
@property (nonatomic, weak) id<XBBSelectStateViewDelegate> delegate;
@property (nonatomic, readonly) NSUInteger selectIndex;
- (instancetype)initWithFrame:(CGRect)frame withStates:(NSArray *)states;
@end
