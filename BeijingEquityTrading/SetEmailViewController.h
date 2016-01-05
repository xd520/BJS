//
//  SetEmailViewController.h
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 16/1/5.
//  Copyright © 2016年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetEmailViewController : UIViewController
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)commitMethods:(id)sender;

@end
