//
//  XBBDiyObject.h
//  XiBaibai
//
//  Created by HoTia on 15/12/4.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBBDiyObject : NSObject

@property (nonatomic, copy) NSString *proName;
@property (nonatomic, copy) NSString *pid;

@property (nonatomic, assign) float price1;
@property (nonatomic, assign) float price2;
@property (nonatomic, copy) NSString *labelName;
@property (nonatomic, copy) NSMutableArray *proArray;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger p_wash_free;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger isWaxTag; 
@end
