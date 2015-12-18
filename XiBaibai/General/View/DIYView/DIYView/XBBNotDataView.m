//
//  XBBNotDataView.m
//  XiBaibai
//
//  Created by xbb01 on 15/12/18.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBNotDataView.h"

@implementation XBBNotDataView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]
        )
    {
        
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image withString:(NSString *)string
{
    if (self == [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - image.size.width/2, self.bounds.size.height/2-image.size.height, image.size.width, image.size.height)];
        [self addSubview:imageView];
        imageView.image = image;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/10, imageView.frame.origin.y + imageView.frame.size.height + 5, self.bounds.size.width- self.bounds.size.width/10*2, 60.)];
        [label setFont:[UIFont systemFontOfSize:15.]];
        [label setText:string];
        [self addSubview:label];
        [label setTextAlignment:NSTextAlignmentCenter];
        
     
        
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image withString:(NSString *)string withButtonTitle:(NSString *)buttonTitle
{
    if (self == [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - image.size.width/2, self.bounds.size.height/2-image.size.height, image.size.width, image.size.height)];
        [self addSubview:imageView];
        imageView.image = image;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/10, imageView.frame.origin.y + imageView.frame.size.height + 5, self.bounds.size.width- self.bounds.size.width/10*2, 60.)];
        [label setFont:[UIFont systemFontOfSize:15.]];
        [label setText:string];
        [self addSubview:label];
        [label setTextAlignment:NSTextAlignmentCenter];
//         self.sureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - buttonImage.size.width/2 , label.frame.size.height + label.frame.origin.y, buttonImage.size.width, buttonImage.size.height)];
        self.sureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 50, label.frame.size.height + label.frame.origin.y, 100, 30.)];
        
        [self.sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.sureButton setTitle:buttonTitle forState:UIControlStateNormal];
        self.sureButton.layer.cornerRadius = 5.;
        self.sureButton.layer.borderColor = [UIColor grayColor].CGColor;
        self.sureButton.layer.borderWidth = 1.;
        self.sureButton.layer.masksToBounds = YES;
        [self addSubview:self.sureButton];
        
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
