//
//  ComplaintViewController.m
//  XBB
//
//  Created by Apple on 15/9/19.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "ComplaintViewController.h"
#import "UserObj.h"

@interface ComplaintViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@end

@implementation ComplaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nameLabel.text = _emp_name;
    _numberLabel.text = _emp_num;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, _emp_img]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneOnTouch:(id)sender {
    if ([_inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入投诉内容"];
    } else {
        [SVProgressHUD show];
        [NetworkHelper postWithAPI:API_Complaint parameter:@{@"uid": [UserObj shareInstance].uid, @"emp_id": _emp_id, @"comtent": _inputTextView.text} successBlock:^(id response) {
            if ([response[@"code"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"投诉成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"评价失败"];
        }];
    }
}

- (IBAction)backOnTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
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
