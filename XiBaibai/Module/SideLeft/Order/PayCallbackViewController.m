//
//  PayCallbackViewController.m
//  XBB
//
//  Created by Apple on 15/9/19.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "PayCallbackViewController.h"
#import "OrderInfoViewController.h"

@interface PayCallbackViewController ()

@property (weak, nonatomic) IBOutlet UIButton *lookOrderBtn;

@end

@implementation PayCallbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lookOrderBtn.layer.cornerRadius = 4;
    self.lookOrderBtn.layer.borderWidth = 0.5;
    self.lookOrderBtn.layer.borderColor = kUIColorFromRGB(0xDFDFDF).CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backOnTouch {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)lookOrderInfoOnTouch {
    OrderInfoViewController *viewcontroller = [[OrderInfoViewController alloc] init];
    viewcontroller.order_id = self.orderId;
    [self.navigationController pushViewController:viewcontroller animated:YES];
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
