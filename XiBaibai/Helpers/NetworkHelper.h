//
//  NetworkHelper.h
//  XBB
//
//  Created by Apple on 15/8/30.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkObject : NSObject

- (void)cancel;

@end

@interface NetworkHelper : NSObject

+ (NetworkObject *)getWithAPI:(NSString *)api parameter:(NSDictionary *)param successBlock:(void (^)(id response))success failBlock:(void (^)(NSError *error))fail;
+ (NetworkObject *)postWithAPI:(NSString *)api parameter:(NSDictionary *)param successBlock:(void (^)(id response))success failBlock:(void (^)(NSError *error))fail;

@end
