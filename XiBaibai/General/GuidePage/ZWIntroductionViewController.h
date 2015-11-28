//
//  LGIntroductionViewController.h
//  ladygo
//
//  Created by square on 15/1/21.
//  Copyright (c) 2015年 ju.taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 定义选择进入block
 * @detail 定义选择进入block
 **/
typedef void (^DidSelectedEnter)();

@interface ZWIntroductionViewController : UIViewController

/**
 * @brief 全局的ScrollView
 * @detail 全局
 **/
@property (nonatomic, strong) UIScrollView *pagingScrollView;

/**
 * @brief 进入按钮
 * @detail 进入按钮
 **/
@property (nonatomic, strong) UIButton *enterButton;

/**
 * @brief block申明
 * @detail block声明
 **/
@property (nonatomic, copy) DidSelectedEnter didSelectedEnter;

/**
 @[@"image1", @"image2"]  image名字数组
 */
@property (nonatomic, strong) NSArray *backgroundImageNames;

/**
 @[@"coverImage1", @"coverImage2"]
 */
@property (nonatomic, strong) NSArray *coverImageNames;


- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames;


- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames button:(UIButton*)button;

@end
