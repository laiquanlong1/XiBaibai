//
//  RechargeHelper.m
//  Dianzhuang
//
//  Created by Apple on 15/8/28.
//
//

#import "RechargeHelper.h"
//#import "Service.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
//#import "PersonInfo.h"
//#import "OtherPlatformMacro.h"
//#import "WXApi.h"

@implementation RechargeResultObject

+ (id)resultWithResultStatus:(int)statusCode successful:(BOOL)result message:(NSString *)msg {
    RechargeResultObject *object = [[RechargeResultObject alloc] init];
    if (object) {
        object.resultStatus = statusCode;
        object.isSuccessful = result;
        object.message = msg;
    }
    return object;
}

@end

static NSString *AliPayCallbackURL;

@interface RechargeHelper ()
//<WXApiDelegate> {
//}

@end

@implementation RechargeHelper

+ (id)defaultRechargeHelper {
    static RechargeHelper *helper;
    if (!helper) {
        helper = [[RechargeHelper alloc] init];
    }
    return helper;
}

+ (void)setAliPayNotifyURLString:(NSString *)aliStr {
    AliPayCallbackURL = aliStr;
}

- (void)payAliWithMoney:(double)money {
    
    Order *order = [[Order alloc] init];
    order.partner = AliPartner;
    order.seller = AliSeller;
    order.tradeNO = [RechargeHelper generateTradeNOWithLength:15]; //订单ID（由商家自行制定）
    order.productName = @"在线充值"; //商品标题
    order.productDescription = @"支付宝充值"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f", money]; //商品价格
//    order.notifyURL = Notify_AlipayCallback_Url; //回调URL  101--充值操作代码
    order.notifyURL = AliPayCallbackURL;
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(AliPrivateKey);
    NSString *signedString = [signer signString:[order description]];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       [order description], signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"XBBAPP" callback:^(NSDictionary *resultDic) {
            //                    9000
            //                    订单支付成功
            //                    8000
            //                    正在处理中
            //                    4000
            //                    订单支付失败
            //                    6001
            //                    用户中途取消
            //                    6002
            //                    网络连接出错
            NSLog(@"reslut = %@",resultDic);
            [RechargeHelper handleWithAliCallbackDic:resultDic];
        }];
        
    }

}

- (void)payAliWithMoney:(double)money orderNO:(NSString *)orderNO productTitle:(NSString *)title productDescription:(NSString *)description {
    Order *order = [[Order alloc] init];
    order.partner = AliPartner;
    order.seller = AliSeller;
    order.tradeNO = orderNO; //订单ID（由商家自行制定）
    order.productName = title; //商品标题
    order.productDescription = description; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f", money]; //商品价格
//    order.notifyURL = [Notify_AlipayCallback_Url stringByAppendingString:orderNO]; //回调URL  101--充值操作代码
    order.notifyURL = Notify_AlipayCallback_Url;
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(AliPrivateKey);
    NSString *signedString = [signer signString:[order description]];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       [order description], signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"XBBAPP" callback:^(NSDictionary *resultDic) {
            //                    9000
            //                    订单支付成功
            //                    8000
            //                    正在处理中
            //                    4000
            //                    订单支付失败
            //                    6001
            //                    用户中途取消
            //                    6002
            //                    网络连接出错
            NSLog(@"reslut = %@",resultDic);
            [RechargeHelper handleWithAliCallbackDic:resultDic];
        }];
        
    }
}

/*
- (void)payWeChatWithMoney:(double)money {
    if (![WXApi isWXAppInstalled]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRecharge object:[RechargeResultObject resultWithResultStatus:0 successful:NO message:@"未安装微信客户端"]];
        return;
    }
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = WeChatPartnerId;
    request.prepayId= @"1101000000140415649af9fc314aa427";
    request.package = @"Sign=WXPay";
    request.nonceStr= [RechargeHelper generateTradeNOWithLength:32];
    request.timeStamp= [[NSDate date] timeIntervalSince1970];
    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    [WXApi sendReq:request];
}
 */

+ (NSString *)generateTradeNOWithLength:(int)kNumber {
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+ (void)handleWithAliCallbackDic:(NSDictionary *)dic {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    switch ([dic[@"resultStatus"] integerValue]) {
        case 9000:
            [notificationCenter postNotificationName:NotificationRecharge object:[RechargeResultObject resultWithResultStatus:[[dic objectForKey:@"resultStatus"] intValue] successful:YES message:@"订单支付成功"]];
            break;
        case 8000:
            [notificationCenter postNotificationName:NotificationRecharge object:[RechargeResultObject resultWithResultStatus:[[dic objectForKey:@"resultStatus"] intValue] successful:YES message:@"正在处理中"]];
            break;
        case 4000:
            [notificationCenter postNotificationName:NotificationRecharge object:[RechargeResultObject resultWithResultStatus:[[dic objectForKey:@"resultStatus"] intValue] successful:NO message:@"订单支付失败"]];
            break;
        case 6001:
            [notificationCenter postNotificationName:NotificationRecharge object:[RechargeResultObject resultWithResultStatus:[[dic objectForKey:@"resultStatus"] intValue] successful:NO message:@"用户中途取消"]];
            break;
        case 6002:
            [notificationCenter postNotificationName:NotificationRecharge object:[RechargeResultObject resultWithResultStatus:[[dic objectForKey:@"resultStatus"] intValue] successful:NO message:@"网络连接错误"]];
            break;
        default:
            break;
    }
}
/*
- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            caseWXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRecharge object:[RechargeResultObject resultWithResultStatus:0 successful:YES message:@"支付成功"]];
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                NSString *msg;
                if (resp.errCode == -2) {
                    msg = @"用户取消";
                } else {
                    msg = @"支付失败";
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRecharge object:[RechargeResultObject resultWithResultStatus:0 successful:NO message:msg]];
                break;
        }
    }
}
*/
@end
