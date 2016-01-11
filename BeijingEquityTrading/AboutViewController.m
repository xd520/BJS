//
//  AboutViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UserHelpViewController.h"
#import "AboutUsViewController.h"
#import "WebDetailViewController.h"

@interface AboutViewController ()
{
    float addHight;
    
}
@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
    
     addHight = 0;
    }
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth, 1)];
    lineView.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
    [self.view addSubview:lineView];
    
    
    for (int i = 1; i < 4; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 209 +addHight + 40*i, ScreenWidth, 1)];
        lineView.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
        [self.view addSubview:lineView];
    }
    
    _imgView.frame = CGRectMake((ScreenWidth - 80)/2, 84, 80, 80);
    
    _versonLab.text = @"版本:v1.0.0";
    
    
    UILabel *lablast = [[UILabel alloc] initWithFrame:CGRectMake(15, ScreenHeight -25 - 14, ScreenWidth - 30, 13)];
    lablast.text = @"津ICP备08102316号";
    lablast.textAlignment = NSTextAlignmentCenter;
    lablast.font = [UIFont systemFontOfSize:13];
    //[self.view addSubview:lablast];
    
    
    
    UILabel *lab= [[UILabel alloc] initWithFrame:CGRectMake(10, ScreenHeight -30 - 28, ScreenWidth - 20, 12)];
    lab.text = @"版权所有 © 天津股权交易所";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    //[self.view addSubview:lab];
    
    _logoutBtn.layer.cornerRadius = 4;
    _logoutBtn.layer.masksToBounds = YES;
    _logoutBtn.layer.borderColor = [ConMethods colorWithHexString:@"dedede"].CGColor;
    _logoutBtn.layer.borderWidth = 1;
    _logoutBtn.backgroundColor = [ConMethods colorWithHexString:@"bd0100"];
    _logoutBtn.hidden = YES;
   
    UITapGestureRecognizer *singleTap1;
    
    singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    [_userLab addGestureRecognizer:singleTap1];
    
    
    UITapGestureRecognizer *singleTap;
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    
    //单点触摸
    singleTap.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap.numberOfTapsRequired = 1;
    [_aboutLab addGestureRecognizer:singleTap];
    
}


- (IBAction)callPhone:(UITouch *)sender
{
    
    UIView *view = [sender view];
    
    if (view.tag == 1) {
        UserHelpViewController *vc = [[UserHelpViewController alloc] init];
        vc.strId = @"SYBZ";
        vc.strName = @"使用帮助";
        [self.navigationController pushViewController:vc animated:YES];
    } else {
    UserHelpViewController *vc = [[UserHelpViewController alloc] init];
    vc.strId = @"SYBZ";
     vc.strName = @"使用帮助";
    [self.navigationController pushViewController:vc animated:YES];
    
    
    }
    
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)logOutMethods:(id)sender {
    
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


-(void)requestData{
    
    //[[HttpMethods Instance] activityIndicate:YES tipContent:@"正在注销..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    
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
            _logoutBtn.hidden = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            
            if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.loginUser removeAllObjects];
                
                LoginViewController *cv = [[LoginViewController alloc] init];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
            } else {
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.view
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


@end
