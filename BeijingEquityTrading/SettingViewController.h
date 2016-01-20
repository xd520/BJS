//
//  SettingViewController.h
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 16/1/19.
//  Copyright © 2016年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *helpLeb;
@property (weak, nonatomic) IBOutlet UILabel *aboutLab;

@end
