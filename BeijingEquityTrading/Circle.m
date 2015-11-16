//
//  Circle.m
//  Circle
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "Circle.h"
#import "CircleObject.h"

@implementation Circle

@synthesize object;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.object = [[CircleObject alloc] init];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGPoint center;
    
    center.x = rect.origin.x + rect.size.width/2;
    center.y = rect.origin.y + rect.size.height/2;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:center
                    radius:self.object.length
                startAngle:M_PI*0
                  endAngle:M_PI*(self.object.cirradius/180)
                 clockwise:YES];
    
    /*
     弧度＝(角度/180) *PI
     PI就是“派”
     比如180度角，转换之后的弧度就是PI，45度的话是四分之一PI。
     反过来也一样，角度=弧度/PI  * 180
     
     */
    
    
    path.lineWidth = self.object.cirMinX;
    [self.object.colorNext setStroke];
    [path stroke];
    
    path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:center
                    radius:self.object.length
                startAngle:M_PI*(self.object.cirradius/180)
                  endAngle:M_PI*0
                 clockwise:YES];
    
    path.lineWidth = self.object.cirMaxX;
    [self.object.color setStroke];
    [path stroke];
    
}


@end
