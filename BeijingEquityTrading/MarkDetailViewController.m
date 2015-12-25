//
//  MarkDetailViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/24.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MarkDetailViewController.h"
#import "AppDelegate.h"

@interface MarkDetailViewController ()
{
    float addHight;
}
@end

@implementation MarkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    //_webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods colorWithHexString:@"a2a2a2"];
    [self.view addSubview:lineView1];
    
    
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/page/s/prj/appBdwDetail?id=%@",SERVERURL,_strId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"webview" forHTTPHeaderField:@"Request-By"];
    [_webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[HttpMethods Instance] activityIndicate:NO
                                  tipContent:@"加载完成"
                               MBProgressHUD:nil
                                      target:self.view
                             displayInterval:2];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [[HttpMethods Instance] activityIndicate:NO
                                  tipContent:@"加载失败"
                               MBProgressHUD:nil
                                      target:self.view
                             displayInterval:2];
    
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


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
