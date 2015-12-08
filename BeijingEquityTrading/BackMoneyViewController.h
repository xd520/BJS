//
//  BackMoneyViewController.h
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/8.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackMoneyViewController : UIViewController

@property(nonatomic,strong)NSString *strId;
@property(nonatomic,strong)NSString *markId;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
