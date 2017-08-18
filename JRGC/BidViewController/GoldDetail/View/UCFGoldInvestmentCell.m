//
//  UCFGoldInvestmentCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldInvestmentCell.h"
#import "ToolSingleTon.h"
#import "UILabel+Misc.h"
@implementation UCFGoldInvestmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


// 投资页普通表头
- (void)setGoldInvestItemInfo:(UCFGoldModel *)aItemInfo
{
    
   
    
    self.realGoldPriceLab.text = [NSString stringWithFormat:@"实时金价(元/克)%.3f",[ToolSingleTon sharedManager].readTimePrice]; //
    
    self.GoldInvestButton.userInteractionEnabled = NO;
    self.nmPrdClaimNameLab.text = aItemInfo.nmPrdClaimName;//债权名称
    self.nmPrdClaimNameLab.textAlignment = NSTextAlignmentLeft;
    self.nmPrdClaimNameLab.textColor = UIColorWithRGB(0x333333);
    self.nmPrdClaimNameLab.font = [UIFont systemFontOfSize:14.0];
    
     self.annualRateLab.textColor = UIColorWithRGB(0xfc8f0e);
     self.annualRateLab.font = [UIFont boldSystemFontOfSize:15.0];
     self.annualRateLab.text = [NSString stringWithFormat:@"%@克/100克",aItemInfo.annualRate];//年化收益率
    [self.annualRateLab setFont:[UIFont boldSystemFontOfSize:10] string:@"克/100克"];
    self.remainAmountLab.text = [NSString stringWithFormat:@"可购%@克",aItemInfo.remainAmount];
    self.periodTermLab.text =  [NSString stringWithFormat:@"%@",aItemInfo.periodTerm];//投资天数
    CGFloat temp = 100 * (1 - [aItemInfo.remainAmount doubleValue]/[aItemInfo.totalAmount doubleValue]);
    int temp1 =  (int)(temp);
    if (temp1 == 0) {
        temp1 = 1;
    }
    if ([aItemInfo.totalAmount doubleValue] - [aItemInfo.remainAmount doubleValue]  < [aItemInfo.minPurchaseAmount doubleValue]) {
        temp1 = 0;
    }
    self.angleGoldView.angleStatus = @"2";
    self.progressGoldView.textStr = [NSString stringWithFormat:@"%d%%",temp1];
    
    float progress = 1 - [aItemInfo.remainAmount doubleValue]/[aItemInfo.totalAmount doubleValue];
    progress = 1000*progress;
    if (progress > 0 && progress < 1) {
        progress = 1;
    }
    NSInteger status = [aItemInfo.status integerValue];
    //控制进度视图显示
    if (status < 3) {
        self.progressGoldView.tintColor = UIColorWithRGB(0xffc027);
        self.progressGoldView.progressLabel.textColor = UIColorWithRGB(0x333333);
        self.progressGoldView.progressLabel.font = [UIFont systemFontOfSize:14.0f];
        [self animateCircle:progress isAnim:NO];
    }else {
        self.progressGoldView.tintColor = UIColorWithRGB(0xcfd5d7);
    }
    [self layoutSubviews];
}
- (void)animateCircle:(NSInteger)progress isAnim:(BOOL)isAnim{
    self.progressGoldView.status = NSLocalizedString(@"circle-progress-view.status-not-started", nil);
    self.progressGoldView.isAnim = isAnim;
    self.progressGoldView.timeLimit = 1000;//最大值
    self.progressGoldView.elapsedTime = 0;//时间限制
    
    self.progressGoldView.status = NSLocalizedString(@"circle-progress-view.status-in-progress", nil);
    self.progressGoldView.elapsedTime = progress;
    //    self.progressView.tintColor = [UIColor redColor];
    //    self.progressView.textStr = @"投资";
}
@end


@implementation UCFGoldCurrrntInvestmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


// 投资页普通表头
- (void)setGoldInvestItemInfo:(UCFGoldModel *)aItemInfo
{
    self.realGoldPriceLab.text = [NSString stringWithFormat:@"%.3lf元/克",[ToolSingleTon sharedManager].readTimePrice];
    [self.realGoldPriceLab setFont:[UIFont boldSystemFontOfSize:12] string:@"元/克"];
    self.nmPrdClaimNameLab.text = aItemInfo.nmPrdClaimName;//债权名称
    self.nmPrdClaimNameLab.textAlignment = NSTextAlignmentLeft;
    self.nmPrdClaimNameLab.textColor = UIColorWithRGB(0x333333);
    self.nmPrdClaimNameLab.font = [UIFont systemFontOfSize:14.0];
    
    self.annualRateLab.textColor = UIColorWithRGB(0x555555);
    self.annualRateLab.font = [UIFont systemFontOfSize:18.0];
    self.annualRateLab.text = [NSString stringWithFormat:@"%@%%",aItemInfo.annualRate];//年化收益率
    [self.annualRateLab setFont:[UIFont systemFontOfSize:12] string:@"%"];
    self.angleGoldView.angleStatus = @"2";

}
@end
