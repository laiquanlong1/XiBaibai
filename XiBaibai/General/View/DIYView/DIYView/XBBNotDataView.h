//
//  XBBNotDataView.h
//  XiBaibai
//
//  Created by xbb01 on 15/12/18.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBBNotDataView : UIView

@property (nonatomic, copy) NSString *string;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIButton *sureButton;

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image withString:(NSString *)string;
- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image withString:(NSString *)string withButtonTitle:(NSString *)buttonTitle;
@end
