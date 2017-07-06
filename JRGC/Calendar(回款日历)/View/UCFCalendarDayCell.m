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


@property (weak, nonatomic) IBOutlet UIView *upLine;
@property (weak, nonatomic) IBOutlet UIView *downLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineLeftSpace;

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

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger totalRows = [self.tableview numberOfRowsInSection:indexPath.section];
    if (totalRows == 1) { // 这组只有1行
        self.downLine.hidden = NO;
        self.upLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 0;
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        self.upLine.hidden = NO;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.downLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 15;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        self.upLine.hidden = YES;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 0;
    } else {
        self.upLine.hidden = YES;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 15;
    }
}

@end
