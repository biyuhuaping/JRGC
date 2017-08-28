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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpace;

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
    if (self.sepLinePostion == 0) {
        self.bottomLine.hidden = NO;
        self.bottomLine.frame = CGRectMake(15, CGRectGetMinY(self.bottomLine.frame), ScreenWidth - 15, 0.5);
        self.leftSpace.constant = 15;
        
    } else if (self.sepLinePostion == 1){
        self.bottomLine.hidden = YES;
        self.leftSpace.constant = 0;
        
    } else if (self.sepLinePostion == 2) {
        self.bottomLine.hidden = NO;
        self.leftSpace.constant = 0;
        
    }
    self.dealType.text = _model.tradeTypeName;
    self.dealMoney.hidden = NO;
    if ([_model.tradeTypeCode isEqualToString:@"99"]) { //买金
        self.turnoverLab.textColor = UIColorWithRGB(0xfd4d4c);
        self.dealMoney.textColor = UIColorWithRGB(0xfd4d4c);
    } else if ([_model.tradeTypeCode isEqualToString:@"98"]) { //冻结
        self.turnoverLab.textColor = UIColorWithRGB(0x999999);
        self.dealMoney.textColor = UIColorWithRGB(0x999999);
    } else if ([_model.tradeTypeCode isEqualToString:@"109"]) {//变现冻结
        self.turnoverLab.textColor = UIColorWithRGB(0x999999);
        self.dealMoney.textColor = UIColorWithRGB(0x999999);
    } else if ([_model.tradeTypeCode isEqualToString:@"110"]) {//变现
        self.turnoverLab.textColor = UIColorWithRGB(0x4db94f);
        self.dealMoney.textColor = UIColorWithRGB(0x4db94f);
    } else if ([_model.tradeTypeCode isEqualToString:@"111"]) {//收益克重
        self.turnoverLab.textColor = UIColorWithRGB(0xfd4d4c);
        self.dealMoney.textColor = UIColorWithRGB(0xfd4d4c);
        self.dealMoney.hidden = YES;
    }

    self.dealMoney.text = [NSString stringWithFormat:@"%@",_model.tradeMoney];
    self.turnoverLab.text = [NSString stringWithFormat:@"%@克",_model.purchaseAmount];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
