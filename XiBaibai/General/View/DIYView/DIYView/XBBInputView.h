//
//  XBBInputView.h
//  XiBaibai
//
//  Created by xbb01 on 15/12/19.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBBInputView : UIView

@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UIButton *button;


- (instancetype)initWithFrame:(CGRect)frame placeeholder:(NSString *)place buttonName:(NSString *)buttonName inittag:(NSInteger)tag;


@end
