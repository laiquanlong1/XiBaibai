//
//  CustamViewController.h
//  XBB
//
//  Created by Daniel on 15/7/24.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mach.h"

@interface CustamViewController : UIViewController

+ (UIButton *)createButton;

+ (UILabel *)CreateLab:(UIView *)view withLab:(UILabel *)labName withTopbei:(NSInteger )Tbei withTopJuli:(NSInteger )Tjuli withLeftbei:(NSInteger )Lbei withLeftJuli:(NSInteger )Ljuli withHeightBei:(NSInteger )Hbei withHeight:(NSInteger )height withWidthBei:(NSInteger )WBei withWidth:(NSInteger )width;

+ (UITextField *)createText;

+ (UIAlertView *)createAlertViewTitleStr:(NSString *)title withMsg:(NSString *)msg widthDelegate:(id )delegate withCancelBtn:(NSString *)canceltitle withbtns:(NSString *)btntitle;

+ (UIActionSheet *)createActionSheetWithTitle:(NSString *)title withDelegate:(id)delegate withCancel:(NSString *)cancelButton withdetructivebutton:(NSString *)topBtn withotherbtn:(NSString *)otherBtn withothers:(NSString *)othertwo;

+ (UILabel *)cellCreateLab:(UIView *)view withLab:(UILabel *)labName withTopbei:(NSInteger )Tbei withTopJuli:(NSInteger )Tjuli withLeftbei:(NSInteger )Lbei withLeftJuli:(NSInteger )Ljuli withHeightBei:(NSInteger )Hbei withHeight:(NSInteger )height withWidthBei:(NSInteger )WBei withWidth:(NSInteger )width;

+ (UIImageView *)cellCreateImgView:(UIView *)view withImgView:(UIImageView *)ImgViewName withTopbei:(NSInteger )Tbei withTopJuli:(NSInteger )Tjuli withLeftbei:(NSInteger )Lbei withLeftJuli:(NSInteger )Ljuli withHeightBei:(NSInteger )Hbei withHeight:(NSInteger )height withWidthBei:(NSInteger )WBei withWidth:(NSInteger )width;

+ (void)dreawHenxian:(NSString *)oldPrice withLab:(UILabel *)labPriceOld;

//计算经纬度之间的距离
+(double)distanceBetweenOrderByLat1:(double)lat1 withLat2:(double)lat2 withLng1:(double)lng1 withLng2:(double)lng2;

//表
+ (void)setLayoutMarginsForTableView:(UITableView*)tableView;

//cell
+ (void)setUpCellLayoutMargins:(UITableViewCell*)cell;

///**
// *  UITableViewCell两边线条为屏幕宽度（列表也需要设置）
// *
// *  @param cell 列表cell
// */
//+ (void)setUpCellLayoutMargins:(UITableViewCell *)cell;
//
///**
// *  列表多于的线条去掉
// *
// *  @param tableView 加载的tableview
// *  @return
// */
//+ (void)setExtraCellLineHidden: (UITableView *)tableView;

@end
