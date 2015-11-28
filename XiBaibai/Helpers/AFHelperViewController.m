//
//  AFHelperViewController.m
//  XBB
//
//  Created by Daniel on 15/7/27.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "AFHelperViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface AFHelperViewController ()

@end

@implementation AFHelperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void )GetJsonDataWithString:(NSString *)str Block:(void (^)(NSDictionary *Dics , NSError *error))block{
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    
//    [SVProgressHUD showWithStatus:@"加载中，请稍后。。。"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //你的接口地址
    NSString *url=[NSString stringWithFormat:@"%@",str];
    
    //发送请求
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"dddd   %@",result);
          //NSData *responseData=[NSURLConnection sendSynchronousRequest:responseObject returningResponse:nil error:nil];
        //解析数据
        NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic%@",Dic);
        if (block) {
            block(Dic,nil);
        }
//        [SVProgressHUD showWithStatus:@"请求成功"];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (block) {
            block([NSDictionary new],nil);
        }
//        [SVProgressHUD showWithStatus:@"请求失败"];
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1];
    }];
    
}

+ (void )GetJsonDataWithString:(NSString *)str Blockarr:(void (^)(NSMutableArray *arr , NSError *error))block{
    
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    
//    [SVProgressHUD showWithStatus:@"加载中，请稍后。。。"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //接口地址
    NSString *url=[NSString stringWithFormat:@"%@",str];
    
    //发送请求
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"dddd   %@",result);
        //  NSData *responseData=[NSURLConnection sendSynchronousRequest:responseObject returningResponse:nil error:nil];
        //解析数据
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if (block) {
            block(arr,nil);
        }
//        [SVProgressHUD showWithStatus:@"请求成功"];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (block) {
            block([NSMutableArray new],nil);
        }
//        [SVProgressHUD showWithStatus:@"请求失败"];
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1];
    }];
    
}

+ (void )GetJsonDataWithString:(NSString *)str withBianLiang:(NSMutableDictionary *)dic Block:(void (^)(NSDictionary *Dics , NSError *error))block{
    
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    
//    [SVProgressHUD show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //你的接口地址
    NSString *url=[NSString stringWithFormat:@"%@",str];
    NSMutableDictionary *dics=[[NSMutableDictionary alloc] initWithDictionary:dic];
    
    //发送请求
    [manager GET:url parameters:dics success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"dddd   %@",result);
        //NSData *responseData=[NSURLConnection sendSynchronousRequest:responseObject returningResponse:nil error:nil];
        //解析数据
        NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if (block) {
            block(Dic,nil);
        }
//        [SVProgressHUD showSuccessWithStatus:@"请求成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (block) {
            block([NSDictionary new],nil);
        }
//        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1];
    }];
    
}


+ (void )POSTJsonDataWithString:(NSString *)str withBianLiang:(NSMutableDictionary *)dic Block:(void (^)(NSDictionary *Dics , NSError *error))block{
    
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    
//    [SVProgressHUD showWithStatus:@"加载中，请稍后。。。"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //你的接口地址
    NSString *url=[NSString stringWithFormat:@"%@",str];
    NSMutableDictionary *dics=[[NSMutableDictionary alloc] initWithDictionary:dic];
    
    //发送请求
    [manager POST:url parameters:dics success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"dddd   %@",result);
        //NSData *responseData=[NSURLConnection sendSynchronousRequest:responseObject returningResponse:nil error:nil];
        //解析数据
        NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if (block) {
            block(Dic,nil);
        }
//        [SVProgressHUD showWithStatus:@"请求成功"];
//        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (block) {
            block([NSDictionary new],nil);
        }
//        [SVProgressHUD showWithStatus:@"请求失败"];
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1];
    }];
    
}



- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
