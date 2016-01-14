//
//  SetEmailViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 16/1/5.
//  Copyright © 2016年 ApexSoft. All rights reserved.
//

#import "SetEmailViewController.h"
#import "AppDelegate.h"

@interface SetEmailViewController ()
{
    float addHight;
}
@end

@implementation SetEmailViewController

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
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 43, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods colorWithHexString:@"a2a2a2"];
    [self.view addSubview:lineView1];
    
    
    _commitBtn.layer.cornerRadius = 2;
    _commitBtn.layer.masksToBounds = YES;
    _commitBtn.userInteractionEnabled = YES;
    _commitBtn.backgroundColor = [ConMethods colorWithHexString:@"bd0100"];
    
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

-(void) requestData {
    
    
    NSDictionary *parameters = @{@"email":_email.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERsaveEmail] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            
            
             [[HttpMethods Instance] activityIndicate:NO
             tipContent:@"设置邮箱成功"
             MBProgressHUD:nil
             target:self.navigationController.view
             displayInterval:3];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        
            
            
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


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)commitMethods:(id)sender {
    if ([_email.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入有效邮箱"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
    }else if (![PublicMethod validateEmail:_email.text]){
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入有效邮箱"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
    
    } else {
    
        [self requestData];
    }
}
@end
