//
//  MyDrawerController.m
//  XBB
//
//  Created by Apple on 15/8/30.
//  Copyright (c) 2015年 marnow. All rights reserved.
//

#import "MyDrawerController.h"
#import "XBBHomeViewController.h"
#import "LeftSideBarViewController.h"

@interface MyDrawerController ()

@end

@implementation MyDrawerController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UINavigationController *centerNav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyNavigationController"];
        MMDrawerController *drawerController = self;
        drawerController.centerViewController = centerNav;
        drawerController.leftDrawerViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeftSideBarViewController"];
        drawerController.showsShadow = NO;
        drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
        drawerController.shouldStretchDrawer = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

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

@end
