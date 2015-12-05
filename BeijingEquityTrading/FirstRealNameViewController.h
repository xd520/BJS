//
//  FirstRealNameViewController.h
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/5.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstRealNameViewController : UIViewController
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *identiyNum;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *passWordAgain;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextMthods:(id)sender;

@end
