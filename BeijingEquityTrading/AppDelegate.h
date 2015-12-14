//
//  AppDelegate.h
//  BeijingEquityTrading
//
//  Created by mac on 15/10/12.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareMyData.h"
#import "ConMethods.h"
#import "PublicMethod.h"
#import "NetWork.h"
#import "HttpMethods.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SDRefresh.h"
#import "Base64XD.h"


@class CPVTabViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>{
    UIBackgroundTaskIdentifier bgTask;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)CPVTabViewController *tabBarController;
@property (strong, nonatomic) NSMutableDictionary *loginUser;


@end

