//
//  WebViewController.h
//  XBB
//
//  Created by Apple on 15/9/4.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBBProObject.h"

@interface WebViewController : XBBViewController

@property (nonatomic, assign) NSInteger selectCarType;
@property (copy, nonatomic) NSString *urlString;
@property (nonatomic,strong) XBBProObject *proObject;

@end
