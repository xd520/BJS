//
//  ConMethods.m
//  ConMethods
//
//  Created by mac on 15/9/1.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "ConMethods.h"

@implementation ConMethods

CG_INLINE CGPoint
CGPointMake1(CGFloat x, CGFloat y)
{
    float autoSizeScaleX;
    
    if([[UIScreen mainScreen] bounds].size.width > 320){
        
        autoSizeScaleX = [[UIScreen mainScreen] bounds].size.width/320;
        
        
    }else{
        autoSizeScaleX = 1.0;
    }
    
    CGPoint p; p.x = x* autoSizeScaleX; p.y = y* autoSizeScaleX; return p;
}



CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    float autoSizeScaleX;
    
    if([[UIScreen mainScreen] bounds].size.width > 320){
        
        autoSizeScaleX = [[UIScreen mainScreen] bounds].size.width/320;
        
        
    }else{
        autoSizeScaleX = 1.0;
    }
    
    
    
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX; rect.origin.y = y * autoSizeScaleX;
    rect.size.width = width * autoSizeScaleX;
    rect.size.height = height * autoSizeScaleX;
    return rect;
}




+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


+ (UIColor *) colorWithHexString: (NSString *)color withApla:(float)_apla{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:_apla];
}

+ (CGRect)CGRectMake1:(CGRect)rect{
    float autoSizeScaleX;
    
    if([[UIScreen mainScreen] bounds].size.width > 320){
        
        autoSizeScaleX = [[UIScreen mainScreen] bounds].size.width/320;
        
        
    }else{
        autoSizeScaleX = 1.0;
    }
    
    rect.origin.x = rect.origin.x * autoSizeScaleX; rect.origin.y = rect.origin.y * autoSizeScaleX;
    rect.size.width = rect.size.width * autoSizeScaleX;
    rect.size.height = rect.size.height * autoSizeScaleX;
    return rect;


}

+ (CGPoint)CGPointMake1:(CGPoint)rect{
    float autoSizeScaleX;
    
    if([[UIScreen mainScreen] bounds].size.width > 320){
        
        autoSizeScaleX = [[UIScreen mainScreen] bounds].size.width/320;
        
        
    }else{
        autoSizeScaleX = 1.0;
    }
    
     rect.x = rect.x* autoSizeScaleX; rect.y = rect.y* autoSizeScaleX;
    return rect;

}

+ (UIView *) clippingViewForLayerMask:(UIImageView *)imgView{

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    // UIBezierPath *layerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, 78, 78)];
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 5.0;
    
    aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    // Set the starting point of the shape.
    [aPath moveToPoint:CGPointMake1(41.0, 0.0)];
    
    // Draw the lines
    [aPath addLineToPoint:CGPointMake1(80.0, 22.0)];
    [aPath addLineToPoint:CGPointMake1(80, 89 - 22)];
    [aPath addLineToPoint:CGPointMake1(41.0, 89)];
    [aPath addLineToPoint:CGPointMake1(0.0, 89 - 22)];
    [aPath addLineToPoint:CGPointMake1(0.0, 22.0)];
    [aPath closePath]; //第五条线通过调用closePath方法得到的
    
    [aPath fill]; //Draws line 根据坐标点连线
    
    
    maskLayer.path = aPath.CGPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    UIView *clippingViewForLayerMask = [[UIView alloc] initWithFrame:CGRectMake1(120, 4 , 80, 90)];
    clippingViewForLayerMask.backgroundColor = [UIColor whiteColor];
    clippingViewForLayerMask.layer.mask = maskLayer;
    // clippingViewForLayerMask.clipsToBounds = YES;
    
    [clippingViewForLayerMask addSubview:imgView];

    return clippingViewForLayerMask;

}


/*
- (void)requestCategoryList:(NSString *)_headURL withFormt:(NSString *)_str withImage:(UIImageView *)imgView{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_headURL,_str]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];//创建数据请求对象
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:5];
    [request setDelegate:self];//设置代理
    [request startAsynchronous];//发送异步请求
    
    //设置网络请求完成后调用的block
    [request setCompletionBlock:^{
        
        //         NSLog(@"%@",request.responseHeaders);
        
        //NSData *data = request.responseData;
        imgView.image = [UIImage imageWithData:request.responseData];
        
        //---------------判断数据的来源:网络 or缓存------------------
        if (request.didUseCachedResponse) {
            NSLog(@"数据来自缓存");
        } else {
            NSLog(@"数据来自网络");
        }
        
    }];
    
    //请求失败调用的block
    [request setFailedBlock:^{
        
        NSError *error = request.error;
        NSLog(@"请求网络出错：%@",error);
    }];

}
*/


+(NSString *)digitUppercase:(NSString *)money{
    NSString *str;
    //获取最后一位整数是否为零
    if ([[money substringFromIndex:money.length-1] isEqualToString:@"0"]) {
        str = @"圆整";
    } else {
        str = @"整";
    }
    
    
    NSMutableString *moneyStr=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[money doubleValue]]];
    NSArray *MyScale=@[@"分", @"角", @"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ];
    NSArray *MyBase=@[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    NSMutableString *M=[[NSMutableString alloc] init];
    [moneyStr deleteCharactersInRange:NSMakeRange([moneyStr rangeOfString:@"."].location, 1)];
    NSLog(@"%@",moneyStr);
    
    for(int i=(int)moneyStr.length;i>0;i--)
    {
        NSInteger MyData=[[moneyStr substringWithRange:NSMakeRange(moneyStr.length-i, 1)] integerValue];
        [M appendString:MyBase[MyData]];
        if([[moneyStr substringFromIndex:moneyStr.length-i+1] integerValue] == 0&& i != 1 && i != 2 && moneyStr.length > 2)
        {
            [M appendString:MyScale[i-1]];
            [M appendString:str];
            
            break;
            
        }
        [M appendString:MyScale[i-1]];
    }
    return M;

}

+ (NSInteger)rangeString:(NSString *)string {
    int Num = 0;
    NSString *lastStr = @".";
    for (int i = 0; i < string.length; i++) {
        NSString *newStr = [string substringWithRange:NSMakeRange(i, 1)];
        if ([lastStr isEqualToString:newStr]) {
            Num ++;
            //lastStr = newStr;
            NSLog(@"%@",newStr);
        }
    }
    return Num;
}





@end
