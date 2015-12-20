//
//  StarView.m
//  XBB
//
//  Created by mazi on 15/9/3.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "StarView.h"

@implementation StarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (id)starView {
    StarView *view = [[[UINib nibWithNibName:@"StarView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    return view;
}

- (void)setScore:(float)score {
    _score = score;
    NSMutableArray *starArr = [[NSMutableArray alloc] initWithObjects:self.starOne,self.starTwo,self.starThree,self.starFour,self.starFive, nil];
    
    for (int i=0; i<5; i++) {
        if (i < floor(_score)) {
            UIImageView *imgView = starArr[i]; //1@icon_starred.png
            imgView.image = [UIImage imageNamed:@"星星已选择"];
        } else if (i < ceil(_score)) {
            UIImageView *imgView = starArr[i];
            imgView.image = [UIImage imageNamed:@"1@icon_starredhui.png"];
        } else {
            UIImageView *imgView = starArr[i];
            imgView.image = [UIImage imageNamed:@"1@icon_starhui.png"];
 
        }
    }
    
}

@end
