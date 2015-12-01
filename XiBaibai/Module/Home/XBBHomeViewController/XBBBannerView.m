//
//  XBBBannerView.m
//  XiBaibai
//
//  Created by HoTia on 15/12/1.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBBannerView.h"


@interface XBBBannerView ()<UIScrollViewDelegate>
{
    BOOL isOk;
    float ok;
    NSInteger count;
    UIPageControl *controlPage;
    UIScrollView *backScrollView;
    NSTimer *timer;
}

@end

@implementation XBBBannerView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x - ok >= 0) {
        isOk = NO;
    }else
    {
        isOk = YES;
    }
    if (scrollView.contentOffset.x < 0) {
        isOk = YES;
        scrollView.contentOffset = CGPointMake(XBB_Screen_width * (count), 0);
    }
    ok = scrollView.contentOffset.x;
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:self.animationInterval?self.animationInterval:3.0f target:self selector:@selector(scrollViewScroll:) userInfo:nil repeats:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    DLog(@"")
    controlPage.currentPage = scrollView.contentOffset.x/XBB_Screen_width;
 
    if (isOk) {
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
    timer = [NSTimer scheduledTimerWithTimeInterval:self.animationInterval?self.animationInterval:3.0f target:self selector:@selector(scrollViewScroll:) userInfo:nil repeats:YES];
}

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
- (IBAction)scrollViewScroll:(id)sender
{
    __block CGPoint piont = backScrollView.contentOffset;
    [UIView animateWithDuration:self.animationInterval?self.animationInterval:0.3 animations:^{
        piont.x += XBB_Screen_width;
        backScrollView.contentOffset = piont;
        controlPage.currentPage = backScrollView.contentOffset.x/XBB_Screen_width;
    } completion:^(BOOL finished) {
        if (piont.x >= XBB_Screen_width*count) {
            controlPage.currentPage = 0;
            piont.x = 0;
            backScrollView.contentOffset = piont;
        }
        DLog(@"%f",backScrollView.contentOffset.x)
    }];
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
        backScrollView.pagingEnabled = YES;
        backScrollView.showsHorizontalScrollIndicator = NO;
        backScrollView.showsVerticalScrollIndicator = NO;
        backScrollView.delegate = self;
        [backScrollView addSubview:button];
        [self.buttons addObject:button];
        
        backScrollView.contentSize = CGSizeMake(XBB_Screen_width*(i+1), 0);
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval?self.timerInterval:3.0 target:self selector:@selector(scrollViewScroll:) userInfo:nil repeats:YES];
    controlPage = [[UIPageControl alloc] initWithFrame:CGRectMake(XBB_Screen_width/2-50, self.bounds.size.height - self.bounds.size.height/6, 100, 20)];
    controlPage.numberOfPages = count;
    controlPage.currentPage = 0;
    [self addSubview:controlPage];
}

#pragma mark action

- (IBAction)buttonAction:(id)sender
{
    UIButton *button = sender;
    DLog(@"%d",button.tag);
}

@end
