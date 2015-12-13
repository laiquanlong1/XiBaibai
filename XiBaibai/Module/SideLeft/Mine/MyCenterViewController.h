//
//  MyCenterViewController.h
//  XBB
//
//  Created by Apple on 15/8/23.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mach.h"
#import "XBBViewController.h"


@protocol SideBarSelectDelegate ;

@interface MyCenterViewController : XBBViewController

@property (assign,nonatomic)id<SideBarSelectDelegate>delegate;

@property (assign,nonatomic) NSInteger index;

@end
