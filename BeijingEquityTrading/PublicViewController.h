//
//  PublicViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-5-11.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PublicViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property(nonatomic,strong)NSString *strId;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *headView;

@end
