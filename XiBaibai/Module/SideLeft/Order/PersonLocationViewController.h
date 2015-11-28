//
//  PersonLocationViewController.h
//  XBB
//
//  Created by Apple on 15/9/18.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonLocationViewController : UIViewController

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *emp_name, *emp_num;

@end
