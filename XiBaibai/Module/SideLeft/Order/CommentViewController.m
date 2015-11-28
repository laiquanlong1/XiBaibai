//
//  CommentViewController.m
//  XBB
//
//  Created by Apple on 15/9/19.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "CommentViewController.h"
#import "StarView.h"
#import "UserObj.h"

@interface CommentViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *starBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (strong, nonatomic) StarView *scoreStarView;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scoreStarView = [StarView starView];
    [self.starBackgroundView addSubview:self.scoreStarView];
    [self.scoreStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.starBackgroundView);
        make.size.mas_equalTo(self.scoreStarView.frame.size);
    }];
    [self.starBackgroundView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanStar:)]];
    _nameLabel.text = _emp_name;
    _numberLabel.text = _emp_num;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", ImgDomain, _emp_img]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlePanStar:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint pt = [sender translationInView:self.starBackgroundView];
        pt.x = self.starBackgroundView.frame.size.width * self.scoreStarView.score / 5;
        [sender setTranslation:pt inView:self.starBackgroundView];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat x = [sender translationInView:self.starBackgroundView].x / self.starBackgroundView.frame.size.width;
        NSLog(@"%@", @(x));
        if (x <= 0.05) {
            self.scoreStarView.score = 0;
        } else if (x <= 0.1) {
            self.scoreStarView.score = 0.5;
        } else if (x  <= 0.2) {
            self.scoreStarView.score = 1;
        } else if (x <= 0.3) {
            self.scoreStarView.score = 1.5;
        } else if (x <= 0.4) {
            self.scoreStarView.score = 2;
        } else if (x <= 0.5) {
            self.scoreStarView.score = 2.5;
        } else if (x <= 0.6) {
            self.scoreStarView.score = 3;
        } else if (x <= 0.7) {
            self.scoreStarView.score = 3.5;
        } else if (x <= 0.8) {
            self.scoreStarView.score = 4;
        } else if (x <= 0.9) {
            self.scoreStarView.score = 4.5;
        } else {
            self.scoreStarView.score = 5;
        }
    }
}


- (IBAction)doneOnTouch:(id)sender {
    if ([_inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入评论内容"];
    } else {
        [SVProgressHUD show];
        [NetworkHelper postWithAPI:API_CommentInsert parameter:@{@"order_id": _order_id, @"uid": [UserObj shareInstance].uid, @"emp_id": _emp_id, @"comment": _inputTextView.text, @"star": @(self.scoreStarView.score)} successBlock:^(id response) {
            if ([response[@"code"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"评价成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOrderListUpdate object:nil];
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
