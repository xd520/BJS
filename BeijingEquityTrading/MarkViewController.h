//
//  MarkViewController.h
//  BeijingEquityTrading
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkViewController : UIViewController

@property(nonatomic,strong)NSString *strId;

@property (weak, nonatomic) IBOutlet UIView *headView;
- (IBAction)back:(id)sender;
- (IBAction)shareMethods:(id)sender;

@end
