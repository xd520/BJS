//
//  MyViewController.m
//  BeijingEquityTrading
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MyViewController.h"
#import "AppDelegate.h"
#import "PropertyViewController.h"
#import "TradeViewController.h"
#import "AttentionViewController.h"
#import "CertifyViewController.h"
#import "MeansViewController.h"
#import "NewsViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "PaymentRecordViewController.h"
#import "FirstRealNameViewController.h"
#import "CPVTabViewController.h"

@interface MyViewController ()
{
    float addHight;
    NSArray *arrTitle;
    NSArray *arrImg;
    
    UITableView *table;
    UILabel *nameTitle;
    UIImageView *imgHeadVeiw;
    
    UILabel *unMesgLab;
    UILabel *_badgeunMesgLab;
    
    UIImageView *_badgeValueImage;
}
@end

@implementation MyViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getUIFirst];
   
}





-(void)getUIFirst {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.loginUser.count > 0) {
        if ([[delegate.loginUser objectForKey:@"success"] boolValue] == YES) {
            
            nameTitle.text = [[delegate.loginUser objectForKey:@"object"] objectForKey:@"username"];
            [self requestCategoryList];
             [self requestMsgInfoData];
            
            } else {
            
            //delegate.strlogin = @"1";
            LoginViewController *VC = [[LoginViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
          
        }
        
    } else {
        // delegate.strlogin = @"1";
        LoginViewController *VC = [[LoginViewController alloc] init];
        
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }
    
}


//获取验证图形
- (void)requestCategoryList
{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSURLRequest *reqest;
    
   /*
    if ([[delegate.loginUser objectForKey:@"object"] objectForKey:@"isTX"] == [NSNull null]) {
        reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/res/prj/default/images/avatar_default.jpg",SERVERURL]]];
    } else {
       */
        if ([[[delegate.loginUser objectForKey:@"object"] objectForKey:@"haveAvatar"] boolValue] == 0 ) {
            reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/res/prj/default/images/avatar_default.jpg",SERVERURL]]];
        } else {
            
            reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/LbFiles/tx/%@.jpg",SERVERURL,[[delegate.loginUser objectForKey:@"object"] objectForKey:@"USERID"]]]];
        }
    //}

    
    //reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/captcha",SERVERURL]]];
    
    [imgHeadVeiw setImageMoreWithURLRequest:reqest placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        NSLog(@"JSON: %@  %@ %@", request,response,image);
        //self.codeImgve.image = nil;
        
        // self.codeImgve.image =  [UIImage  safeImageWithData:image];;
        
        imgHeadVeiw.image = image;
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        imgHeadVeiw.image = [UIImage imageNamed:@"loading_failed_bd"];
        NSLog(@"JSON: %@  %@ %@", request,response,error);
    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor= [ConMethods colorWithHexString:@"d23838"];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
        
    }

    //[self showBadge];
    
    arrTitle = @[@"我的资产",@"我的交易",@"我的关注",@"认证中心",@"个人资料",@"消息中心",@"支付记录"];
    arrImg = @[@"grzx_icon_2",@"grzx_icon_3",@"grzx_icon_4",@"grzx_icon_5",@"grzx_icon_1",@"grzx_icon_6",@"grzx_icon_9"];
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight - 49)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    table.bounces = NO;
    
    [self.view addSubview:table];
    
}


#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return arrTitle.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RepairCellIdentifier];
    }
    
   
     if (indexPath.row != arrTitle.count) {
    
    cell.textLabel.text = [arrTitle objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[arrImg objectAtIndex:indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
         if (indexPath.row == 5) {
             UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(130, 10.5, 19, 19)];
             img.image = [UIImage imageNamed:@"msg_circle"];
             
             unMesgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 19, 19)];
             unMesgLab.textColor = [UIColor whiteColor];
             unMesgLab.textAlignment = NSTextAlignmentCenter;
             unMesgLab.font = [UIFont systemFontOfSize:10];
             unMesgLab.text = @"0";
             unMesgLab.backgroundColor = [UIColor clearColor];
             [img addSubview:unMesgLab];
             
             [cell.contentView addSubview:img];
         }
         
         
         
         if (indexPath.row == arrTitle.count - 1) {
             UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth , 0.5)];
             lineview.backgroundColor = [ConMethods colorWithHexString:@"9a9a9a"];
             [cell addSubview:lineview];
         } else {
             UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(50, 39.5, ScreenWidth - 50, 0.5)];
             lineview.backgroundColor = [ConMethods colorWithHexString:@"9a9a9a"];
             [cell addSubview:lineview];
         }
         
         
         
         
     } else {
         UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, 20, ScreenWidth - 60, 35)];
         btn.layer.cornerRadius = 4;
         btn.layer.masksToBounds = YES;
         btn.layer.borderColor = [ConMethods colorWithHexString:@"dedede"].CGColor;
         btn.layer.borderWidth = 1;
         btn.titleLabel.font = [UIFont systemFontOfSize:18];
         btn.backgroundColor = [ConMethods colorWithHexString:@"bd0100"];
         [btn setTitle:@"退出登录" forState:UIControlStateNormal];
         [btn addTarget:self action:@selector(logOutMethods:) forControlEvents:UIControlEventTouchUpInside];
    
         [cell addSubview:btn];
         cell.backgroundColor = [UIColor clearColor];
     }
    return cell;
}

-(void)logOutMethods:(UIButton *)btn {

    UIAlertView *outAlert = [[UIAlertView alloc] initWithTitle:@"注销" message:@"是否要退出该帐号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    outAlert.tag = 10003;
    [outAlert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
            [[UIApplication sharedApplication]openURL:url];
        }
    } else if (alertView.tag==10003){
        
        if (buttonIndex != 0) {
            
            [self requestData];
        }
    }
}


// 消息中心记录数
-(void)requestMsgInfoData{
    
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERunReadMsgInfo] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]){
            
            
            if ([[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"object"] objectForKey:@"unReadMsg"] objectForKey:@"count"]] isEqualToString:@"0"]) {
                
                
                _badgeValueImage.hidden = YES;
                
            } else {
                
             [self showBadge];
                
                /*
                
                UITabBarItem *tabBarItem = [delegate.tabBarController.tabBar.items objectAtIndex:3];
            tabBarItem.badgeValue = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"object"] objectForKey:@"unReadMsg"] objectForKey:@"count"]];
                 */
            }
            unMesgLab.text = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"object"] objectForKey:@"unReadMsg"] objectForKey:@"count"]];
            
            
        } else {
            
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
                
                if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                    
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.loginUser removeAllObjects];
                    
                    LoginViewController *cv = [[LoginViewController alloc] init];
                    cv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cv animated:YES];
                    
                }
                
            } else {
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.navigationController.view
                                         displayInterval:3];
            }
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.navigationController.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
}


- (void)showBadge
{
   
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!_badgeValueImage) {
       
        NSInteger imageCount = 4;
        CGFloat cellWidth = ScreenWidth / imageCount;
        CGFloat xOffest = ScreenWidth - cellWidth/2.0 + 8.0f;
        
        
       _badgeValueImage = [[UIImageView alloc] initWithFrame:CGRectMake(xOffest, 8.0f, 18.0f, 18.0f)];
        _badgeValueImage.image = [UIImage imageNamed:@"msg_circle"];
        
         _badgeunMesgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18.0f, 18.0f)];
        _badgeunMesgLab.textColor = [UIColor whiteColor];
        _badgeunMesgLab.textAlignment = NSTextAlignmentCenter;
        _badgeunMesgLab.font = [UIFont systemFontOfSize:10];
        _badgeunMesgLab.text = @"0";
        _badgeunMesgLab.backgroundColor = [UIColor clearColor];
        [_badgeValueImage addSubview:_badgeunMesgLab];
        
       
        _badgeValueImage.backgroundColor = [UIColor  clearColor];
        [delegate.tabBarController.tabBar addSubview:_badgeValueImage];
        
    }
}




-(void)requestData{
    
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在注销..." MBProgressHUD:nil target:self.navigationController.view displayInterval:2.0];
    
    
    /*
     <AFURLRequestSerialization>`
     - `AFHTTPRequestSerializer`
     - `AFJSONRequestSerializer`
     - `AFPropertyListRequestSerializer`
     * `<AFURLResponseSerialization>`
     - `AFHTTPResponseSerializer`
     - `AFJSONResponseSerializer`
     - `AFXMLParserResponseSerializer`
     - `AFXMLDocumentResponseSerializer` _(Mac OS X)_
     - `AFPropertyListResponseSerializer`
     - `AFImageResponseSerializer`
     - `AFCompoundResponseSerializer`
     
     */
    
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERLogout] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]){
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"注销成功"
                                       MBProgressHUD:nil
                                              target:self.navigationController.view
                                     displayInterval:2];
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.loginUser removeAllObjects];
            [self getUIFirst];
           
            
        } else {
            
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
            
            if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.loginUser removeAllObjects];
                
                LoginViewController *cv = [[LoginViewController alloc] init];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
                
            }
                
            } else {
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.navigationController.view
                                         displayInterval:3];
            }
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.navigationController.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == arrTitle.count) {
      return 80;
    } else {
    return 40;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
      return 180;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view;
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
        view.backgroundColor = [ConMethods colorWithHexString:@"be1212"];
        
        
        imgHeadVeiw = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 100)/2, 40, 100, 100)];
        imgHeadVeiw.backgroundColor = [UIColor redColor];
        
        imgHeadVeiw.layer.cornerRadius = imgHeadVeiw.frame.size.width / 2;
        imgHeadVeiw.clipsToBounds = YES;
        imgHeadVeiw.layer.borderWidth = 4.0f;
        imgHeadVeiw.layer.borderColor = [ConMethods colorWithHexString:@"fbfbfb"].CGColor;
        imgHeadVeiw.image = [UIImage imageNamed:@"loading_bd"];
        [view addSubview:imgHeadVeiw];
        
        
        
        
        nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 145, ScreenWidth - 100, 20)];
        nameTitle.text = @"我的账户";
        nameTitle.backgroundColor = [UIColor clearColor];
        nameTitle.textAlignment = NSTextAlignmentCenter;
        nameTitle.textColor = [UIColor whiteColor];
        nameTitle.font = [UIFont systemFontOfSize:17];
        [view addSubview:nameTitle];
        
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame = CGRectMake(ScreenWidth - 10 - 23, 25, 23, 23);
        [searchBtn setBackgroundImage:[UIImage imageNamed:@"grzx_setting"] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(searchMthods) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:searchBtn];
     
    }
    return view;
    
}

-(void)searchMthods{
    SettingViewController *vc = [[SettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        PropertyViewController *vc = [[PropertyViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } else if (indexPath.row == 1){
        
        TradeViewController *vc = [[TradeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 2) {
        AttentionViewController *vc = [[AttentionViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == 3){
        CertifyViewController *vc = [[CertifyViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4){
        MeansViewController *vc = [[MeansViewController alloc] init];
        vc.headViewImg = imgHeadVeiw.image;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 5){
        NewsViewController *vc = [[NewsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 6){
    
        [self requestDataForIdentfy];
    }
    
    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)requestDataForIdentfy {
    
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERpwdManageappappIndex] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            
            if ( [[[responseObject objectForKey:@"object"] objectForKey:@"isSetCert"] boolValue]){
                PaymentRecordViewController *vc = [[PaymentRecordViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {
                
                FirstRealNameViewController *vc = [[FirstRealNameViewController alloc] init];
               
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            
            }
            
        } else {
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
                
                if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                    
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.loginUser removeAllObjects];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
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
