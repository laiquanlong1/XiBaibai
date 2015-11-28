//
//  mach.h
//  XBB
//
//  Created by Daniel on 15/8/14.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#ifndef XBB_mach_h
#define XBB_mach_h
#import "MyCenterViewController.h"
#import "IndexViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件
#import "UIImageView+WebCache.h"
#import "AFHelperViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsynchronousKeyValueLoading.h>
#import "SVProgressHUD.h"


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kUIColorFromRGB_alpha(rgbValue,al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]
#define TITLEFONT [UIFont boldSystemFontOfSize:18.]
#endif
