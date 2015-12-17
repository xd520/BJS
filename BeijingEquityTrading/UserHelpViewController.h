//
//  UserHelpViewController.h
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/17.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHelpViewController : UIViewController


@property(nonatomic,strong)NSString *strId;
@property(nonatomic,strong)NSString *strName;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
