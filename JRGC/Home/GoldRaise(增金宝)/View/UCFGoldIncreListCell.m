//
//  UCFGoldIncreListCell.m
//  JRGC
//
//  Created by njw on 2017/8/21.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldIncreListCell.h"
#import "UCFGoldIncreaseListModel.h"

@interface UCFGoldIncreListCell ()
@property (weak, nonatomic) IBOutlet UILabel *monthDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation UCFGoldIncreListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UCFGoldIncreaseListModel *)model
{
    _model = model;
    self.monthDayLabel.text = model.monthDay;
    if (model.profitMoney.doubleValue < 0.01) {
        self.desLabel.text = @"收益小于0.01元不计息";
    }
    else {
        self.desLabel.text = [NSString stringWithFormat:@"%@元", model.profitMoney];
    }
}

@end
