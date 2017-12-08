//
//  UCFCalculateResultView.m
//  JRGC
//
//  Created by njw on 2017/12/8.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFCalculateResultView.h"
#import "UCFProfitCalculateResult.h"

@interface UCFCalculateResultView ()

@property (weak, nonatomic) IBOutlet UILabel *labelThird;
@property (weak, nonatomic) IBOutlet UILabel *labelLast;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdSpace;
@property (weak, nonatomic) IBOutlet UILabel *valueFirst;
@property (weak, nonatomic) IBOutlet UILabel *valueSecond;
@property (weak, nonatomic) IBOutlet UILabel *valueThird;
@property (weak, nonatomic) IBOutlet UILabel *valueFourth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelThirdHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelFourthHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelFirstHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelSecondHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdUpSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdDownSpace;

@end

@implementation UCFCalculateResultView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (self.calculateType) {
        case 1:
        case 2: {
            self.labelThirdHeight.constant = 16;
            self.thirdUpSpace.constant = 5;
            self.labelFourthHeight.constant = 0;
            self.thirdDownSpace.constant = 0;
        }
            break;
            
        case 3:
        case 5: {
            self.labelThirdHeight.constant = 0;
            self.labelFourthHeight.constant = 0;
            self.thirdDownSpace.constant = 0;
            self.thirdUpSpace.constant = 0;
        }
            break;
            
        case 4: {
            self.labelThirdHeight.constant = 16;
            self.labelFourthHeight.constant = 16;
            self.thirdDownSpace.constant = 5;
            self.thirdUpSpace.constant = 5;
        }
            break;
            
        default:
            break;
    }
}

- (void)setCalculateRes:(UCFProfitCalculateResult *)calculateRes
{
    _calculateRes = calculateRes;
    self.valueFirst.text = calculateRes.total.length > 0 ? [NSString stringWithFormat:@"¥%@", calculateRes.total] : @"¥0.00";
    self.valueSecond.text = calculateRes.interestTotal.length > 0 ? [NSString stringWithFormat:@"¥%@", calculateRes.interestTotal] : @"¥0.00";
    switch (self.calculateType) {
        case 1:
        case 2: {
            self.valueThird.text = calculateRes.interest.length > 0 ? [NSString stringWithFormat:@"¥%@", calculateRes.interest] : @"¥0.00";
        }
            break;
            
        case 4: {
            self.valueThird.text = calculateRes.interest.length > 0 ? [NSString stringWithFormat:@"¥%@", calculateRes.interest] : @"¥0.00";
            self.valueFourth.text = calculateRes.lastInterest.length > 0 ? [NSString stringWithFormat:@"¥%@", calculateRes.lastInterest] : @"¥0.00";
        }
            break;
            
        default:
            break;
    }

}

- (void)resetData
{
    self.valueFirst.text = @"";
    self.valueSecond.text = @"";
    self.valueThird.text = @"";
    self.valueFourth.text = @"";
}

@end
