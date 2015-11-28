//
//  CustamViewController.m
//  XBB
//
//  Created by Daniel on 15/7/24.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "CustamViewController.h"

@interface CustamViewController ()

@end

@implementation CustamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+ (UIButton *)createButton{
    UIButton *btn=[[UIButton alloc] init];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:5.0];
    [btn.layer setBorderWidth:1.0];
    [btn setBackgroundColor:[UIColor purpleColor]];
    [btn.layer setBorderColor:[UIColor blueColor].CGColor];
    return btn;
}


+ (UILabel *)CreateLab:(UIView *)view withLab:(UILabel *)labName withTopbei:(NSInteger )Tbei withTopJuli:(NSInteger )Tjuli withLeftbei:(NSInteger )Lbei withLeftJuli:(NSInteger )Ljuli withHeightBei:(NSInteger )Hbei withHeight:(NSInteger )height withWidthBei:(NSInteger )WBei withWidth:(NSInteger )width{
    labName = [[UILabel alloc] init];
    [view addSubview:labName];
    
    labName.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:labName
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:Tbei
                                                      constant:Tjuli]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:labName
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:Lbei
                                                      constant:Ljuli]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:labName
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:Hbei
                                                      constant:height]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:labName
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:WBei
                                                      constant:width]];
    
    return labName;

}

+ (UITextField *)createText{
    UITextField *txt=[[UITextField alloc] init];
    [txt.layer setMasksToBounds:YES];
    [txt.layer setCornerRadius:5.0];
    [txt.layer setBorderWidth:1.0];
    [txt.layer setBorderColor:[UIColor blueColor].CGColor];
    
    return txt;
}

+ (UIAlertView *)createAlertViewTitleStr:(NSString *)title withMsg:(NSString *)msg widthDelegate:(id )delegate withCancelBtn:(NSString *)canceltitle withbtns:(NSString *)btntitle{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:canceltitle otherButtonTitles:btntitle, nil];
    return alert;
}

+ (UIActionSheet *)createActionSheetWithTitle:(NSString *)title withDelegate:(id)delegate withCancel:(NSString *)cancelButton withdetructivebutton:(NSString *)topBtn withotherbtn:(NSString *)otherBtn withothers:(NSString *)othertwo{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:title
                                  delegate:delegate
                                  cancelButtonTitle:cancelButton
                                  destructiveButtonTitle:topBtn
                                  otherButtonTitles:otherBtn,othertwo,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    return actionSheet;
}


+ (UILabel *)cellCreateLab:(UIView *)view withLab:(UILabel *)labName withTopbei:(NSInteger )Tbei withTopJuli:(NSInteger )Tjuli withLeftbei:(NSInteger )Lbei withLeftJuli:(NSInteger )Ljuli withHeightBei:(NSInteger )Hbei withHeight:(NSInteger )height withWidthBei:(NSInteger )WBei withWidth:(NSInteger )width{
    labName = [[UILabel alloc] init];
    [view addSubview:labName];
    
    labName.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:labName
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:view
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:Tbei
                                                                  constant:Tjuli]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:labName
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:view
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:Lbei
                                                                  constant:Ljuli]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:labName
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:view
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:Hbei
                                                                  constant:height]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:labName
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:view
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:WBei
                                                                  constant:width]];
    
    return labName;

}

+ (UIImageView *)cellCreateImgView:(UIView *)view withImgView:(UIImageView *)ImgViewName withTopbei:(NSInteger )Tbei withTopJuli:(NSInteger )Tjuli withLeftbei:(NSInteger )Lbei withLeftJuli:(NSInteger )Ljuli withHeightBei:(NSInteger )Hbei withHeight:(NSInteger )height withWidthBei:(NSInteger )WBei withWidth:(NSInteger )width{
    ImgViewName = [[UIImageView alloc] init];
    [view addSubview:ImgViewName];
    
    ImgViewName.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:ImgViewName
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:Tbei
                                                      constant:Tjuli]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:ImgViewName
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:Lbei
                                                      constant:Ljuli]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:ImgViewName
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:Hbei
                                                      constant:height]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:ImgViewName
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:WBei
                                                      constant:width]];
    
    return ImgViewName;
    
}

+ (void)dreawHenxian:(NSString *)oldPrice withLab:(UILabel *)labPriceOld{
    NSUInteger length = [oldPrice length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:kUIColorFromRGB(0x999999) range:NSMakeRange(0, length)];
    [labPriceOld setAttributedText:attri];
}

//计算经纬度之间的距离
+(double)distanceBetweenOrderByLat1:(double)lat1 withLat2:(double)lat2 withLng1:(double)lng1 withLng2:(double)lng2{
    double dd = M_PI/180;
    double x1=lat1*dd,x2=lat2*dd;
    double y1=lng1*dd,y2=lng2*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    //km  返回
    //     return  distance*1000;
    
    //返回 m
    return   distance;
}


//表
+ (void)setLayoutMarginsForTableView:(UITableView*)tableView{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        
        
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

//cell
+ (void)setUpCellLayoutMargins:(UITableViewCell*)cell{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
        
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}


@end
