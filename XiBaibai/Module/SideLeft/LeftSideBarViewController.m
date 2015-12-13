//
//  LeftSideBarViewController.m
//  SideBar
//
//  Created by Daniel on 15/8/25.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "LeftSideBarViewController.h"
#import "XBBHomeViewController.h"
#import "UserObj.h"
#import "AllCommentViewController.h"
#import "XBBMyCenterViewController.h"
#import "MyCarTableViewController.h"
#import "MyLiCouponViewController.h"
#import "WebViewController.h"
#import "MyCouponsViewController.h"
#import "FeedbackTableViewController.h"
#import "CarportTableViewController.h"
#import "XBBAddressViewController.h"



@interface LeftSideBarViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIButton *myOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation LeftSideBarViewController


#pragma mark systemSetup

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setVersionString];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful:) name:NotificationLoginSuccessful object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:NotificationLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserSuccessful:) name:NotificationUpdateUserSuccessful object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Personal Center

- (IBAction)goMyCenterWhenTapHeader:(UIGestureRecognizer *)sender {
    
    XBBMyCenterViewController *centerVC = [[XBBMyCenterViewController alloc] init];
    [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:centerVC animated:YES];
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {

        
    }];
}

- (void)loginSuccessful:(NSNotification *)sender {
    [self.avatarImageView setHidden:NO];
    [self.summaryLabel setHidden:NO];
    [self.nameLabel setHidden:NO];
    UserObj *userInfo = [UserObj shareInstance];
    if([userInfo.imgstring  isKindOfClass:[NSNull class]]){
        self.avatarImageView.image=[UIImage imageNamed:@"nav1.png"];
    }else{
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, userInfo.imgstring]]];
    }
    self.summaryLabel.text = userInfo.iphone;
    if ([userInfo.uname isEqualToString:@""]) {
        userInfo.uname = @"洗白白";
    }
     self.nameLabel.text = userInfo.uname;
}

- (void)loginFailed:(NSNotification *)sender {
    [self.avatarImageView setHidden:YES];
    [self.summaryLabel setHidden:YES];
    [self.nameLabel setHidden:YES];
}

- (void)updateUserSuccessful:(NSNotification *)sender{
    UserObj *userInfo = [UserObj shareInstance];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, userInfo.imgstring]]];
    self.summaryLabel.text = userInfo.iphone;
    self.nameLabel.text = userInfo.uname;
}


#pragma mark order

- (IBAction)myOrderOnClick:(id)sender {
   
    if (IsLogin) {
         [self centerPushWithIdentifier:@"MyOrderViewController"];
    }else{
    }
   
}
- (void)centerPushWithIdentifier:(NSString *)identifier {
    UINavigationController *navigation = (UINavigationController *)self.mm_drawerController.centerViewController;
    [navigation pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier] animated:YES];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
    }];
}


#pragma mark setCars

- (IBAction)setCars:(UIButton *)sender {
    MyCarTableViewController *car =  [[MyCarTableViewController alloc] init];//[self.storyboard instantiateViewControllerWithIdentifier:@"MyCarTableViewController"];
    UINavigationController *nav = (UINavigationController *)self.mm_drawerController.centerViewController;
    [nav  pushViewController:car animated:YES];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    
}


#pragma mark setAddress

- (IBAction)address:(UIButton *)sender {
    
    XBBAddressViewController *cap = [[UIStoryboard storyboardWithName:@"XBBOne" bundle:nil] instantiateViewControllerWithIdentifier:@"XBBAddressViewController"];
    
//    CarportTableViewController *cap = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CarportTableViewController"];//[[CarportTableViewController alloc] init];
    UINavigationController *nav = (UINavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:cap animated:YES];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];

}


#pragma mark MyCoupons

- (IBAction)myLicoupon:(id)sender {
    MyCouponsViewController *myCouponsVC = [[MyCouponsViewController alloc] init];
    UINavigationController *nav = (UINavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:myCouponsVC animated:YES];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}


#pragma mark FeedBack

- (IBAction)fankui:(id)sender {
    
    FeedbackTableViewController *feed = [[UIStoryboard storyboardWithName:@"XBBOne" bundle:nil] instantiateViewControllerWithIdentifier:@"FeedbackTableViewController"];//[[FeedbackTableViewController alloc] init];
    UINavigationController *nav = (UINavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:feed animated:YES];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}


#pragma mark Connection We

- (IBAction)connectionCompany:(UIButton *)sender {
    NSString *phoneString = [[SystemObjct shareSystem] servicePhoneString]?[[SystemObjct shareSystem] servicePhoneString]:@"4000960787";
    if ([phoneString length] == 10 && [[phoneString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"4"]) {
        NSMutableString *pS = [NSMutableString string];
        [pS appendFormat:@"%@-%@-%@",[phoneString substringWithRange:NSMakeRange(0, 3)],[phoneString substringWithRange:NSMakeRange(3, 4)],[phoneString substringWithRange:NSMakeRange([phoneString length]-3, 3)]];
        phoneString = pS;
    }else if([phoneString length]==11 && [[phoneString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"02"])
    {
        NSMutableString *pS = [NSMutableString string];
        [pS appendFormat:@"%@-%@",[phoneString substringWithRange:NSMakeRange(0, 3)],[phoneString substringWithRange:NSMakeRange(3, [phoneString length]-3)]];
        phoneString = pS;
    }else
    {
        NSMutableString *pS = [NSMutableString string];
        [pS appendFormat:@"%@-%@",[phoneString substringWithRange:NSMakeRange(0, 4)],[phoneString substringWithRange:NSMakeRange(4, [phoneString length]-4)]];
        phoneString = pS;
    }
    UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:@"联系客服" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:phoneString otherButtonTitles:nil, nil];
    
    [sheetView showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self callPhone:[[SystemObjct shareSystem]servicePhoneString]?[[SystemObjct shareSystem] servicePhoneString]:@"4000960787"];
        }
            break;
            
        default:
            break;
    }
}

- (void)callPhone:(NSString *)number
{
    
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@",number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}


#pragma mark About

- (IBAction)guanyu:(id)sender {
    WebViewController *viewController = [[WebViewController alloc] init];
    viewController.navigationTitle = @"关于洗车APP";
    viewController.urlString =([[SystemObjct shareSystem] aboutUrlString])? [[SystemObjct shareSystem] aboutUrlString]:@"http://mp.weixin.qq.com/s?__biz=MzAxMTY4ODEyOQ==&mid=207988342&izdx=1&sn=a011a2b05c04d12fadc4eae58d404353&scene=18#rd";
    UINavigationController *nav = (UINavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:viewController animated:YES];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}


#pragma mark get-version

- (void)setVersionString
{
    self.versionLabel.text = [NSString stringWithFormat:@"版本 : %@",[self getVerisonString]];
}
- (NSString *)getVerisonString {
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    return appInfo[@"CFBundleShortVersionString"];
}



//- (void)login{
//
//    LoginViewController *loginVC=[[LoginViewController alloc] init];
//    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    [(UINavigationController *)self.mm_drawerController.centerViewController presentViewController:nv animated:YES completion:nil];
//}

//#pragma mark wall
//- (IBAction)myWalletOnClick:(id)sender {
//   
//    if (IsLogin) {
//        MyWallViewController *mywallVC=[[MyWallViewController alloc] init];
//        [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:mywallVC animated:YES];
//        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
//    }else{
//    }
//   
//}

//#pragma mark allComment
//
//- (IBAction)allCommentOnClick:(id)sender {
//    if (IsLogin) {
//        AllCommentViewController *commentVC = [[AllCommentViewController alloc] init];
//        [self presentViewController:commentVC animated:YES completion:nil];
////        [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:commentVC animated:YES];
//        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
//    }else{
//    }
//    
//
//}

//#pragma mark systemMsg
//
//- (IBAction)systemMsgOnClick:(id)sender {
//    if (IsLogin) {
//        [self centerPushWithIdentifier:@"SystemMsgViewController"];
//    } else {
//    }
//}

//#pragma mark Setting
//
//- (IBAction)settingOnClick:(id)sender {
//   
//    if (IsLogin) {
//        [self centerPushWithIdentifier:@"SettingTableViewController"];
//    }else{
//    }
//    
//}


@end
