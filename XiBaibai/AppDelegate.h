//
//  AppDelegate.h
//  XiBaibai
//
//  Created by Apple on 15/9/20.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)shareMonsouAppDelegate; // 共享 AppDelegate

@end

