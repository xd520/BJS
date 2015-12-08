//
//  SureMoneyViewController.h
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/7.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SureMoneyViewController : UIViewController

@property(nonatomic,strong)NSString *strId;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
