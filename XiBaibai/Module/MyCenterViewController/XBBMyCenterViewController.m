//
//  XBBMyCenterViewController.m
//  XiBaibai
//
//  Created by HoTia on 15/12/11.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "XBBMyCenterViewController.h"
#import "XBBMyCenterInfoTableViewCell.h"
#import "UserObj.h"
#import "BPush.h"
#import "LoginViewController.h"

@interface XBBMyCenterViewController ()<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UIImageView       *_headImageView;
}

@property (nonatomic, strong) UITableView *tableView;

@end



static NSString *identifier_1 = @"cell_1";

@implementation XBBMyCenterViewController


- (void)exitCurrentCoust
{
    DLog(@"")
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"退出账号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
    
//    
//    [BPush delTag:[UserObj shareInstance].uid withCompleteHandler:^(id result, NSError *error) {
//        
//    }];
//    NSLog(@"退出");
//    NSUserDefaults *isLogin = [NSUserDefaults standardUserDefaults];
//    
//    
//    [isLogin removeObjectForKey:@"userid"];
//    
//    [isLogin synchronize];
//    
    
}

- (IBAction)backViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [titelLabel setText:self.navigationTitle?self.navigationTitle:@"个人信息"];
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



- (void)addTableViewUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64., XBB_Screen_width, XBB_Screen_height - 64.) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = XBB_Bg_Color;
    self.tableView.separatorColor = XBB_separatorColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"XBBMyCenterInfoTableViewCell" bundle:nil] forCellReuseIdentifier:identifier_1];
    
    
    
}

- (void)initUI
{
    [self addTableViewUI];
    [self setNavigationBarControl];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma --mark tableview的delegate方法

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 120.;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XBB_Screen_width, 120.)];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor clearColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30., backView.bounds.size.height - 44., XBB_Screen_width - 60., 44.)];
    button.layer.cornerRadius = 5;
    button.layer.borderColor = XBB_NavBar_Color.CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.masksToBounds = YES;
    [button setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(exitCurrentCoust) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:XBB_NavBar_Color forState:UIControlStateNormal];
    [backView addSubview:button];
    [button setBackgroundColor:XBB_Bg_Color];
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XBBMyCenterInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier_1];
    if (!cell) {
        cell=[[XBBMyCenterInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier_1];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            if (_headImageView) {
                [_headImageView removeFromSuperview];
                _headImageView = nil;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.nameLabel.text = NSLocalizedString(@"头像", nil);
            //            cell.headImageView.image = imgView_head.image;
           [cell.textLabel setFont:[UIFont systemFontOfSize:14.]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString *urlString =[NSString stringWithFormat:@"%@/%@", ImgDomain, [UserObj shareInstance].imgstring];
            _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(XBB_Screen_width - 60, cell.contentView.bounds.size.height/2 - 20, 40, 40)];
            _headImageView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            _headImageView.layer.masksToBounds = YES;
            _headImageView.layer.cornerRadius = 20;
            [_headImageView setUserInteractionEnabled:YES];
            [_headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImage:)]];
            NSURL *imgURL = [NSURL URLWithString:urlString];
            [_headImageView sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"nav1"]];
            cell.textLabel.frame = CGRectMake(100, 0, XBB_Screen_width-100, cell.contentView.bounds.size.height);
            [cell.contentView addSubview:_headImageView];
        }
            break;
        case 1:
        {
            cell.nameLabel.text = @"昵称";
            cell.decelLabel.text = [UserObj shareInstance].uname;
        }
            break;
        case 2:
        {
            cell.nameLabel.text = @"性别";
            cell.decelLabel.text = [UserObj shareInstance].sex;
        }
            break;
        case 3:
        {
            cell.nameLabel.text = @"手机号";
            cell.decelLabel.text = [[UserObj shareInstance] iphone];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)changeHeadImage:(id)sender
{
    UIActionSheet *action=[CustamViewController createActionSheetWithTitle:@"更换头像" withDelegate:self withCancel:@"取消" withdetructivebutton:nil withotherbtn:@"拍摄" withothers:@"相册选择"];
    [action showInView:self.view];
}


#pragma  --mark 头像修改
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([actionSheet.title isEqualToString:@"退出账号"]) {
        if (buttonIndex == 0) {
            [BPush delTag:[UserObj shareInstance].uid withCompleteHandler:^(id result, NSError *error) {
                
            }];
            NSLog(@"退出");
            NSUserDefaults *isLogin = [NSUserDefaults standardUserDefaults];
            [isLogin removeObjectForKey:@"userid"];
            [isLogin synchronize];
           
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [NSThread sleepForTimeInterval:0.5];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        self.view.alpha = 0;
                    } completion:^(BOOL finished) {
                       self.view.window.rootViewController = [[LoginViewController alloc] init];
                        self.view.window.rootViewController.view.alpha = 0;
                        [UIView animateWithDuration:0.25 animations:^{
                            self.view.window.rootViewController.view.alpha = 1;
                        }];
                    }];
                    
                });
            });
        }
        return;
    }
    
    
    
    if ([actionSheet.title isEqualToString:[NSString stringWithFormat:@"更换头像"]]) {
        if (buttonIndex == 0) {
            //拍照
            [self acquireImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }else if (buttonIndex == 1){
            
            //调用相册
            [self acquireImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }else if(buttonIndex == 2) {
            NSLog(@"取消");
        }
        
    }else if([actionSheet.title isEqualToString:[NSString stringWithFormat:@"选择性别"]]){
        if(buttonIndex==0){
            NSLog(@"男");
            //            [AFHelperViewController GetJsonDataWithString:[NSString stringWithFormat:@"http://s-199705.gotocdn.com/Api/index/user_msg_up?id=%@&sex=%@",userInfo.uid,[NSString stringWithFormat:@"1"]] Block:^(NSDictionary *Dics,NSError *error){
            //                if (!error) {
            //                    NSLog(@"mine DIC%@",Dics);
            //                    labSexT.text=@"男";
            //                    userInfo.sex=@"1";
            //                }else{
            //                    NSLog(@"error%@",error);
            //                }
            //            }];
            [NetworkHelper postWithAPI:updateUserInfo parameter:@{@"uid": [UserObj shareInstance].uid, @"sex": @"1"} successBlock:^(id response) {
                if ([response[@"code"] integerValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//                    labSexT.text = @"男";
                    [UserObj shareInstance].sex = @"1";
                } else {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
            } failBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"修改失败"];
            }];
        }else if(buttonIndex==1){
            NSLog(@"女");
            [NetworkHelper postWithAPI:updateUserInfo parameter:@{@"uid": [UserObj shareInstance].uid, @"sex": @"2"} successBlock:^(id response) {
                if ([response[@"code"] integerValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//                    labSexT.text = @"女";
                    [UserObj shareInstance].sex = @"2";
                } else {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
            } failBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"修改失败"];
            }];
            //            [AFHelperViewController GetJsonDataWithString:[NSString stringWithFormat:@"http://s-199705.gotocdn.com/Api/index/user_msg_up?id=%@&sex=%@",userInfo.uid,[NSString stringWithFormat:@"2"]] Block:^(NSDictionary *Dics,NSError *error){
            //                if (!error) {
            //                    NSLog(@"mine DIC%@",Dics);
            //
            //                    labSexT.text=@"女";
            //                    userInfo.sex=@"2";
            //                }else{
            //                    NSLog(@"error%@",error);
            //                }
            //            }];
        }else{
            NSLog(@"取消");
        }
    }
    
    
}


- (void)acquireImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    //获取途径
    imagePicker.sourceType = sourceType;
    //解决IOS8调用系统相机出现警告
    imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //是否编辑图片
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark UIImageViewPickerViewConrollerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //得到剪切后的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //保存图片到本地
    [self saveImage:image withName:[NSString stringWithFormat:@"newimage%@",@".jpg"]];
    
    //    [self UploadHeadImage];
    [self uploadWithImage:image];
    
    //得到图片路径
    NSString * path = [NSString stringWithFormat:@"%@/newimage.jpg",[self documentFolderPath]];
    //指定显示图片
    [_headImageView setImage:[UIImage imageWithContentsOfFile:path]];
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma 上传头像

- (void)uploadWithImage:(UIImage *)image {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:UpdateUserImg_API parameters:@{@"uid": [UserObj shareInstance].uid} constructingBodyWithBlock:^(id <AFMultipartFormData> formData){
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1) name:[NSString stringWithFormat:@"file"] fileName:[NSString stringWithFormat:@"file.jpg"] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject){
        if ([responseObject[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [UserObj shareInstance].imgstring = responseObject[@"file"];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
        //        NSLog(@"response %@",responseObject);
        //        userInfo.imgstring = responseObject[@"file"][@"file"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUserSuccessful object:nil];
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }];
}

- (void)UploadHeadImage{
    
    //获取图片路径
    NSString * imagePath = [NSString stringWithFormat:@"%@/newimage.jpg",[self documentFolderPath]];
    UIImage *headImage = [UIImage imageWithContentsOfFile:imagePath];
    headImage = [UIImage imageCompressForSizeImage:headImage targetSize:CGSizeMake(60, 60)];
    NSData *imageData = UIImagePNGRepresentation(headImage);
    NSLog(@"passImage:%f",imageData.length/1024.0);
    
    if (imageData != nil) {
        
//        [SVProgressHUD showWithStatus:@"上传头像中"];
        [SVProgressHUD show];
        
        //将图片转换成Base64字符串
        //        NSString *base64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        //设置请求路径
        //NSString *strUrl = @"http://s-199705.gotocdn.com/Api/index/user_msg_u_img";
        
        //设置请求参数
        NSDictionary *parameters = @{@"uid":[UserObj shareInstance].uid};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        AFHTTPRequestOperation *operation = [manager POST:UpdateUserImg_API
                                               parameters:parameters
                                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                    
                                    [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"img"] fileName:[NSString stringWithFormat:@"img.jpg"] mimeType:@"image/jpeg"];
                                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                    NSLog(@"post Big success returnedDic%@",responseObject[@"msg"]);
                                    //获取json格式字符串
                                    NSString *jsonStr = operation.responseString;
                                    //字符串编码
                                    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                                    //将json转换成字典
                                    NSDictionary *dic = [data mutableObjectFromJSONData];
                                    
                                    [UserObj shareInstance].imgstring = [[dic objectForKey:@"result"] objectForKey:@"u_img_name"];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUserSuccessful object:nil];
                                    
                                    [UserObj shareInstance].imgstring=[NSString stringWithFormat:@"newimage%@",@".jpg"];
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:@"上传失败"];
                                    NSLog(@"post big file fail error=%@", error);
                                }];
        [operation start];

    }
}

#pragma mark 保存图片到沙盒

- (void)saveImage:(UIImage*) currentImage withName:(NSString *) name{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:name];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    NSLog(@"+++++++++++%@",fullPathToFile);
    
}

#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
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
