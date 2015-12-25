//
//  FoggterAgainViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-3.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "FoggterAgainViewController.h"
#import "AppDelegate.h"

@interface FoggterAgainViewController ()
{
    float addHight;
}
@end

@implementation FoggterAgainViewController

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
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,addHight+ 43, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods  colorWithHexString:@"a5a5a5"];
    [self.view addSubview:lineView1];
    
    
    _sureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _sureBtn.layer.borderWidth = 1;
    
    _sureBtn.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 4;
    
    [_sureBtn setBackgroundColor:[ConMethods colorWithHexString:@"bd0100"]];
    
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSString *emailRegex = @"^(?=.{6,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    bool sfzNo = [emailTest evaluateWithObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if (!sfzNo) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入正确的密码格式"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
       
        textField.text = @"";
    }
    
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
- (IBAction)sureMethods:(id)sender {
   
    if ([_password.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入正确的密码格式"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
    } else if ([_passwordAgain.text isEqualToString:@""]) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请先输入正确的密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
       
    }else if (![_password.text isEqualToString:_passwordAgain.text]) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请先输入正确的密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
       
    } else {
        [self requestData];
        
    }
}

-(void) requestData {
    
    NSDictionary *parameters = @{@"newPwd1":[[Base64XD encodeBase64String:_password.text] strBase64],@"newPwd2":[[Base64XD encodeBase64String:_passwordAgain.text] strBase64]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERforgetpwdstep2] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"设置密码成功"
                                       MBProgressHUD:nil
                                              target:self.navigationController.view
                                     displayInterval:3];
            
            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            UIViewController *vc = [array objectAtIndex:array.count-2];
            if ([vc.nibName isEqualToString:@"ForgetPWDViewController"]) {
                [array removeObjectAtIndex:array.count-1];
                [array removeObjectAtIndex:array.count-1];
                [self.navigationController setViewControllers:array];
            }
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






#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}






@end
