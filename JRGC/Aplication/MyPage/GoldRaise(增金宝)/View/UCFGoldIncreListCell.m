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
@property (weak, nonatomic) IBOutlet UIView *upSegLine;
@property (weak, nonatomic) IBOutlet UIView *downSegLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineLeftSpace;

@end

@implementation UCFGoldIncreListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.monthDayLabel.textColor = UIColorWithRGB(0x555555);
    self.desLabel.textColor = UIColorWithRGB(0x333333);
}

- (void)setModel:(UCFGoldIncreaseListModel *)model
{
    _model = model;
    self.monthDayLabel.text = model.monthDay;
    if (model.profitMoney.doubleValue < 0.01) {
        self.desLabel.text = @"收益小于0.01元不计息";
    }
    else {
        self.desLabel.text = [NSString stringWithFormat:@"%@", model.profitMoney];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger totalRows = [self.tableview numberOfRowsInSection:indexPath.section];
    
    if (totalRows == 1) { // 这组只有1行
        self.downSegLine.hidden = NO;
        self.upSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 0;
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        self.upSegLine.hidden = NO;
        self.downSegLine.hidden = YES;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 15;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        self.upSegLine.hidden = NO;
        self.downSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 0;
    } else {
        self.upSegLine.hidden = NO;
        self.downSegLine.hidden = YES;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 15;
    }
}

@end
