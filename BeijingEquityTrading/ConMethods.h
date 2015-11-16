//
//  ConMethods.h
//  ConMethods
//
//  Created by mac on 15/9/1.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ConMethods : NSObject

+ (UIColor *) colorWithHexString: (NSString *)color;

+ (UIColor *) colorWithHexString: (NSString *)color withApla:(float)_apla;
//320适配
+ (CGRect)CGRectMake1:(CGRect)rect;
+ (CGPoint)CGPointMake1:(CGPoint)rect;

//正六边形
+ (UIView *) clippingViewForLayerMask:(UIImageView *)imgView;

//获取图片
//+ (void)requestCategoryList:(NSString *)_headURL withFormt:(NSString *)_str withImage:(UIImageView *)imgView;

//此方法只能适用于十亿以下 money 只能是整数
+(NSString *)digitUppercase:(NSString *)money;
//几个逗号
+ (NSInteger)rangeString:(NSString *)string;

@end
