//
//  CarTypeTableViewController.h
//  XiBaibai
//
//  Created by HoTia on 15/11/8.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CarType)(NSDictionary *type);
@interface CarTypeTableViewController : UITableViewController

@property (nonatomic, copy) CarType carType;

@end
