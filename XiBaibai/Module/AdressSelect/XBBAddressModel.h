//
//  XBBAddressModel.h
//  XiBaibai
//
//  Created by HoTia on 15/12/9.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBBAddressModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *remarkAddress;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@end
