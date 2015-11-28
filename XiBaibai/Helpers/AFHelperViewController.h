//
//  AFHelperViewController.h
//  XBB
//
//  Created by Daniel on 15/7/27.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFHelperViewController : UIViewController

+ (void )GetJsonDataWithString:(NSString *)str Block:(void (^)(NSDictionary *Dics , NSError *error))block;
+ (void )GetJsonDataWithString:(NSString *)str withBianLiang:(NSMutableDictionary *)dic Block:(void (^)(NSDictionary *Dics , NSError *error))block;
+ (void )GetJsonDataWithString:(NSString *)str Blockarr:(void (^)(NSMutableArray *Dics , NSError *error))block;

+ (void )POSTJsonDataWithString:(NSString *)str withBianLiang:(NSMutableDictionary *)dic Block:(void (^)(NSDictionary *Dics , NSError *error))block;

@end
