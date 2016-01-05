//
//  RegesterViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-9.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "RegesterViewController.h"
#import "Child.h"
#import "UserProcrolViewController.h"
#import "Base64XD.h"
#import "AppDelegate.h"

@interface RegesterViewController ()
{
    float addHight;
    int count;
    UILabel *sheetLab;
    int phoneCount;
    NSString *cookieStr;
}
@end

@implementation RegesterViewController

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
    count = 0;
    phoneCount = 0;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods  colorWithHexString:@"a5a5a5"];
    [self.headView addSubview:lineView1];

    
    
    
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth - 10, 0.5)];
    lineView2.backgroundColor = [ConMethods  colorWithHexString:@"dedede"];
    [self.allView addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, ScreenWidth - 10, 0.5)];
    lineView3.backgroundColor = [ConMethods  colorWithHexString:@"dedede"];
    [self.allView addSubview:lineView3];
    
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 119.5, ScreenWidth - 10, 0.5)];
    lineView4.backgroundColor = [ConMethods  colorWithHexString:@"dedede"];
    [self.allView addSubview:lineView4];
    
    UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 159.5, ScreenWidth - 10, 0.5)];
    lineView5.backgroundColor = [ConMethods  colorWithHexString:@"dedede"];
    [self.allView addSubview:lineView5];
    
    
    //按钮设置
    self.sheetBtn.backgroundColor = [ConMethods colorWithHexString:@"BD0100"];
    //self.sheetBtn.enabled = NO;
    //self.sheetBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //self.sheetBtn.layer.borderWidth = 1;
    
    self.sheetBtn.layer.masksToBounds = YES;
    
    self.sheetBtn.layer.cornerRadius = 2;
    
    
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 4;
    
    
    //self.checkNumBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    sheetLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sheetBtn.frame.size.width, self.sheetBtn.frame.size.height)];
    sheetLab.text = @"获取验证码";
    sheetLab.backgroundColor = [UIColor clearColor];
    sheetLab.textAlignment = NSTextAlignmentCenter;
    
    sheetLab.font = [UIFont systemFontOfSize:15];
    sheetLab.textColor = [UIColor whiteColor];
    [_sheetBtn addSubview:sheetLab];
    
    self.allView.layer.masksToBounds = YES;
    
    self.allView.layer.cornerRadius = 4;
    self.allView.layer.borderWidth = 1;
    self.allView.layer.borderColor = [ConMethods colorWithHexString:@"dedede"].CGColor;
    
    
    /*
    self.userName.backgroundColor = [UIColor whiteColor];
    
    self.userName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.userName.layer.borderWidth = 1;
    
    self.userName.layer.masksToBounds = YES;
    
    self.userName.layer.cornerRadius = 10;
    */
    _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
     self.userName.text = @"";
    _password.text = @"";
    _passwordAgain.text = @"";
    _code.text = @"";
    _phoneNum.text = @"";
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


//匹配是否为email地址。
- (BOOL)validateEmail:(NSString *)candidate{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}




- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _userName) {
   
        
   // NSString *emailRegex = @"^[a-zA-Z]\\w{5,17}$";
        
    NSString *emailRegex = @"^[a-zA-Z0-9_]{4,30}$";
        
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    bool sfzNo = [emailTest evaluateWithObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if (!sfzNo) {
        
        if (textField.text.length < 6 || textField.text.length > 18) {
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"请输入正确的用户名"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
          
        } else {
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"请输入正确的用户名"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
       
        
        }
        
        
        
        //[self HUDShow:@"请输入正确的身份证号" delay:1.5];
        //[self.view makeToast:@"请输入正确的用户名" duration:1.0 position:@"center"];
        textField.text = @"";
    } else {
        [self requestMethods:textField.text];
    
    }
        
        
    } else if (textField == _password||textField == _passwordAgain) {
        
        
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
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    CGRect frame = textField.frame;
    int offset;
   
    offset =_allView.frame.origin.y + frame.origin.y + 76 - (self.view.frame.size.height - 256.0);//键盘高度216
        
       
    //动画
    /*
     NSTimeInterval animationDuration = 0.3f;
     [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
     [UIView setAnimationDuration:animationDuration];
     */
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    
}



#pragma mark - Request Methods

//请求数据方法
-(void)requestMethods:(NSString *)str {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"username":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERvalidateUsername] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            
            
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


-(void)requestValidateMobilePhoneMethods:(NSString *)str {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"mobilePhone":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERvalidateMobilePhone] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"该手机号有效，可以注册"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self requestPhoneCodeMethods:_phoneNum.text];
            
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




-(void)requestPhoneCodeMethods:(NSString *)str {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"mobilePhone":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERappSendVcode] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"短信发送成功"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            cookieStr = [[responseObject objectForKey:@"object"] objectForKey:@"sessionId"];
            
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


-(void)requestRegestMethods{
    
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.navigationController.view displayInterval:2.0];
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    Base64XD * passwordBase64 = [Base64XD encodeBase64String:self.password.text];
    
    [paraDic setObject:_userName.text forKey:@"username"];
    [paraDic setObject:passwordBase64.strBase64 forKey:@"password"];
    [paraDic setObject:_phoneNum.text forKey:@"mobilePhone"];
    [paraDic setObject:_code.text forKey:@"phoneCaptcha"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSLog(@"%@%@",SERVERURL,USERpersonal);
    
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERpersonal] parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        child.age = 0;
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.navigationController.view
                                     displayInterval:3];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.navigationController.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // child.age = 0;
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.navigationController.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}





#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//监听方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([[change objectForKey:@"new"] integerValue] <= 0) {
        sheetLab.text = @"获取验证码";
        _sheetBtn.enabled = YES;
        _sheetBtn.backgroundColor = [ConMethods colorWithHexString:@"bd0100"];
        [child removeObserver:self forKeyPath:@"age"];
    } else {
        sheetLab.text = [NSString stringWithFormat:@"%@秒后获取",[change objectForKey:@"new"]];
        _sheetBtn.enabled = NO;
        _sheetBtn.backgroundColor = [UIColor grayColor];
        
    }
    
    
}


-(void)dealloc {
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushProcoalVC:(id)sender {
    UserProcrolViewController *cv = [[UserProcrolViewController alloc] init];
    cv.strId = @"YHXY";
    cv.strName = @"用户竞价协议";
   
    [self.navigationController pushViewController:cv animated:YES];
}


- (IBAction)sheetMethods:(id)sender {
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
                
                [self requestValidateMobilePhoneMethods:_phoneNum.text];
                
            }
       
     }
 }

- (IBAction)back:(id)sender {
    
    if (child.age > 0) {
        child.age = 0;
    }

    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (IBAction)next:(id)sender {
    
    [self.view endEditing:YES];
    if ([self.userName.text isEqualToString:@""]) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入正确的用户名"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        
    }else if (self.userName.text.length < 4 || self.userName.text.length > 18) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入用户名长度4~30位字符"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        
       
    }  else if ([self.password.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        
    } else if (![self.passwordAgain.text isEqualToString:self.password.text]){
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"两者密码不一致"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
       
    }  else if ([self.phoneNum.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入有效手机号码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
    }else if ([self.code.text isEqualToString:@""]) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入手机验证码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
    } else {
        [self requestRegestMethods];
   
    }
}



 
 


@end
