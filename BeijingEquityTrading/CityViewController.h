//
//  CityViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-27.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol CityDelegate
- (void)reloadCityTableView:(NSDictionary *)code;
@end

@interface CityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSString *strCode;
@property (nonatomic,strong)NSString *strTitle;

@property( assign, nonatomic ) id <CityDelegate> delegate;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
