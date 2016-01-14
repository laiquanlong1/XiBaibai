//
//  LuanchViewController.m
//  XiBaibai
//
//  Created by xbb01 on 16/1/14.
//  Copyright © 2016年 Mingle. All rights reserved.
//

#import "LuanchViewController.h"

@interface LuanchViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ImageViews;

@end

@implementation LuanchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (XBB_IsIphone4s) {
        self.ImageViews.image = [UIImage imageNamed:@"laun4s"];
    }else
    {
        self.ImageViews.image = [UIImage imageNamed:@"laun"];
    }
    
    
    
    
    // Do any additional setup after loading the view from its nib.
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
