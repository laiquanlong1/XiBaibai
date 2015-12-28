//
//  AppDelegate.m
//  XiBaibai
//
//  Created by Apple on 15/9/20.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "AppDelegate.h"
#import "XBBHomeViewController.h"
#import "LeftSideBarViewController.h"
#import "MMDrawerController.h"
#import "RechargeHelper.h"
#import <AlipaySDK/AlipaySDK.h>
#import <BaiduMapAPI/BMapKit.h>
#import "VendorMacro.h"
#import "BPush.h"
#import "XBBHomeViewController.h"
#import "ZWIntroductionViewController.h"
#import "LaunchpadViewController.h"


@interface AppDelegate () <BMKGeneralDelegate>

@end

@implementation AppDelegate

/**
 * @brief 获取UIApplicationDelegate
 * @detail 获取唯一的UIApplicationDelegate
 **/
+ (AppDelegate *)shareMonsouAppDelegate {
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    return app;
}


- (void)toSetRootViewController
{
    self.window.rootViewController = [[LoginViewController alloc] init];
}

- (void)tosetOnerootViewController
{
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyNavigationController"] leftDrawerViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeftSideBarViewController"]];
    drawerController.maximumLeftDrawerWidth = XBB_Screen_width - 60.;//240.;
    drawerController.showsShadow = NO;
    //    drawerController.animationVelocity = 0.1;
    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    drawerController.shouldStretchDrawer = NO;
    
    BOOL isFirstUse = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLogin"];
    if (isFirstUse == NO) {
        
        ZWIntroductionViewController *zin = [[ZWIntroductionViewController alloc] init];
        if (XBB_IsIphone4s) {
            zin.coverImageNames = @[@"page14s",@"page24s",@"page34s"];
            
        }else
        {
            zin.coverImageNames = @[@"page1",@"page2",@"page3"];
        }
        zin.didSelectedEnter = ^{
            [UIView beginAnimations:@"tosetro" context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationDidStopSelector:@selector(toSetRootViewController)];
            [UIView setAnimationDelegate:self];
            
            for (UIViewController *vc in self.window.rootViewController.childViewControllers) {
                if ([vc isKindOfClass:[ZWIntroductionViewController class]]) {
                    CGRect frame = self.window.rootViewController.view.frame;
                    frame.origin.x -= XBB_Screen_width;
                    vc.view.frame = frame;
                }else if ([vc isKindOfClass:[LoginViewController class]])
                {
                    vc.view.alpha = 1.;
                }
            }
            [UIView commitAnimations];
        };
        UIViewController *controller = [[UIViewController alloc] init];
        [controller addChildViewController:[[LoginViewController alloc] init]];
        [controller addChildViewController:zin];
        for (UIViewController *vc in controller.childViewControllers) {
            if ([vc isKindOfClass:[ZWIntroductionViewController class]]) {
                vc.view.alpha = 1.;
            }
            else
            {
                vc.view.alpha = 0.;
            }
            [controller.view addSubview:vc.view];
        }
        self.window.rootViewController = controller;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    
    if (IsLogin) {
        self.window.rootViewController =  drawerController;
    }else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        self.window.rootViewController = login;
        
    }

}

/**
 * @brief 程序启动的时候调用
 * @detail 传入的应用
 * @param  application: 传入的应用  launchOptions:传入的启动信息
 * @returnType 返回BOOL值
 **/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 要使用百度地图，请先启动BaiduMapManager
    BMKMapManager * _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:Baidu_AK generalDelegate:self];
    
    if (!ret) {
        NSLog(@"授权失败");
    }
    
    // iOS8 下需要使用新的 API（注册推送）
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    /**
     * @brief 百度云推送
     * @detail 使用的是百度云推送
     * @param  apiKey:key值  pushMode: 推送环境 
     * @returnType void
     **/
    [BPush registerChannel:launchOptions apiKey:Baidu_AK pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
    
    /**
     * @brief 将应用图标数设置为0
     * @detail 设置应用图标数为0
     **/
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
 
    /**
     * @brief 设置状态栏风格
     * @detail 设置状态栏风格
     **/
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    
    
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[LaunchpadViewController alloc] init];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self tosetOnerootViewController];
    });
    return YES;
}

/**
 * @brief 接受到远程消息
 * @detail 当应用程序接收到远程的信息时调用
 * @param  application: 应用程序  userInfo:远程信息字典 completionHandler:完成后的block调用
 * @returnType void
 **/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // 带出参数（背景后去结果为新数据）
    completionHandler(UIBackgroundFetchResultNewData);
    
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    /**
     * @brief  注册新的远程通知
     * @detail 注册新的通知
     **/
    [application registerForRemoteNotifications];
}


/**
 * @brief 应用已经注册好消息通知
 * @detail 应用已经注册远程通知根据deviceToken
 **/
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    /**
     * @brief 注册百度推送
     * @detail 
     **/
    [BPush registerDeviceToken:deviceToken];
    
    /**
     * @brief 绑定channel.将会在回调中看获得channnelid appid userid 等。
     * @param
     *     none
     * @return
     *     none
     */
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        
    }];
    
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    
    NSLog(@"%@",userInfo);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


/**
 * @brief 应用程序将要进入前台
 * @detail 应用程序将要进入前台设置状态栏风格
 **/
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [RechargeHelper handleWithAliCallbackDic:resultDic];
        }];
    }
    return YES;
}

/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError{
    NSLog(@"onGetNetworkState:%d",iError);
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError{
    NSLog(@"onGetPermissionState:%d",iError);
}

@end
