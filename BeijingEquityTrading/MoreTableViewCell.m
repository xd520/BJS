//
//  MoreTableViewCell.m
//  BeijingEquityTrading
//
//  Created by mac on 15/11/18.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MoreTableViewCell.h"
#import "ConMethods.h"
#import "ListData.h"

@implementation MoreTableViewCell

- (void)awakeFromNib {
    
}


+(id) testCell
 {
         return [[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" owner:self options:nil][0];
}


-(void)setModel:(ListData *)model
{
     
     _image.image = [UIImage imageNamed:@"logo"];
    _nameLab.text = model.nameLab;
     
     if (model.isDJS) {
         _timeEnd = model.timeEndtime;
         [self startTimer];
     }

     
}

//开启定时器方法：
- (void)startTimer
{
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLessTime:) userInfo:nil repeats:YES];
    
    // 如果不添加下面这条语句，在UITableView拖动的时候，会阻塞定时器的调用
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    [self layoutSubviews];
}

- (void)refreshLessTime:(NSTimer*)timer
{
   
    
    
    int seconds = [_timeEnd intValue];
    int dayCount = seconds%(3600*24);
    int day = (seconds - dayCount)/(3600*24);
    
    int hourCount = dayCount%3600;
    int hour = (dayCount - hourCount)/3600;
    
    int minCount = hourCount%60;
    int min = (hourCount - minCount)/60;
    int miao = minCount;
    
    NSString *time = [NSString stringWithFormat:@"%i日%i小时%i分钟%i秒",day,hour,min,miao];
    
    _timeLab.text = time;
    
    
    [self awakeFromNib];
}



/*
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
       // [self layoutIfNeeded];
      //  [self layoutSubviews];
        
       
    }
    return self;
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    
}


-(void)layoutIfNeeded{

    [super layoutIfNeeded];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
