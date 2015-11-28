//
//  XBBDIYImageView.h
//  XiBaibai
//
//  Created by HoTia on 15/11/10.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBBaseImageView.h"

@interface XBBDIYImageView : XBBBaseImageView
@property (nonatomic, assign) NSInteger isSelect;
@property (nonatomic, strong) UIImage *noSelectImage;
@property (nonatomic, strong) UIImage *selectedImage;
- (void)setImageB:(UIImage *)image;
@end
