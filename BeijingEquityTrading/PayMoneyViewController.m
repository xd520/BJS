//
//  PayMoneyViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/16.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "PayMoneyViewController.h"
#import "AppDelegate.h"

@interface PayMoneyViewController ()
{
    NSURLConnection *_urlConnection;
    NSURLRequest *_FailedRequest;
    BOOL _authenticated;
    float addHight;
    
    NSURLRequest *httpsRequest;
}
@end

@implementation PayMoneyViewController

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
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@/page/pay/qyt/app_applySaveMoney_jkzf?id=%@&rmd=%i",SERVERURL,_strId,[self getRandomNumber:0 to:100000000]]);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/page/pay/qyt/app_applySaveMoney_jkzf?id=%@&rmd=%i",SERVERURL,_strId,[self getRandomNumber:0 to:100000000]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"webview" forHTTPHeaderField:@"Request-By"];
    /*
    NSURLRequest *request =[NSURLRequest requestWithURL:url
            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:5.0];
     */
    [_webView loadRequest:request];
}

-(int)getRandomNumber:(int)from to:(int)to

{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"%@",request.URL);
    httpsRequest = request;
    NSString* scheme = [[request URL] scheme];
    // BOOL result = _authenticated;
    
    if ([scheme isEqualToString:@"https"]) {
        _authenticated = NO;
        _FailedRequest = request;
        NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
        
    }
    return YES;
}


#pragma NSURLConnectionDelegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        //if ([trustedHosts containsObject:challenge.protectionSpace.host])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    
    //[_webView loadRequest:_FailedRequest];
    
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
    
    /*
    [[HttpMethods Instance] activityIndicate:NO
                                  tipContent:@"加载失败"
                               MBProgressHUD:nil
                                      target:self.view
                             displayInterval:2];
    */
    [webView loadRequest:httpsRequest];
    
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
