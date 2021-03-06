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

//跳转协议的时候
@property(nonatomic,assign)BOOL isUpDate;


@property (nonatomic,strong) UIScrollView *scrollViewImg;
@property (strong, nonatomic) UIPageControl *pageControl;   // 当前imageView
@property (nonatomic,strong)NSTimer *timerImg;                 //设置动画

@property (weak, nonatomic) IBOutlet UIView *headView;
- (IBAction)back:(id)sender;
- (IBAction)shareMethods:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end
