//
//  MyCarTableViewCell.m
//  XBB
//
//  Created by Apple on 15/9/4.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "MyCarTableViewCell.h"
#import "UserObj.h"

@implementation MyCarTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)btnSetDefalut:(id)sender {
//    [SVProgressHUD show];
//    NSLog(@"defalut%d",self.btnDefault.tag);
//    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setObject:[NSString stringWithFormat:@"%@",[UserObj shareInstance].uid] forKey:@"uid"];
//    [dic setObject:[NSString stringWithFormat:@"%d",self.btnDefault.tag] forKey:@"id"];
//    [NetworkHelper postWithAPI:API_set_default_car parameter:dic successBlock:^(id response) {
//        [SVProgressHUD showSuccessWithStatus:@"设置成功"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationSetDefalutCar object:nil];
//        NSLog(@"response%@",response);
//    } failBlock:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"设置失败"];
//    }];
    
}
@end
