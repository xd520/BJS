//
//  RealNameViewController.h
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/5.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProviceViewController.h"
#import "CityViewController.h"

@interface RealNameViewController : UIViewController<ProviousDelegate,CityDelegate>

@property(nonatomic,strong)NSString *idCard;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *password;

- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *prvoiceView;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UILabel *proviceLab;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureMethods:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *section;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
- (IBAction)codeMethods:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *adressView;
@property (weak, nonatomic) IBOutlet UIView *codeView;




@end
