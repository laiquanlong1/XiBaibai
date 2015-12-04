//
//  FacialTableViewController.h
//  XiBaibai
//
//  Created by HoTia on 15/11/9.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^DIYServer)(id);
@interface DIYSelectTableViewController : XBBTableViewController
@property (nonatomic, assign) NSInteger washType; // 11为外观 22为整车 0.没有选择洗车
@property (nonatomic, assign) NSInteger selectCarType; // 1 轿车
@property (nonatomic, copy) DIYServer diyServers; // block
@property (nonatomic, copy) NSString *naviTitle; // navititle
@property (nonatomic, copy) NSDictionary *selectDIYDic; // 已选择
@end
