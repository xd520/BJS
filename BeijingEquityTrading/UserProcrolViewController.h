//
//  UserProcrolViewController.h
//  FinancialAssets
//
//  Created by Yonghui Xiong on 15-2-6.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProcrolViewController : UIViewController

@property(nonatomic,strong)NSString *strId;
@property(nonatomic,strong)NSString *strName;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
