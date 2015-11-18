//
//  MoreTableViewCell.h
//  BeijingEquityTrading
//
//  Created by mac on 15/11/18.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListData;
@interface MoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyNameL;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *timeNmaeL;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *classNameL;
@property (weak, nonatomic) IBOutlet UILabel *classLab;
@property(nonatomic,strong)NSString *timeEnd;

@property(nonatomic,strong)ListData *listDt;
+(id) testCell;
-(void)setModel:(ListData *)model;

@end
