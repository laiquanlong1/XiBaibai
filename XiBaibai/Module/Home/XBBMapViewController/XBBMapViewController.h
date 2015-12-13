//
//  IndexViewController.h
//  XBB
//
//  Created by Daniel on 15/8/4.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "mach.h"
#import "XBBViewController.h"

typedef void(^Select)(BOOL);
@interface XBBMapViewController : XBBViewController

@property (nonatomic, copy) Select selectAddress;
@property (nonatomic, copy) NSString *superController;

@property (nonatomic, assign) BOOL isHomeControllerto;

@end
