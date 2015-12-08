//
//  ProviceViewController.h
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/7.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProviousDelegate
- (void)reloadProviousTableView:(NSDictionary *)code;
@end


@interface ProviceViewController : UIViewController
- (IBAction)back:(id)sender;
@property( assign, nonatomic ) id <ProviousDelegate> delegate;
@end
