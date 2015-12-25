//
//  MarkDetailViewController.h
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/24.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkDetailViewController : UIViewController

@property(nonatomic,strong)NSString *strId;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
