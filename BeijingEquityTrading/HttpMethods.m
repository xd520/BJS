//
//  HttpMethods.m
//  BeijingEquityTrading
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "HttpMethods.h"
#import "MBProgressHUD.h"

@implementation HttpMethods


static HttpMethods *sharedClient = nil;
+ (HttpMethods *)Instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[HttpMethods alloc] init];
    });
    return sharedClient;
}



#pragma mark 提醒框相关
- (void)activityIndicate:(BOOL)isBegin tipContent:(NSString *)content MBProgressHUD:(MBProgressHUD *)hudd target:(UIView *)target displayInterval:(float)interval
{
    if ([NSThread isMainThread])
    {
        [self onDisplayMBProcessHUD:isBegin tipContent:content MBProgressHUD:hudd target:target displayInterval:interval];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self onDisplayMBProcessHUD:isBegin tipContent:content MBProgressHUD:hudd target:target displayInterval:interval];
        });
    }
}

- (void)onDisplayMBProcessHUD:(BOOL)isBegin tipContent:(NSString *)content MBProgressHUD:(MBProgressHUD *)hudd target:(UIView *)target displayInterval:(float)interval
{
    [hud setHidden:NO];
    [hud setOpaque:YES];
    
    if(isBegin){
        if(hud == nil ){
            hud = [MBProgressHUD showHUDAddedTo:target animated:YES];
        }
        if(hud.bNeedHidden && hud){
            [hud hide:YES];
            hud = nil;
            hud = [MBProgressHUD showHUDAddedTo:target animated:YES];
        }
        
        [target setUserInteractionEnabled:NO];
        if(target == nil){
            [[[UIApplication sharedApplication] keyWindow].rootViewController.view setUserInteractionEnabled:NO];
        }
        
        hud.animationType = MBProgressHUDAnimationZoomOut;
        hud.detailsLabelText = content;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
        hud.mode = MBProgressHUDModeIndeterminate;
        [target bringSubviewToFront:hud];
    }
    else {
        if(hud == nil && content.length > 0 && content){
            hud = [MBProgressHUD showHUDAddedTo:target animated:YES];
        }
        
        [target setUserInteractionEnabled:YES];
        if(target == nil){
            [[[UIApplication sharedApplication] keyWindow].rootViewController.view setUserInteractionEnabled:YES];
        }
        
        if(content == nil){
            [hud hide:YES];
            hud = nil;
        }
        else{
            hud.mode = 	MBProgressHUDModeText;
            hud.animationType = MBProgressHUDAnimationZoomOut;
            [hud setUserInteractionEnabled:NO];
            hud.detailsLabelText = content;
            hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
            hud.bNeedHidden = YES;
            [self performSelector:@selector(hiddenHud) withObject:nil afterDelay:interval];
        }
    }
}

- (void) hiddenHud{
    if(hud.bNeedHidden){
        [hud hide:YES];
        hud = nil;
    }
}




@end
