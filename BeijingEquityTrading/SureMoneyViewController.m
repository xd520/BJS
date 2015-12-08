//
//  SureMoneyViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/7.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "SureMoneyViewController.h"
#import "AppDelegate.h"

@interface SureMoneyViewController ()

@end

@implementation SureMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    }

    _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    
    
    
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/page/pay/qyt/app_applySaveMoney?id=%@&rmd=%i",SERVERURL,_strId,[self getRandomNumber:0 to:100000000]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
}


#pragma mark - date change Metholds




-(int)getRandomNumber:(int)from to:(int)to

{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}






- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[HttpMethods Instance] activityIndicate:NO
                                  tipContent:@"加载成功"
                               MBProgressHUD:nil
                                      target:self.view
                             displayInterval:2];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
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
   [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


- (IBAction)back:(id)sender {
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _webView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)dealloc {
    // webView 的缓存处理
    
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _webView = nil;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}



@end
