//
//  UCFTransfeTableViewCell.m
//  JRGC
//
//  Created by 张瑞超 on 2017/6/9.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFTransfeTableViewCell.h"

@interface UCFTransfeTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLeadSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLeadSpace;

@end

@implementation UCFTransfeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bottomLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
    self.rateLabel.textColor = UIColorWithRGB(0xfd4d4c);
    self.timeLabel.textColor = UIColorWithRGB(0x555555);
    self.moneyLabel.textColor = UIColorWithRGB(0x555555);
    
    _timeLeadSpace.constant = (ScreenWidth * 120.0f )/320.0f;
    _moneyLeadSpace.constant = (ScreenWidth * 215.0f )/320.0f;
}
- (void)layoutSubviews
{
    self.rateLabel.text = [NSString stringWithFormat:@"%@%%",_model.transfereeYearRate];
    [self.rateLabel setFont:[UIFont systemFontOfSize:12] string:@"%"];
    self.timeLabel.text = [NSString stringWithFormat:@"%@天",_model.lastDays];
    self.moneyLabel.text = _model.cantranMoney;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(transferCellDidSelectModel:)]) {
//        [self.delegate transferCellDidSelectModel:_model];
//    }
    // Configure the view for the selected state
}

@end
