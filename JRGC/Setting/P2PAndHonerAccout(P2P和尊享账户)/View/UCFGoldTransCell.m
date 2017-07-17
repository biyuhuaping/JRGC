//
//  UCFGoldTransCell.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldTransCell.h"

@interface UCFGoldTransCell ()
@property (weak, nonatomic) IBOutlet UILabel *dealType; //交易类型
@property (weak, nonatomic) IBOutlet UILabel *turnoverLab;
@property (weak, nonatomic) IBOutlet UILabel *dealMoney;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailToEndSpace;

@end

@implementation UCFGoldTransCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
    self.dealType.textColor = UIColorWithRGB(0x555555);
    self.trailToEndSpace.constant = ScreenWidth/320.0f * 140.f;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.isEndCell) {
        self.bottomLine.hidden = YES;
    } else {
        self.bottomLine.hidden = NO;
    }
    if ([_model.tradeTypeCode isEqualToString:@"11"]) {
        self.dealType.text = @"冻结";
        
    } else if([_model.tradeTypeCode isEqualToString:@"12"]){

        self.dealType.text = @"买金";
        
    }    self.turnoverLab.text = _model.purchaseAmount;
    self.dealMoney.text = _model.tradeMoney;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
