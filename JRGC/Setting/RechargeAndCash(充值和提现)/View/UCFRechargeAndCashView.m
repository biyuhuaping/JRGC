//
//  UCFRechargeAndCashView.m
//  JRGC
//
//  Created by hanqiyuan on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFRechargeAndCashView.h"
#import "UIImageView+WebCache.h"
@interface UCFRechargeAndCashView()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *upViewHight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *upViewLabelLeft;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cardLogoBgHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cardLogoBgWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cardLogoImageHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cardLogoImageWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cardStateTriling;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *downCardLogoViewLeft;
- (IBAction)clickRechargeOrCashBtn:(id)sender;


@end
@implementation UCFRechargeAndCashView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.upViewLabelLeft.constant =  [Common calculateNewSizeBaseMachine:20];
    self.upViewHight.constant =  [Common calculateNewSizeBaseMachine:30];
    self.cardLogoBgWidth.constant = [Common calculateNewSizeBaseMachine:33];
    self.cardLogoBgHeight.constant = [Common calculateNewSizeBaseMachine:33];
    self.cardLogoImageHeight.constant = [Common calculateNewSizeBaseMachine:25];
    self.cardLogoImageWidth.constant = [Common calculateNewSizeBaseMachine:25];
    self.cardStateTriling.constant = [Common calculateNewSizeBaseMachine:55];
    self.downCardLogoViewLeft.constant =  [Common calculateNewSizeBaseMachine:20];
}
-(void)setAccoutCardModel:(UCFAccoutCardModel *)accoutCardModel
{
    _accoutCardModel = accoutCardModel;
    self.isRechargeOrCash = accoutCardModel.isRechargeOrCash;
    self.cardtitleLabel.text = accoutCardModel.cardTitleStr;
    
    if (accoutCardModel.isRechargeOrCash) {
      [self.cardLogoImage  sd_setImageWithURL:[NSURL URLWithString:accoutCardModel.cardLogoImageName] placeholderImage:[UIImage imageNamed:@"bank_default"]];
    }else{
      self.cardLogoImage.image = [UIImage imageNamed:accoutCardModel.cardLogoImageName];
    }
    self.cardDetialLabel.text = accoutCardModel.cardDetialStr;
    self.cardBgImageView.image = [UIImage imageNamed:accoutCardModel.cardBgImageName];
    self.cardStateLabel.text = accoutCardModel.cardStateStr;
    self.cardNumberLabel.text = accoutCardModel.cardNumberStr;
    self.accoutBalanceLabel.text = accoutCardModel.accoutBalanceStr;
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
