//
//  XBBAddressSelectViewController.h
//  XiBaibai
//
//  Created by HoTia on 15/12/9.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBTableViewController.h"
#import "XBBAddressModel.h"

typedef void(^SelectAddress)(XBBAddressModel *model);

@interface XBBAddressSelectViewController : XBBViewController
@property (nonatomic, copy) SelectAddress selectAddressBlock;

@end
