//
//  AppDelegate.m
//  BeijingEquityTrading
//
//  Created by mac on 15/10/12.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SpecialPerformanceViewController.h"
#import "TreasureViewController.h"
#import "MyViewController.h"
#import "CPVTabViewController.h"
#import "LoginViewController.h"
#import "MoreViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    
    _loginUser = [NSMutableDictionary dictionary];
    
    [self initTabBarControllerUI];
    /*
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    nav.delegate = self;
    self.window.rootViewController = nav;
    */
    
    [_window makeKeyAndVisible];
    
    return YES;
}

-(void)initTabBarControllerUI{
    _tabBarController = [[CPVTabViewController alloc] init];
    
    MainViewController *fisrtVC = [[MainViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:fisrtVC];
    nav1.delegate = self;
    
    SpecialPerformanceViewController *proVC = [[SpecialPerformanceViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:proVC];
    nav2.delegate = self;
    
    
    TreasureViewController *tranferVC = [[TreasureViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:tranferVC];
    nav3.delegate = self;
    
    
    
    
    MyViewController *myVC = [[MyViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:myVC];
    nav4.delegate = self;
    
    
    
    MoreViewController *moerVC = [[MoreViewController alloc] init];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:moerVC];
    nav5.delegate = self;
    
    
    
    _tabBarController.viewControllers =[[NSArray alloc] initWithObjects:nav1,nav2,nav3,nav4,  nil];
    _tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    
    NSArray *tbNormalArray = @[[UIImage imageNamed:@"nav_icon_home_focus"],[UIImage imageNamed:@"nav_icon_zc_focus"],[UIImage imageNamed:@"nav_icon_search_focus"],[UIImage imageNamed:@"nav_icon_user_focus"]];
    
    
    NSArray *tbHighlightArray = @[[UIImage imageNamed:@"nav_icon_home_normal"],[UIImage imageNamed:@"nav_icon_zc_normal"],[UIImage imageNamed:@"nav_icon_search_normal"],[UIImage imageNamed:@"nav_icon_user_normal"]];
    [_tabBarController setItemSelectedImages:tbNormalArray];
    
    [_tabBarController setTabBarItemsImage:tbHighlightArray];
    
    
    
    NSMutableArray *txtArr=[NSMutableArray arrayWithObjects:@"首页",@"专场",@"寻宝",@"我的",nil];
    
    [self.tabBarController setTabBarItemsTitle:txtArr];
    self.tabBarController.delegate = (id <UITabBarControllerDelegate>)self;
    
    [_tabBarController.tabBar setTintColor:[ConMethods colorWithHexString:@"850301"]];
    
    
    self.window.rootViewController = _tabBarController;
}

#pragma mark - UINavigationController Delegate Methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.navigationBarHidden = YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
