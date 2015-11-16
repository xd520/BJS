//
//  HttpMethods.h
//  BeijingEquityTrading
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface HttpMethods : NSObject{
    MBProgressHUD * hud;
}

+ (HttpMethods *)Instance;

#pragma mark 提示相关
/*
 有两种提醒状态:
 如果isBegin为真，则处于正在请求状态，此时interval不起作用,提示框将在请求完成时自动消失
 如果isBegin为假，则处于正在提醒状态，此时interval起作用,提示框过了interval后消失
 */
- (void)activityIndicate:(BOOL)isBegin tipContent:(NSString *)content MBProgressHUD:(MBProgressHUD *)hudd target:(UIView *)target displayInterval:(float)interval ;

#pragma mark VLog相关
//- (void)onConfigurateLog:(BOOL)bShowDebugPage showLogView:(BOOL)bShowLogView;



@end
