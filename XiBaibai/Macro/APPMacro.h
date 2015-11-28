//
//  APPMacro.h
//  XBB
//
//  Created by Apple on 15/9/16.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#ifndef XBB_APPMacro_h
#define XBB_APPMacro_h
#import "LoginViewController.h"

/**
 * @brief 判断是否登录
 * @detail 是否登录使用UserDefaults保存
 **/
#define IsLogin [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ? YES : NO

/**
 * @brief 跳转至登录页面
 * @detail 根据情况跳转至登录页面
 * @param  currentVC: 当前展示vc
 * @returnType 展示登录页面
 **/
#define GoToLogin(currentVC) {LoginViewController *loginVC=[[LoginViewController alloc] init];[(UINavigationController *)currentVC.mm_drawerController.centerViewController pushViewController:loginVC animated:YES];[currentVC.mm_drawerController closeDrawerAnimated:YES completion:nil];}


/**
 * @brief 封装图片路径
 * @detail 根据图片名字获取一个路径
 * @param  传入图片名字
 * @returnType 返回一个图片路径
 **/
#define ImgURLWithImgName(imgName) [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, imgName]]


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif



#endif
