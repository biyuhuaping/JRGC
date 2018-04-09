//
//  UCFMyInvestBatchCell.m
//  JRGC
//
//  Created by njw on 2017/2/20.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMyInvestBatchCell.h"
#import "UCFMyInvestBatchBidModel.h"

@interface UCFMyInvestBatchCell ()
@property (weak, nonatomic) IBOutlet UILabel *bidName;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidCycleLabel;
@property (weak, nonatomic) IBOutlet UILabel *preYearRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hasInvested;
@property (weak, nonatomic) IBOutlet UILabel *tradeDateLabel;

@end

@implementation UCFMyInvestBatchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 5;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setModel:(UCFMyInvestBatchBidModel *)model
{
    _model = model;
    self.bidName.text = [NSString stringWithFormat:@"%@", model.collName];
    NSInteger status = [model.status integerValue];
    switch (status) {
//            0、匹配中 1、匹配成功 2、匹配失败
        case 0:
            self.statusLabel.text = @"匹配中";
            break;
        case 1:
            self.statusLabel.text = @"";
            break;
        case 2:
            self.statusLabel.text = @"匹配失败";
            break;
//        case 3:
//            self.statusLabel.text = @"流标";
////            break;
//        case 4:
//            self.statusLabel.text = @"满标";
//            break;
//        case 5:
//            self.statusLabel.text = @"回款中";
//            break;
//        case 6:
//            self.statusLabel.text = @"已回款";
//            break;
    }
    self.bidCycleLabel.text = model.colPeriodTxt;
    self.preYearRateLabel.text = [NSString stringWithFormat:@"%@%%", model.collRate];
    if([model.investSuccessTotal floatValue] == 0){
       self.hasInvested.text  = @"--";
    }else{
       self.hasInvested.text = [NSString stringWithFormat:@"¥%.2f", [model.investSuccessTotal floatValue]];;
    }
    self.tradeDateLabel.text = model.investTime;
}

@end
