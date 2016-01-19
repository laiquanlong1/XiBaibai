//
//  XBBSelectStateView.m
//  XiBaibai
//
//  Created by xbb01 on 16/1/19.
//  Copyright © 2016年 Mingle. All rights reserved.
//

#import "XBBSelectStateView.h"

@interface XBBSelectStateView ()
{
    UIImageView *_selectImageView;
}
@property (nonatomic, strong) NSMutableArray *buttons;
@end
@implementation XBBSelectStateView
@synthesize selectIndex;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame withStates:(NSArray *)states
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = XBB_Forground_Color;
        [self initViews:states];
    }
    return self;
}

- (void)initViews:(NSArray *)states
{
    self.buttons = [NSMutableArray array];
    for (int i = 0; i < states.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width/states.count)*i, 0, self.bounds.size.width/states.count, self.bounds.size.height)];
        [button setTitle:states[i] forState:UIControlStateNormal];
       
        if (i == 0) {
            button.tag = 2;
            [button setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
            selectIndex = 0;
        }else
        {
            button.tag = 1;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        [self addSubview:button];
    }
    UIImage *image = [UIImage imageNamed:@"xbb_selectLine"];
    _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width/self.buttons.count, self.bounds.size.height - image.size.height)];
    [_selectImageView setImage:image];
    [self addSubview:_selectImageView];
    
}

- (IBAction)selectButtonAction:(UIButton *)sender
{
    for (UIButton *button in self.buttons) {
        if ([button isEqual:sender]) {
            sender.tag = 2;
            [sender setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
            NSUInteger intex =  [self.buttons indexOfObject:button];
            __block CGRect frame = _selectImageView.frame;
            [UIView animateWithDuration:0.25 animations:^{
                frame.origin.x = intex * self.bounds.size.width/self.buttons.count;
                _selectImageView.frame = frame;
                selectIndex = intex;
                if ([self.delegate respondsToSelector:@selector(changeSelectIndex:)]) {
                    [self.delegate changeSelectIndex:selectIndex];
                }
            }];
            
        }else
        {
            button.tag = 1;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
  
}

@end
