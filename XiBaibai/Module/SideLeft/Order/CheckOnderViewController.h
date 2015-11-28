//
//  CheckOnderViewController.h
//  XiBaibai
//
//  Created by mazi on 15/9/22.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckOnderViewController : UIViewController

@property (strong,nonatomic) NSString *order_name;
@property (strong,nonatomic) NSString *order_price;
@property (strong,nonatomic) NSString *order_location;
@property (strong,nonatomic) NSString *order_carModel;
@property (strong,nonatomic) NSString *p_ids;
@property (strong,nonatomic) NSString *c_id;
@property (strong,nonatomic) NSString *uid;

@property (strong,nonatomic) NSString *timePlan;
@property (assign,nonatomic) BOOL flag;

@end
