//
//  RechargeHelper.h
//  Dianzhuang
//
//  Created by Apple on 15/8/28.
//
//

#import <Foundation/Foundation.h>

#define NotificationRecharge @"NotificationRecharge"

@interface RechargeResultObject : NSObject

@property (assign, nonatomic) int resultStatus;
@property (assign, nonatomic) BOOL isSuccessful;
@property (copy, nonatomic) NSString *message;

+ (id)resultWithResultStatus:(int)statusCode successful:(BOOL)result message:(NSString *)msg;

@end

@interface RechargeHelper : NSObject

+ (id)defaultRechargeHelper;
+ (void)setAliPayNotifyURLString:(NSString *)aliStr;

- (void)payAliWithMoney:(double)money;
- (void)payAliWithMoney:(double)money orderNO:(NSString *)orderNO productTitle:(NSString *)title productDescription:(NSString *)description;

+ (void)handleWithAliCallbackDic:(NSDictionary *)dic;

@end
