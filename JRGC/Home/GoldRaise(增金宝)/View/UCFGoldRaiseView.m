//
//  UCFGoldRaiseView.m
//  JRGC
//
//  Created by njw on 2017/8/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRaiseView.h"
#import "UCFGoldIncreaseAccountInfoModel.h"
#import "NZLabel.h"

@interface UCFGoldRaiseView ()
@property (weak, nonatomic) IBOutlet NZLabel *goldIncreaseAmount;
@property (weak, nonatomic) IBOutlet UILabel *addedProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *floatProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePriceLabel;
@property (weak, nonatomic) IBOutlet UIView *upBaseView;

@end

@implementation UCFGoldRaiseView

+ (CGFloat)viewHeight
{
    return 160;
}
- (IBAction)floatDetail:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(floatDetailClicedButton:)]) {
        [self.delegate floatDetailClicedButton:sender];
    }
}
- (IBAction)averagePriceDetail:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(averagePriceDetailClicedButton:)]) {
        [self.delegate averagePriceDetailClicedButton:sender];
    }
}

- (void)setGoldIncreModel:(UCFGoldIncreaseAccountInfoModel *)goldIncreModel
{
    _goldIncreModel = goldIncreModel;
    self.goldIncreaseAmount.text = goldIncreModel.goldAmount ? [NSString stringWithFormat:@"%@克", goldIncreModel.goldAmount] : @"0.000克";
    self.addedProfitLabel.text = goldIncreModel.allGiveMoney ? [NSString stringWithFormat:@"%@元", goldIncreModel.allGiveMoney] : @"0.00元";
    self.floatProfitLabel.text = goldIncreModel.floatingPL ? [NSString stringWithFormat:@"%@元", goldIncreModel.floatingPL] : @"0.00元";
    self.averagePriceLabel.text = goldIncreModel.dealPrice ?  [NSString stringWithFormat:@"%@元/克", goldIncreModel.dealPrice] : @"0.00元/克";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.upBaseView.backgroundColor = UIColorWithRGB(0x5B6993);
    [self.goldIncreaseAmount setFont:[UIFont systemFontOfSize:16] string:@"克"];
    if ([self.goldIncreModel.floatingPL hasPrefix:@"+"]) {
        self.floatProfitLabel.textColor = UIColorWithRGB(0xfd4d4c);
    }
    else if ([self.goldIncreModel.floatingPL hasPrefix:@"-"]) {
        self.floatProfitLabel.textColor = UIColorWithRGB(0x4db94f);
    }
    else {
        self.floatProfitLabel.textColor = UIColorWithRGB(0x555555);
    }
}

@end
