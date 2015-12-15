//
//  MyOrderMouldTableViewCell.h
//  XiBaibai
//
//  Created by HoTia on 15/12/14.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderMouldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *downOrderTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *carCaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *CarNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *carLacation;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;




@end
