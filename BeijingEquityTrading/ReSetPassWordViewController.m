//
//  ReSetPassWordViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "ReSetPassWordViewController.h"
#import "AppDelegate.h"
#import "Child.h"

@interface ReSetPassWordViewController ()
{
    float addHight;
    UILabel *sheetLab;
     Child *child;
}
@end

@implementation ReSetPassWordViewController

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
    
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 43 + addHight, ScreenWidth , 1)];
    view0.backgroundColor = [ConMethods colorWithHexString:@"a5a5a5"];
    [self.view addSubview:view0];
    
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 84 + addHight, ScreenWidth - 10, 1)];
    view1.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [self.view addSubview:view1];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 124 + addHight, ScreenWidth - 10, 1)];
    view2.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [self.view addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 164 + addHight, ScreenWidth, 1)];
    view3.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [self.view addSubview:view3];
    
    
    //按钮设置
    self.sheetCodeBtn.backgroundColor = [ConMethods colorWithHexString:@"bd0100"];
    self.sheetCodeBtn.layer.masksToBounds = YES;
    self.sheetCodeBtn.layer.cornerRadius = 2;
    
    sheetLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sheetCodeBtn.frame.size.width, self.sheetCodeBtn.frame.size.height)];
    sheetLab.text = @"获取验证码";
    sheetLab.textAlignment = NSTextAlignmentCenter;
    
    sheetLab.font = [UIFont systemFontOfSize:15];
    sheetLab.textColor = [UIColor whiteColor];
    [_sheetCodeBtn addSubview:sheetLab];
    
    
    _sureBtn.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 4;
    _sureBtn.backgroundColor = [ConMethods colorWithHexString:@"bd0100"];

    _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _passWord.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _passWordAgain.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
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
    
    if (child.age > 0) {
        child.age = 0;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sureMethods:(id)sender {
    [self.view endEditing:YES];
    if ([_passWord.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
       
    } else   if ([_passWordAgain.text isEqualToString:@""]) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请再一次输入密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
       
    }else if (_passWord.text.length != 6||_passWordAgain.text.length != 6) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入6位数交易密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
       
    } else if ([_code.text isEqualToString:@""]) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入手机验证码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
       
    }else {
       
        [self requestData];
    }

}

-(void) requestData {
    
    
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:[[Base64XD encodeBase64String:_passWord.text] strBase64] forKey:@"password"];
    [paraDic setObject:[[Base64XD encodeBase64String:_passWordAgain.text] strBase64] forKey:@"password2"];
    [paraDic setObject:_code.text forKey:@"yzm"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERforgetpwdresetJyPWD] parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        child.age = 0;
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"重置交易密码成功"
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





-(void)requestPhoneCodeMethods {
   
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERforgetpwdSendVcode] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        child.age = 0;
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
        
        _sheetCodeBtn.enabled = NO;
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}



//监听方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([[change objectForKey:@"new"] integerValue] <= 0) {
        sheetLab.text = @"获取验证码";
        _sheetCodeBtn.enabled = YES;
        _sheetCodeBtn.backgroundColor = [ConMethods colorWithHexString:@"bd0100"];
        [child removeObserver:self forKeyPath:@"age"];
    } else {
        sheetLab.text = [NSString stringWithFormat:@"%@秒后获取",[change objectForKey:@"new"]];
        _sheetCodeBtn.enabled = NO;
        _sheetCodeBtn.backgroundColor = [UIColor grayColor];
        
    }
    
    
}


-(void)dealloc {
    
    
    
}




- (IBAction)sheetCodeMethods:(id)sender {
    //获取验证码
    _sheetCodeBtn.enabled = NO;
    [self requestPhoneCodeMethods];
}
@end
