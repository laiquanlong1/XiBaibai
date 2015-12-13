//
//  XBBDIYViewController.h
//  XiBaibai
//
//  Created by HoTia on 15/12/4.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBTableViewController.h"

typedef void(^SelectDiyObject)(NSHashTable *selectHashObject);
@interface XBBDIYViewController : XBBTableViewController

@property (nonatomic, assign) NSInteger washType; // 11为外观 22为整车 0.没有选择洗车
@property (nonatomic, copy) SelectDiyObject selectObjectsBlock;
@property (nonatomic, copy) NSArray *selectArray;

@end
