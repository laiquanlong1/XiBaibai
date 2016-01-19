//
//  XBBBannerView.m
//  XiBaibai
//
//  Created by HoTia on 15/12/1.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBBannerView.h"
#import "XBBBannerObject.h"


#define timerInterval 6.0
#define animationTime 0.3

@interface XBBBannerView ()<UIScrollViewDelegate>
{
    BOOL isPanToRight;
    float offsetX;
    NSInteger count;
    UIPageControl *controlPage;
    UIScrollView *backScrollView;
    
}

@end

@implementation XBBBannerView

#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x - offsetX >= 0) {
        isPanToRight = NO;
    }else
    {
        isPanToRight = YES;
    }
    if (scrollView.contentOffset.x <= -0.1) {
        isPanToRight = YES;
        scrollView.contentOffset = CGPointMake(XBB_Screen_width * (count), 0);
    }
    if (scrollView.contentOffset.x > XBB_Screen_width*count) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    offsetX = scrollView.contentOffset.x;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(scrollViewScroll:) userInfo:nil repeats:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    controlPage.currentPage = scrollView.contentOffset.x/XBB_Screen_width;
 
    if (isPanToRight) {
        if (scrollView.contentOffset.x <= 0.00) {
            scrollView.contentOffset = CGPointMake(XBB_Screen_width*count, 0);
        }
    }else
    {
        if (scrollView.contentOffset.x >= XBB_Screen_width*count) {
            scrollView.contentOffset = CGPointMake(0, 0);
            controlPage.currentPage = 0;
        }
    }
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(scrollViewScroll:) userInfo:nil repeats:YES];
}


#pragma mark init

- (instancetype)initWithFrame:(CGRect)frame imagesNames:(NSArray *)imageNames
{
    self = [super initWithFrame:frame];
    if (self) {
        backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:backScrollView];
        self.buttons = [NSMutableArray array];
        [self initButtonsWithImageNames:imageNames];
    }
    return self;
}


- (void)initButtonsWithImageNames:(NSArray *)imageNames
{
    count = imageNames.count;
    for (int i = 0; i < imageNames.count+1; i++) {
        XBBBannerObject *bannerOb = nil;
        if (i == imageNames.count) {
            bannerOb = imageNames[0];
        }else
        {
            bannerOb = imageNames[i];
        }
        UIImageView *button = [[UIImageView alloc] initWithFrame:CGRectMake(XBB_Screen_width * i, 0, XBB_Screen_width, self.bounds.size.height)];
        [button sd_setImageWithURL:[NSURL URLWithString:bannerOb.imageUrl] completed:nil];
        button.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
        [button addGestureRecognizer:tap];
        button.tag = [bannerOb.oid integerValue];
        backScrollView.pagingEnabled = YES;
        backScrollView.showsHorizontalScrollIndicator = NO;
        backScrollView.showsVerticalScrollIndicator = NO;
        backScrollView.delegate = self;
        [backScrollView addSubview:button];
    }
    backScrollView.contentSize = CGSizeMake(XBB_Screen_width*(count+1), 0);
    controlPage = [[UIPageControl alloc] initWithFrame:CGRectMake(XBB_Screen_width/2-50, self.bounds.size.height - self.bounds.size.height/6, 100, 20)];
    controlPage.numberOfPages = count;
    controlPage.currentPage = 0;
    controlPage.userInteractionEnabled = NO;
    [self addSubview:controlPage];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(scrollViewScroll:) userInfo:nil repeats:YES];
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark action
- (IBAction)scrollViewScroll:(id)sender
{
    __block CGPoint piont = backScrollView.contentOffset;
    [UIView animateWithDuration:animationTime animations:^{
        piont.x += XBB_Screen_width;
        backScrollView.contentOffset = piont;
        controlPage.currentPage = backScrollView.contentOffset.x/XBB_Screen_width;
    } completion:^(BOOL finished) {
        if (piont.x >= XBB_Screen_width*count) {
            controlPage.currentPage = 0;
            piont.x = 0;
            backScrollView.contentOffset = piont;
        }
    }];
}
- (IBAction)buttonAction:(id)sender
{
    [self.timer invalidate];
    UITapGestureRecognizer *button = sender;
    if ([self.xbbDelegate respondsToSelector:@selector(xbbBanner:)]) {
        [self.xbbDelegate xbbBanner:button];
    }
}

@end
