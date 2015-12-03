//
//  SearchViewController.m
//  XBB
//
//  Created by Apple on 15/9/15.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *textBackView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textBackView.frame = CGRectMake(0, 0, self.view.frame.size.width - 60, self.textBackView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backOnTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
//    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:9];
//    UILabel *summaryLabel = (UILabel *)[cell.contentView viewWithTag:10];
    return cell;
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
