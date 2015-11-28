//
//  DIYViewController.h
//  XBB
//
//  Created by Daniel on 15/9/11.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DIYServer)(NSArray *);

@interface DIYViewController : UIViewController
@property (nonatomic, assign) NSInteger washType; // 11为外观 22为整车
@property (nonatomic, copy) DIYServer diyServers;
@property (nonatomic, copy) NSString *naviTitle;
@property (assign, nonatomic) NSInteger defaultCarId;

@end
