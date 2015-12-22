//
//  XBBInputView.m
//  XiBaibai
//
//  Created by xbb01 on 15/12/19.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBInputView.h"

@implementation XBBInputView


- (instancetype)initWithFrame:(CGRect)frame placeeholder:(NSString *)place buttonName:(NSString *)buttonName inittag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XBB_Bg_Color;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/10, 65+20, self.bounds.size.width-self.bounds.size.width/10*2, 44.)];
        backView.layer.cornerRadius = 5;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = XBB_Forground_Color;
        
        [self addSubview:backView];
        self.textFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, backView.bounds.size.width-10, backView.bounds.size.height)];
        [backView addSubview:self.textFiled];
        self.textFiled.placeholder = place;
        self.textFiled.delegate = self;
        [self.textFiled setFont:[UIFont systemFontOfSize:13.]];
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(backView.frame.origin.x, backView.frame.origin.y+backView.frame.size.height + 50, backView.frame.size.width, 44.)];
        self.button.layer.borderColor = XBB_NavBar_Color.CGColor;
        self.button.layer.borderWidth = 1.;
        self.button.layer.cornerRadius = 5.;
        self.button.layer.masksToBounds = YES;
        self.button.backgroundColor = XBB_Forground_Color;
        self.button.tag = tag;
        [self.button setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
        [self.button setTitle:buttonName forState:UIControlStateNormal];
        [self addSubview:self.button];
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *string_1 = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([string_1 length] > 15.) {
        return NO;
    }
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
