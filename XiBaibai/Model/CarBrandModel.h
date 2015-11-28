//
//  CarBrandModel.h
//  XiBaibai
//
//  Created by Apple on 15/9/20.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarBrandModel : NSObject

@property (assign, nonatomic) NSInteger brandId;
@property (copy, nonatomic) NSString *first_letter;
@property (copy, nonatomic) NSString *make_name;
@property (copy, nonatomic) NSString *country;
@property (assign, nonatomic) NSInteger state;

@end
