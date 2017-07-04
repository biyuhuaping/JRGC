//
//  UCFCalendarDayCell.m
//  JRGC
//
//  Created by njw on 2017/7/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCalendarDayCell.h"
#import "UCFCalendarGroup.h"

@interface UCFCalendarDayCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation UCFCalendarDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    switch (self.indexPath.row) {
        case 0: {
            self.nameLabel.text = @"本金";
            self.valueLabel.text = self.group.principal;
        }
            break;
            
        case 1: {
            self.nameLabel.text = @"利息";
            self.valueLabel.text = self.group.interest;
        }
            break;
            
        case 2: {
            self.nameLabel.text = @"违约金";
            self.valueLabel.text = self.group.prepaymentPenalty;
        }
            break;
    }
}

@end
