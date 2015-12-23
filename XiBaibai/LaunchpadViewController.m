//
//  LaunchpadViewController.m
//  XiBaibai
//
//  Created by xbb01 on 15/12/23.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "LaunchpadViewController.h"

@interface LaunchpadViewController ()

@end

@implementation LaunchpadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (XBB_IsIphone4s) {
        self.launchImage.image = [UIImage imageNamed:@"laun4s"];
    }else
    {
        self.launchImage.image = [UIImage imageNamed:@"laun"];
    }
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
