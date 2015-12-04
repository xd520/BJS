//
//  ChangerPassWordViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "ChangerPassWordViewController.h"
#import "AppDelegate.h"


@interface ChangerPassWordViewController ()
{
    float addHight;
}
@end

@implementation ChangerPassWordViewController

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

    
    
    _sureBtn.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 4;
    _sureBtn.backgroundColor = [ConMethods colorWithHexString:@"fe8103"];
    
    _oldPW.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _passwordAgain.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _oldPW.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length != 6) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入6位数交易密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
       
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *cs;
   
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入数字"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            return NO;
     
    }
    //其他的类型不需要检测，直接写入
    return YES;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sureMehtods:(id)sender {
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
        
        
    } else   if ([_passwordAgain.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请再一次输入密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
       
    }else if (_oldPW.text.length != 6||_password.text.length != 6||_passwordAgain.text.length != 6) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入6位数交易密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        
    } else {
    
        [self requestData];
 
    }
}

- (IBAction)pushVC:(id)sender {
   
}
@end
