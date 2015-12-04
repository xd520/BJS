//
//  ChangeLoginPWViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-7.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "ChangeLoginPWViewController.h"
#import "AppDelegate.h"

@interface ChangeLoginPWViewController ()
{
    float addHight;
}
@end

@implementation ChangeLoginPWViewController

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

    _sureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
   // _sureBtn.layer.borderWidth = 1;
    
    _sureBtn.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 4;
    _sureBtn.backgroundColor = [ConMethods colorWithHexString:@"fe8103"];
   // [_sureBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 44 + addHight, ScreenWidth , 1)];
    view0.backgroundColor = [ConMethods colorWithHexString:@"a2a2a2"];
    [self.view addSubview:view0];
    
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 84 + addHight, ScreenWidth - 10, 1)];
    view1.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [self.view addSubview:view1];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 124 + addHight, ScreenWidth - 10, 1)];
    view2.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [self.view addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(10, 164 + addHight, ScreenWidth - 10, 1)];
    view3.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [self.view addSubview:view3];
    
    
    
    
    _oldPW.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
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

-(void) requestData {
    
   
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    [paraDic setObject:[[Base64XD encodeBase64String:_oldPW.text] strBase64] forKey:@"oldPwd"];
    [paraDic setObject:[[Base64XD encodeBase64String:_password.text] strBase64] forKey:@"newPwd1"];
    [paraDic setObject:[[Base64XD encodeBase64String:_passwordAgain.text] strBase64] forKey:@"newPwd2"];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERwdbzj] parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"修改登录密码成功"
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



#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)back:(id)sender{
  [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)sureMehtods:(id)sender{
    [self.view endEditing:YES];
    if ([_oldPW.text isEqualToString:@""]) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入旧密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
       
    } else if ([_password.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        
    } else if ([_passwordAgain.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请再一次输入密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        
    }else if (_password.text.length < 6&&_password.text.length > 16) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入正确的密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        _password.text = @"";
    }else if (![_password.text isEqualToString:_passwordAgain.text]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入相同的新密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
       
        _passwordAgain.text = @"";
    } else {
        
        [self requestData];
        
    }

}




@end
