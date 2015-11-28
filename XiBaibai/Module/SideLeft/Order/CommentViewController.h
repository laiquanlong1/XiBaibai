//
//  CommentViewController.h
//  XBB
//
//  Created by Apple on 15/9/19.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController

@property (copy, nonatomic) NSString *emp_name;
@property (copy, nonatomic) NSString *emp_num;
@property (copy, nonatomic) NSString *emp_img;
@property (strong, nonatomic) NSNumber *emp_id;
@property (strong, nonatomic) NSNumber *order_id;

@end
