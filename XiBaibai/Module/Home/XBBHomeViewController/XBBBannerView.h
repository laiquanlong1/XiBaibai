//
//  XBBBannerView.h
//  XiBaibai
//
//  Created by HoTia on 15/12/1.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBBBannerView;


@protocol XBBBannerViewDelegate <NSObject>

- (void)xbbBanner:(id)sender;

@end

@interface XBBBannerView : UIView

@property (weak,nonatomic) id <XBBBannerViewDelegate> xbbDelegate;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *buttons;
- (instancetype)initWithFrame:(CGRect)frame imagesNames:(NSArray *)imageNames;

@end
