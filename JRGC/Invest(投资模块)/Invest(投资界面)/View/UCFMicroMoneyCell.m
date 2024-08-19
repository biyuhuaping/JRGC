//
//  UCFMicroMoneyCell.m
//  JRGC
//
//  Created by hanqiyuan on 2018/7/25.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFMicroMoneyCell.h"
#import "UCFProjectLabel.h"
@implementation UCFMicroMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMicroModel:(UCFMicroMoneyModel *)microModel
{
    _microModel = microModel;
    self.anurateLabel.text = microModel.annualRate ? [NSString stringWithFormat:@"%@%%",microModel.annualRate] : @"0.0%";
    [self.anurateLabel setFont:[UIFont systemFontOfSize:16] string:@"%"];
    self.limitLabel.text = [NSString stringWithFormat:@"%@", microModel.repayPeriodtext];
  
    self.prdNameLabel.text = microModel.prdName;
    NSUInteger type = [microModel.type integerValue];
    switch (type) {
        case 0://预约
        {
            _microModel.modelType = UCFMicroMoneyModelTypeReserve;
            if([microModel.status intValue] == 2)
            {
              [self.reserveButton setTitle:@"立即预约" forState:UIControlStateNormal];
              self.reserveButton.userInteractionEnabled = YES;
              self.reserveButton.backgroundColor = UIColorWithRGB(0xFD4D4C);
            }else{
                self.reserveButton.userInteractionEnabled = NO;
                self.reserveButton.backgroundColor = UIColorWithRGB(0xd4d4d4);
                [self.reserveButton setTitle:@"预约已满" forState:UIControlStateNormal];
            }
            
        }
            break;
        case 3://智存宝用3
        {
              _microModel.modelType = UCFMicroMoneyModelTypeIntelligent;
            if([microModel.status intValue] == 2)
            {
                self.reserveButton.backgroundColor = UIColorWithRGB(0xFD4D4C);
                self.reserveButton.userInteractionEnabled = YES;
                NSString *buttonStr = [UserInfoSingle sharedManager].isSubmitTime ? @"立即购买":@"立即出借";
                [self.reserveButton setTitle:buttonStr forState:UIControlStateNormal];
              
            }else{
                self.reserveButton.userInteractionEnabled = NO;
                self.reserveButton.backgroundColor = UIColorWithRGB(0xd4d4d4);
                [self.reserveButton setTitle:@"已售罄" forState:UIControlStateNormal];
                
            }
        }
            break;
        case 14://批量出借
        {
             _microModel.modelType = UCFMicroMoneyModelTypeBatchBid;
            if([microModel.status intValue] == 2)
            {
                NSString *buttonStr = [UserInfoSingle sharedManager].isSubmitTime ? @"一键购买":@"一键出借";
                [self.reserveButton setTitle:buttonStr forState:UIControlStateNormal];
                self.reserveButton.backgroundColor = UIColorWithRGB(0xFD4D4C);
                self.reserveButton.userInteractionEnabled = YES;
            }else{
                self.reserveButton.userInteractionEnabled = NO;
                self.reserveButton.backgroundColor = UIColorWithRGB(0xd4d4d4);
                [self.reserveButton setTitle:@"已售罄" forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
    if (microModel.prdLabelsList.count > 0) {
        UCFProjectLabel *projectLabel = [microModel.prdLabelsList firstObject];
        if ([projectLabel.labelPriority integerValue] == 1) {
            self.prdNameTipLabel.hidden = NO;
            self.prdNameTipLabel.text = [NSString stringWithFormat:@"%@", projectLabel.labelName];
            CGSize size = [projectLabel.labelName boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
            self.PrdNameTipLabelWidth.constant = size.width + 10;
            self.prdNameTipLabel.layer.cornerRadius = 2.0f;
            self.prdNameTipLabel.layer.masksToBounds = YES;
        }
        else {
            self.prdNameTipLabel.hidden = YES;
            self.PrdNameTipLabelWidth.constant = 0;
        }
    }
    else {
        self.prdNameTipLabel.hidden = YES;
        self.PrdNameTipLabelWidth.constant = 0;
    }
    
    if ([microModel.platformSubsidyExpense floatValue] > 0.00) {
        self.addedRateLabel.text = [NSString stringWithFormat:@"+%@%%",microModel.platformSubsidyExpense];
        self.addedRateLabel.hidden = NO;
    }
    else {
         self.addedRateLabel.text = @"";
         self.addedRateLabel.hidden = YES;
    }
}
- (IBAction)gotoClickReserve:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(microMoneyListCell:didClickedInvestButtonWithModel:)])
    {
        [self.delegate microMoneyListCell:self didClickedInvestButtonWithModel:self.microModel];
    }
}
@end
