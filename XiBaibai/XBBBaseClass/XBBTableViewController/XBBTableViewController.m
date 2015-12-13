//
//  XBBTableViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/12/4.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBTableViewController.h"

@interface XBBTableViewController () 

@end

@implementation XBBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
}


- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XBB_Screen_width, XBB_Screen_height-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)addTabelView:(UITableViewStyle)style
{
    if (self.tableView) {
         [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    
    CGFloat  hight = 0;
    if (self.showNavigation) {
        hight = 64;
    }else
    {
        hight = 0;
    }
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, hight, XBB_Screen_width, XBB_Screen_height-hight) style:style];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    return cell;
}





@end
