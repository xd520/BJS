//
//  CPVTabViewController.m
//  TABBarTest
//
//  Created by mac on 15/9/1.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "CPVTabViewController.h"
#import "ConMethods.h"

@interface CPVTabViewController ()

@end

@implementation CPVTabViewController
//@synthesize _badgeValueImage;

- (id)init {
    self = [super init];
    if (self) {
        
        }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - OverRide Super Class
- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    
}

#pragma mark - Setter for Items Title

 - (void)setTabBarItemsTitle:(NSArray *)titles
 {
 for (int i = 0; i < self.tabBar.items.count && i < titles.count; ++i)
 {
     UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:i];
    
     tabBarItem.title = [titles objectAtIndex:i];
 }
 }

#pragma mark - Setter for Items Image

 - (void)setTabBarItemsImage:(NSArray *)images
 {
 for (int i = 0; i < self.tabBar.items.count && i < images.count; ++i) {
     UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:i];
     
      if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
     
          tabBarItem.image = [[images objectAtIndex:i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      }else {
      
          tabBarItem.image = [images objectAtIndex:i];
      }
 }
 }

- (void)setTabBarBackgroundImage:(UIImage *)image
{
    self.tabBar.backgroundImage = image;
}


- (void)setItemSelectedImages:(NSArray *)selectedImages
{
    for (int i = 0; i < selectedImages.count; ++i) {
        UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:i];
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        tabBarItem.selectedImage = [[selectedImages objectAtIndex:i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
           // tabBarItem.selectedImage = [[selectedImages objectAtIndex:i] imageWithAlignmentRectInsets:dgeInsetsMake(5, 5, 5, 5)];
            tabBarItem.selectedImage = [selectedImages objectAtIndex:i];
            
            
        
        }
    }
}



- (void)showBadge
{
    
    if (!_badgeValueImage) {
        _badgeValueImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_circle"]];
        
        [self.tabBar addSubview:_badgeValueImage];
        self.tabBar.backgroundColor = [UIColor whiteColor];
    

    
    NSInteger imageCount = self.tabBarController.viewControllers.count;
    CGFloat cellWidth = self.tabBar.frame.size.width / imageCount;
    CGFloat xOffest = self.tabBar.frame.size.width - cellWidth/2.0 + 8.0f;
    _badgeValueImage.frame = CGRectMake(cellWidth*(imageCount - 1) + xOffest, 8.0f, 8.0f, 8.0f);
    _badgeValueImage.backgroundColor = [UIColor  clearColor];
    
    }
}

- (void)hiddenBadge
{
    
    _badgeValueImage.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
