//
//  OrderTopView.h
//  XBB
//
//  Created by Apple on 15/9/5.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNO;
@property (weak, nonatomic) IBOutlet UILabel *orderState;

+ (id)orderTopView;

@end
