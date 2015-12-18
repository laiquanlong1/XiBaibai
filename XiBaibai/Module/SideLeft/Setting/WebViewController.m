//
//  WebViewController.m
//  XBB
//
//  Created by Apple on 15/9/4.
//  Copyright (c) 2015年 Mingle. All rights reserved.
//

#import "WebViewController.h"
#import "XBBListHeadLabel.h"
#import "XBBDiyObject.h"
#import "XBBDIYViewController.h"
#import "AddOrderViewController.h"
#import "XBBFacialViewController.h"
#import "XBBOrder.h"
#import "UserObj.h"
#import "MyCarTableViewController.h"

@interface WebViewController ()<UIAlertViewDelegate>
{
    XBBListHeadLabel *priceTotalTitle;
    UIView *barView;
    float allPrice;
}
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (void)initUI
{
    [self setNavigationBarControl];
    [self initWeb];
}
- (void)setNavigationBarControl
{
    self.showNavigation = YES;
    UIImage *leftImage = [UIImage imageNamed:@"back_xbb"];
    if (XBB_IsIphone6_6s) {
        leftImage = [UIImage imageNamed:@"back_xbb6"];
    }
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.userInteractionEnabled = YES;
    [backButton addTarget:self action:@selector(backViewController:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:leftImage forState:UIControlStateNormal];
    [self.xbbNavigationBar addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.centerY.mas_equalTo(self.xbbNavigationBar).mas_offset(9.f);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *titelLabel = [[UILabel alloc] init];
    [titelLabel setTextColor:[UIColor whiteColor]];
    [titelLabel setBackgroundColor:[UIColor clearColor]];
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"banner"];
    [titelLabel setFont:XBB_NavBar_Font];
    [titelLabel setTextAlignment:NSTextAlignmentCenter];
    [self.xbbNavigationBar addSubview:titelLabel];
    [titelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30.);
        make.centerY.mas_equalTo(self.xbbNavigationBar).mas_offset(10.f);
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(XBB_Screen_width-100);
    }];
}

- (void)addAllPrice
{
    
    priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",allPrice>0?allPrice:0.00];
}

- (void)setUpUIPriceBar
{
    UIView *barView_back = [[UIView alloc] initWithFrame:CGRectMake(0, 64., XBB_Screen_width, 70.)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20., 10, 120, 30.)];
    nameLabel.text = self.proObject.p_name;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(XBB_Screen_width - 200, 10, 185, 30.)];
    priceLabel.text = [NSString stringWithFormat:@"轿车 ¥ %.2f",self.proObject.price_1];
    [priceLabel setTextAlignment:NSTextAlignmentRight];
    
    
    UILabel *priceLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(XBB_Screen_width - 200, 10+30, 185, 30.)];
    priceLabel_1.text = [NSString stringWithFormat:@"SUV/MPV ¥ %.2f",self.proObject.price_2];
    [barView_back addSubview:priceLabel_1];
    [priceLabel_1 setTextAlignment:NSTextAlignmentRight];
    
    [priceLabel setFont:[UIFont systemFontOfSize:14.]];
    [priceLabel_1 setFont:[UIFont systemFontOfSize:14.]];
    [barView_back addSubview:priceLabel];
    [barView_back addSubview:nameLabel];
    

    [self.view addSubview:barView_back];
}

- (void)addTabBar
{
    barView = [[UIView alloc] initWithFrame:CGRectMake(0, XBB_Screen_height-44., XBB_Screen_width, 44.)];
    [self.view addSubview:barView];
    barView.backgroundColor = XBB_Bg_Color;
    barView.layer.borderWidth = 0.5;
    barView.layer.borderColor = XBB_NavBar_Color.CGColor;
    
//    priceTotalTitle = [[XBBListHeadLabel alloc] initWithFrame:CGRectMake(0, 0, (XBB_Screen_width/2) , barView.bounds.size.height)];
//    [priceTotalTitle setTextColor:XBB_NavBar_Color];
//    [priceTotalTitle setFont:[UIFont boldSystemFontOfSize:16.]];
//    [barView addSubview:priceTotalTitle];
//    [priceTotalTitle setTextAlignment:NSTextAlignmentCenter];
//    [self addAllPrice];
//    priceTotalTitle.text = [NSString stringWithFormat:@"合计: ¥ %.2f",allPrice>0?allPrice:0.00];
    
    UIButton *button_1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (XBB_Screen_width/2) , barView.bounds.size.height)];
    [button_1 addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    button_1.tag = 1;
    button_1.backgroundColor = [UIColor colorWithRed:101./255. green:157./255. blue:25./255. alpha:1.0f]; //XBB_NavBar_Color;
    [button_1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_1 setTitle:@"继续选择" forState:UIControlStateNormal];
    [button_1 setTitleColor:XBB_Bg_Color forState:UIControlStateNormal];
    [barView addSubview:button_1];

    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(XBB_Screen_width- XBB_Screen_width/2, 0, XBB_Screen_width/2, barView.bounds.size.height)];
    [button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 2;
    button.backgroundColor = XBB_NavBar_Color;
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button setTitleColor:XBB_Bg_Color forState:UIControlStateNormal];
    [barView addSubview:button];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"设置车辆"]) {
        if (buttonIndex == 1) {
            MyCarTableViewController *myCar = [[MyCarTableViewController alloc] init];
            [self.navigationController pushViewController:myCar animated:YES];
        }
    }
}

- (void)submit:(id)sender
{
    
    UIButton *button = sender;
    
    
    if (IsLogin)
    {
        if ([[UserObj shareInstance] carModel] == nil) {
            UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"设置车辆" message:@"您还没有设置默认车辆哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alrt show];
            return;
            
        }else
        {
            switch (button.tag) {
                case 1:
                {
                    XBBOrder *oder = [[XBBOrder alloc] init];
                    oder.xbbid = self.proObject.p_id;
                    oder.title = self.proObject.p_name;
                    if (self.selectCarType == 1) {
                        oder.price = self.proObject.price_1;
                        
                    }else
                    {
                        oder.price = self.proObject.price_2;
                        
                    }
                    if (self.proObject.type == 1)
                    {
                        XBBDIYViewController *diy = [[XBBDIYViewController alloc] init];
                        diy.washType = 11;
                        diy.selectArray = @[oder];
                        
                        [self.navigationController pushViewController:diy animated:YES];
                        //                [self presentViewController:diy animated:YES completion:nil];
                        
                    }else if (self.proObject.type == 2)
                    {
                        XBBFacialViewController *fa = [[XBBFacialViewController alloc] init];
                        fa.selectFacialArray = @[oder];
                        [self.navigationController pushViewController:fa animated:YES];
                        //                [self presentViewController:fa animated:YES completion:nil];
                    }
                    
                    
                    
                }
                    break;
                case 2:
                {
                    XBBDiyObject *object = [[XBBDiyObject alloc] init];
                    object.proName = self.proObject.p_name;
                    object.price1 = self.proObject.price_1;
                    object.price2 = self.proObject.price_2;
                    object.pid = self.proObject.p_id;
                    object.type = self.proObject.type;
                    NSArray *arr = @[object];
                    AddOrderViewController *order = [[AddOrderViewController alloc] init];
                    order.selectArray = arr;
                    [self.navigationController pushViewController:order animated:YES];
                    //            [self presentViewController:order animated:YES completion:nil];
                }
                    break;
                    
                default:
                    break;
            }

        }
    }

    
    
    DLog(@"")
}

- (void)initWeb
{
    if (self.proObject) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64.+70., XBB_Screen_width, XBB_Screen_height-64 - 70. - 44.)];
        [self addTabBar];
        [self setUpUIPriceBar];
        
        
    }else
    {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64., XBB_Screen_width, XBB_Screen_height - 64.)];
    }
    
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)backViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
