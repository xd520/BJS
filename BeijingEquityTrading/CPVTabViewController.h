//
//  CPVTabViewController.h
//  TABBarTest
//
//  Created by mac on 15/9/1.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPVTabViewController : UITabBarController

{
    UIImageView *_badgeValueImage;
}

//[UIImage imageNamed:@"number_warning.png"]提示图片


- (void)setTabBarItemsTitle:(NSArray *)titles;
- (void)setTabBarItemsImage:(NSArray *)images;

- (void)setTabBarBackgroundImage:(UIImage *)image;

//- (void)setItemImages:(NSArray *)images;
- (void)setItemSelectedImages:(NSArray *)selectedImages;

- (void)showBadge;
- (void)hiddenBadge;



@end
