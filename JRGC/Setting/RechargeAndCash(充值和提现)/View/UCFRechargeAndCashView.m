//
//  UCFRechargeAndCashView.m
//  JRGC
//
//  Created by hanqiyuan on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFRechargeAndCashView.h"
@interface UCFRechargeAndCashView()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *upViewHight;


- (IBAction)clickRechargeOrCashBtn:(id)sender;


@end
@implementation UCFRechargeAndCashView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.upViewHight.constant =  [Common calculateNewSizeBaseMachine:30];
    }
    
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.upViewHight.constant =  [Common calculateNewSizeBaseMachine:30];
}
-(void)setAccoutCardModel:(UCFAccoutCardModel *)accoutCardModel
{
    _accoutCardModel = accoutCardModel;
    self.cardtitleLabel.text = accoutCardModel.cardTitleStr;
    self.cardLogoImage.image = [UIImage imageNamed:accoutCardModel.cardLogoImageName];
    self.cardDetialLabel.text = accoutCardModel.cardDetialStr;
    self.cardBgImageView.image = [UIImage imageNamed:accoutCardModel.cardBgImageName];
    self.cardStateLabel.text = accoutCardModel.cardStateStr;
    self.cardNumberLabel.text = accoutCardModel.cardNumberStr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)clickRechargeOrCashBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickRechargeAndCashView:WithTag:WithModel:)]) {
        [self.delegate clickRechargeAndCashView:self WithTag:self.tag WithModel:self.accoutCardModel];
    }
}
@end
