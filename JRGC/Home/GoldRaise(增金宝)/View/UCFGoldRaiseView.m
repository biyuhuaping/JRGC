//
//  UCFGoldRaiseView.m
//  JRGC
//
//  Created by njw on 2017/8/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRaiseView.h"
#import "UCFGoldIncreaseAccountInfoModel.h"

@interface UCFGoldRaiseView ()
@property (weak, nonatomic) IBOutlet UILabel *goldIncreaseAmount;
@property (weak, nonatomic) IBOutlet UILabel *addedProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *floatProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePriceLabel;
@end

@implementation UCFGoldRaiseView

+ (CGFloat)viewHeight
{
    return 200;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.goldIncreaseAmount.text = self.goldIncreModel.goldAmount > 0 ? @"0.000克" : [NSString stringWithFormat:@"%@", self.goldIncreModel.goldAmount];
    self.addedProfitLabel.text = self.goldIncreModel.allGiveMoney > 0 ? @"0.00元" : [NSString stringWithFormat:@"%@元", self.goldIncreModel.allGiveMoney];
    self.floatProfitLabel.text = self.goldIncreModel.floatingPL > 0 ? @"0.00元" : [NSString stringWithFormat:@"%@元", self.goldIncreModel.floatingPL];
    self.averagePriceLabel.text = self.goldIncreModel.dealPrice > 0 ? @"0.00元/克" : [NSString stringWithFormat:@"%@元/克", self.goldIncreModel.dealPrice];
}

@end
