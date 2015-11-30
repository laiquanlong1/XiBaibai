//
//  LeftSideBarViewController.m
//  SideBar
//
//  Created by Daniel on 15/8/25.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "LeftSideBarViewController.h"
#import "IndexViewController.h"
#import "MyCenterViewController.h"
#import "MyWallViewController.h"
#import "UserObj.h"
#import "MyOrderViewController.h"
#import "AllCommentViewController.h"
#import "LoginViewController.h"

@interface LeftSideBarViewController () <UIActionSheetDelegate>
{
    UserObj *user;
}

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIButton *myOrderButton;
@property (strong, nonatomic) UIButton *loginBtn;

@end

@implementation LeftSideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful:) name:NotificationLoginSuccessful object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:NotificationLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserSuccessful:) name:NotificationUpdateUserSuccessful object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goMyCenterWhenTapHeader:(UIGestureRecognizer *)sender {
    MyCenterViewController *centerVC = [[MyCenterViewController alloc] init];
    [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:centerVC animated:YES];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

- (void)loginFailed:(NSNotification *)sender {
   
    [self.avatarImageView setHidden:YES];
    [self.summaryLabel setHidden:YES];
    [self.nameLabel setHidden:YES];
    
    if (!self.loginBtn) {
        self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 35, 100, 50)];
        self.loginBtn.backgroundColor = kUIColorFromRGB(0xCCCCCC);
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.loginBtn];
}

- (void)login{
    
    LoginViewController *loginVC=[[LoginViewController alloc] init];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [(UINavigationController *)self.mm_drawerController.centerViewController presentViewController:nv animated:YES completion:nil];
//    LoginViewController *loginVC=[[LoginViewController alloc] init];
//    [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:loginVC animated:YES];
//    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

- (void)loginSuccessful:(NSNotification *)sender {
    [self.loginBtn removeFromSuperview];
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

- (void)updateUserSuccessful:(NSNotification *)sender{
    UserObj *userInfo = [UserObj shareInstance];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, userInfo.imgstring]]];
    self.summaryLabel.text = userInfo.iphone;
    self.nameLabel.text = userInfo.uname;
}

- (IBAction)myOrderOnClick:(id)sender {
   
    if (IsLogin) {
         [self centerPushWithIdentifier:@"MyOrderViewController"];
    }else{
        [self login];
    }
   
}

- (IBAction)myWalletOnClick:(id)sender {
   
    if (IsLogin) {
        MyWallViewController *mywallVC=[[MyWallViewController alloc] init];
        [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:mywallVC animated:YES];
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }else{
        [self login];
    }
   
}

- (IBAction)allCommentOnClick:(id)sender {
    if (IsLogin) {
        AllCommentViewController *commentVC = [[AllCommentViewController alloc] init];
        [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:commentVC animated:YES];
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }else{
        [self login];
    }
    

}

- (IBAction)systemMsgOnClick:(id)sender {
    if (IsLogin) {
        [self centerPushWithIdentifier:@"SystemMsgViewController"];
    } else {
        GoToLogin(self);
    }
}

- (IBAction)settingOnClick:(id)sender {
   
    if (IsLogin) {
        [self centerPushWithIdentifier:@"SettingTableViewController"];
    }else{
        [self login];
    }
    
}


- (void)centerPushWithIdentifier:(NSString *)identifier {
    UINavigationController *navigation = (UINavigationController *)self.mm_drawerController.centerViewController;
    [navigation pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier] animated:YES];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}


#pragma mark 联系客服

- (IBAction)connectionCompany:(UIButton *)sender {
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"联系客服" message:@"400-0960-787" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    [alertView show];
    //
    UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:@"联系客服" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"400-0960-787" otherButtonTitles:nil, nil];
    
    [sheetView showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self callPhone:@"4000960787"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 实现打电话功能
- (void)callPhone:(NSString *)number
{
    
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@",number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
