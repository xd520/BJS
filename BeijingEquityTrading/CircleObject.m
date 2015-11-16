//
//  CircleObject.m
//  Circle
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "CircleObject.h"

@implementation CircleObject

@synthesize length,color,cirMaxX,cirMinX,cirradius,colorNext;

- (id)initWithMinx:(float)cirMinx MaxX:(float)cirMax cirradius:(float)cirradiu withlength:(float)lengt withColor:(UIColor *)col withNext:(UIColor *)nextcolor{
    
    self = [super init];
    if (self) {
        
        self.length = lengt;
        self.color = col;
        self.cirMinX = cirMinx;
        self.cirMaxX = cirMax;
        self.cirradius = cirradiu;
        self.colorNext = nextcolor;
    }
    return self;
    
}


@end
