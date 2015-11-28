//
//  NetworkHelper.m
//  XBB
//
//  Created by Apple on 15/8/30.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "NetworkHelper.h"
#import "AFNetworking.h"

@interface NetworkObject ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation NetworkObject

- (void)cancel {
    [self.manager.operationQueue cancelAllOperations];
}

@end

@implementation NetworkHelper
//
//+ (void)getWithAPI:(NSString *)api
//{
//
//    // 设置请求路径;
//    NSString *urlString = [NSString stringWithFormat:@"%@",api];
//    
//    // 转化为url路径
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    // 创建请求对象
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.f];
//    
//    AFHTTPRequestOperation *opration = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [opration setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",operation.responseString);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",[error description]);
//    }];
//    [opration start];
//    
//}


+ (NetworkObject *)getWithAPI:(NSString *)api parameter:(NSDictionary *)param successBlock:(void (^)(id))success failBlock:(void (^)(NSError *))fail{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject: @"text/html"];
    manager.requestSerializer.timeoutInterval = 30;
    [manager GET:api parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
            fail(error);
    }];
    NetworkObject *object = [[NetworkObject alloc] init];
    object.manager = manager;
    return object;
}

+ (NetworkObject *)postWithAPI:(NSString *)api parameter:(NSDictionary *)param successBlock:(void (^)(id))success failBlock:(void (^)(NSError *))fail {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject: @"text/html"];
    manager.requestSerializer.timeoutInterval = 30.;
    [manager POST:api parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail)
            fail(error);
    }];
    NetworkObject *object = [[NetworkObject alloc] init];
    object.manager = manager;
    return object;
}

@end
