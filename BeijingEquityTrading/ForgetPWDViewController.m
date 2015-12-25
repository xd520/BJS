//
//  ForgetPWDViewController.m
//  添金投
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "ForgetPWDViewController.h"
#import "AppDelegate.h"
#import "Child.h"
#import "FoggterAgainViewController.h"

@interface ForgetPWDViewController ()
{
     Child *child;
    float addHight;
}
@end

@implementation ForgetPWDViewController

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
    
    
    _nextBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _nextBtn.layer.borderWidth = 1;
    
    _nextBtn.layer.masksToBounds = YES;
    
    _nextBtn.layer.cornerRadius = 4;
    _nextBtn.backgroundColor = [ConMethods colorWithHexString:@"BD0100"];
    
    
    //按钮设置
    self.codeBtn.backgroundColor = [ConMethods colorWithHexString:@"BD0100"];
    //self.sheetBtn.enabled = NO;
    //self.sheetBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //self.sheetBtn.layer.borderWidth = 1;
    
    self.codeBtn.layer.masksToBounds = YES;
    
    self.codeBtn.layer.cornerRadius = 2;
    
    
     
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _phoneNum) {
        
            NSString *emailRegex = @"^1[3|4|5|8][0-9]\\d{8}$";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            bool sfzNo = [emailTest evaluateWithObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            
            if (!sfzNo) {
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:@"请输入正确的手机号码"
                                           MBProgressHUD:nil
                                                  target:self.view
                                         displayInterval:3];
                
                
                textField.text = @"";
            }
    }
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


-(void) requestData {
    
   // NSDictionary *parameters = @{@"pageNo":@"",@"pageSize":@""};
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_phoneNum.text forKey:@"mobilePhone"];
    [paraDic setObject:_userName.text forKey:@"vcode"];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERforgetpwdstep1] parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        child.age = 0;
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            
            FoggterAgainViewController *vc = [[FoggterAgainViewController alloc] init];
            //vc.sessionId = [dataArray objectForKey:@"sessionId"];
            
            //vc.phoneNumStr = _phoneNum.text;
            [self.navigationController pushViewController:vc animated:YES];
            
           
            
        } else {
            _codeBtn.enabled = YES;
            
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
    
    if (child.age > 0) {
        child.age = 0;
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextMethods:(id)sender {
    [self.view endEditing:YES];
    if ([_phoneNum.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入有效的手机号码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
       
    } else if ([_userName.text isEqualToString:@""]){
    
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入曾经注册过的用户名"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
   
    } else {
    
        
           
        [self requestData];
        
        
    
    }
}

//监听方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([[change objectForKey:@"new"] integerValue] <= 0) {
        
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        _codeBtn.enabled = YES;
        _codeBtn.backgroundColor = [ConMethods colorWithHexString:@"bd0100"];
        [child removeObserver:self forKeyPath:@"age"];
    } else {
        
         [_codeBtn setTitle:[NSString stringWithFormat:@"%@秒后获取",[change objectForKey:@"new"]] forState:UIControlStateNormal];
        
        _codeBtn.enabled = NO;
        _codeBtn.backgroundColor = [UIColor grayColor];
        
    }
    
    
}





- (IBAction)sheetCodeMethods:(id)sender {
    //获取验证码
    if ([_phoneNum.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请先输入手机号码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        
    } else {
        
        
        NSString *emailRegex = @"^1[3|4|5|8][0-9]\\d{8}$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        bool sfzNo = [emailTest evaluateWithObject:[_phoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        if (!sfzNo) {
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"请输入正确的手机号码"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            _phoneNum.text = @"";
        } else {
            
           _codeBtn.enabled = NO;
            [self requestPhoneCodeMethods:_phoneNum.text];
            
        }
        
    }
}

-(void)requestPhoneCodeMethods:(NSString *)str {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"mobilePhone":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERforgetpwdsendVcode] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"短信发送成功"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            //cookieStr = [[responseObject objectForKey:@"object"] objectForKey:@"sessionId"];
            
            child.age = 0;
            //注册观察者
            child = [[Child alloc] init];
            child.age = [[[responseObject objectForKey:@"object"] objectForKey:@"time"] integerValue];
            [child addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"xxxx"];
            
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



@end
