//
//  LoginViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-9.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>



#import "AppDelegate.h"
@interface LoginViewController : UIViewController


@property (strong, nonatomic)NSString *loginStr;

@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIView *allView;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)push:(id)sender;
- (IBAction)loginBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rember;
- (IBAction)foggoterPW:(id)sender;
- (IBAction)quit:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgve;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIView *headVeiw;

@end
