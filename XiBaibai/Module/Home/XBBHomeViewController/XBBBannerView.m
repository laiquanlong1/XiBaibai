//
//  XBBBannerView.m
//  XiBaibai
//
//  Created by HoTia on 15/12/1.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBBannerView.h"

#define timerInterval 6.0
#define animationTime 0.3

@interface XBBBannerView ()<UIScrollViewDelegate>
{
    BOOL isPanToRight;
    float offsetX;
    NSInteger count;
    UIPageControl *controlPage;
    UIScrollView *backScrollView;
    NSTimer *timer;
}

@end

@implementation XBBBannerView

#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DLog(@"%f",scrollView.contentOffset.x)
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
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(scrollViewScroll:) userInfo:nil repeats:YES];
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
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(scrollViewScroll:) userInfo:nil repeats:YES];
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
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width * i, 0, XBB_Screen_width, self.bounds.size.height)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        if (i == imageNames.count) {
            button.tag = 0;
        }
        switch (i) {
            case 0:
            {
                button.backgroundColor = [UIColor blueColor];
            }
                break;
            case 1:
            {
                button.backgroundColor = [UIColor orangeColor];
            }
                break;
            case 2:
            {
                button.backgroundColor = [UIColor grayColor];
            }
                break;
            case 3:
            {
                button.backgroundColor = [UIColor redColor];
            }
                break;
            case 4:
            {
                button.backgroundColor = [UIColor blackColor];
            }
                break;
            case 5:
            {
                button.backgroundColor = [UIColor blueColor];
            }
                break;
            default:
                break;
        }
        if (i == imageNames.count) {
             button.backgroundColor = [UIColor blueColor];
        }
        [backScrollView setZoomScale:1.3 animated:YES];
        backScrollView.pagingEnabled = YES;
        backScrollView.showsHorizontalScrollIndicator = NO;
        backScrollView.showsVerticalScrollIndicator = NO;
        backScrollView.delegate = self;
        [backScrollView addSubview:button];
        [self.buttons addObject:button];
        
    }
    backScrollView.contentSize = CGSizeMake(XBB_Screen_width*(count+1), 0);
    controlPage = [[UIPageControl alloc] initWithFrame:CGRectMake(XBB_Screen_width/2-50, self.bounds.size.height - self.bounds.size.height/6, 100, 20)];
    controlPage.numberOfPages = count;
    controlPage.currentPage = 0;
    controlPage.userInteractionEnabled = NO;
    [self addSubview:controlPage];
    timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(scrollViewScroll:) userInfo:nil repeats:YES];
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
    [timer invalidate];
    UIButton *button = sender;
    DLog(@"%d",button.tag);
    if ([self.xbbDelegate respondsToSelector:@selector(xbbBanner:)]) {
        [self.xbbDelegate xbbBanner:button];
    }
}

@end
