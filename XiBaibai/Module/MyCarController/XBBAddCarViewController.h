//
//  XBBAddCarViewController.h
//  XiBaibai
//
//  Created by HoTia on 15/12/12.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBViewController.h"
#import "MyCarModel.h"

typedef void(^Block)(void);
@interface XBBAddCarViewController : XBBViewController
@property (nonatomic, copy) Block block;
@property (strong, nonatomic) MyCarModel *carModel;


@end
