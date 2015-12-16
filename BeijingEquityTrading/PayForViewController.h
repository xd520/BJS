//
//  PayForViewController.h
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/14.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayForViewController : UIViewController


@property(nonatomic,strong)NSString *strId;
@property(nonatomic,strong)NSString *markId;


- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *payBigMoney;
@property (weak, nonatomic) IBOutlet UITextField *jiaoyiPassword;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
- (IBAction)codeMethods:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rember;
- (IBAction)remberMethods:(id)sender;
- (IBAction)ProctalMethods:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureMethods:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
