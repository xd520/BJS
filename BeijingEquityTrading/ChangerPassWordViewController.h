//
//  ChangerPassWordViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangerPassWordViewController : UIViewController
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *oldPW;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
- (IBAction)codeMethods:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureMehtods:(id)sender;
- (IBAction)pushVC:(id)sender;
- (IBAction)changePasswordMethods:(id)sender;

@end
