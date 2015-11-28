//
//  XBBBaseLabel.m
//  XiBaibai
//
//  Created by HoTia on 15/11/8.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBBaseLabel.h"


#define bgColor [UIColor clearColor]
#define kFont [UIFont systemFontOfSize:14]
#define kTextColor [UIColor grayColor]
@implementation XBBBaseLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = bgColor;
        self.font = kFont;
        self.textColor = kTextColor;
        
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = bgColor;
        self.font = kFont;
        self.textColor = kTextColor;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = bgColor;
        self.font = kFont;
        self.textColor = kTextColor;
    }
    return self;
}


@end
