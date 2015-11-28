//
//  CarListTableViewController.m
//  XiBaibai
//
//  Created by Apple on 15/9/20.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "CarListTableViewController.h"
#import "MJExtension.h"

@interface CarListTableViewController ()

@property (strong, nonatomic) NSMutableArray *brandArr, *firstWordArr;
@property (strong, nonatomic) NSMutableDictionary *brandDic;

@end

@implementation CarListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"选择车辆品牌";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1@icon_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(backOnTouch)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self fetchCarbrandFromWeb:nil];
}

- (void)backOnTouch {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchCarbrandFromWeb:(void (^)())callback {
    [SVProgressHUD show];
    [NetworkHelper postWithAPI:API_AllCarbrandSelect parameter:nil successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            [CarBrandModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"brandId": @"id"};
            }];
            self.firstWordArr = [NSMutableArray array];
            
            for (NSDictionary *temp in response[@"result"]) {
                CarBrandModel *model = [CarBrandModel objectWithKeyValues:temp];
                if (![self.firstWordArr containsObject:model.first_letter]) {
                    [self.firstWordArr addObject:model.first_letter];
                }
            }
            
            self.brandDic = [NSMutableDictionary dictionary];
            for (NSString *firstWork in self.firstWordArr) {
                [self.brandDic setObject:[NSMutableArray array] forKey:firstWork];
            }
            for (NSDictionary *temp in response[@"result"]) {
                CarBrandModel *model = [CarBrandModel objectWithKeyValues:temp];
                NSMutableArray *arr = [self.brandDic objectForKey:model.first_letter];
                [arr addObject:model];
                
            }
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.firstWordArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.brandDic objectForKey:self.firstWordArr[section]] count];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.firstWordArr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // Configure the cell...
    CarBrandModel *model = [[self.brandDic objectForKey:self.firstWordArr[indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text =  model.make_name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@" %@", self.firstWordArr[section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CarBrandModel *model = [[self.brandDic objectForKey:self.firstWordArr[indexPath.section]] objectAtIndex:indexPath.row];
    if (self.brandSelectedCallback) {
        self.brandSelectedCallback(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
