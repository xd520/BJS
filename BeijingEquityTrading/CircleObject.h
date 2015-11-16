//
//  CircleObject.h
//  Circle
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CircleObject : NSObject

@property(nonatomic) float cirMinX;//灰色进度宽度
@property(nonatomic) float cirMaxX;//红色进度宽度
@property(nonatomic) float cirradius;//弧长
@property(nonatomic) float length;//半径
@property(nonatomic,strong)UIColor *color; //进度颜色
@property(nonatomic,strong)UIColor *colorNext; //进度颜色

- (id)initWithMinx:(float)cirMinx MaxX:(float)cirMaxX cirradius:(float)cirradius withlength:(float)length withColor:(UIColor *)color withNext:(UIColor *)nextcolor;

@end
