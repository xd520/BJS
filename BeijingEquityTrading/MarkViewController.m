//
//  MarkViewController.m
//  BeijingEquityTrading
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MarkViewController.h"
#import "AppDelegate.h"


@interface MarkViewController ()
{
    UIScrollView *scrollView;
    float addHight;
}
@end

@implementation MarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  addHight + 44, ScreenWidth, ScreenHeight - 49 - 20)];
    scrollView.bounces = NO;
    scrollView.backgroundColor = [ConMethods colorWithHexString:@"f7f7f5"];
    [self.view addSubview:scrollView];
    
    
}


//请求数据方法
-(void)requestMethods {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"id":_strId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERprjsappIndex] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
           // [self recivedList:[[responseObject objectForKey:@"object"] objectForKey:@"zcResult"]];
            
        } else {
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareMethods:(id)sender {
}
@end
