//
//  AssignmentCell.m
//  JRGC
//
//  Created by biyuhuaping on 15/12/23.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "AssignmentCell.h"
#import "NSString+FormatForThousand.h"
#import "UCFToolsMehod.h"
#import "UCFLatestProjectViewController.h"
#import "UCFAssignmentCreditorViewController.h"

@implementation AssignmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.progressView.layer.masksToBounds = YES;
    self.progressView.layer.cornerRadius = 35;
    _investButton.exclusiveTouch = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (IBAction)investmentClick:(id)sender {
    if ([self.delegate isKindOfClass:[UCFLatestProjectViewController class]]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(investBtnClicked:)] && [self.progressView.textStr isEqualToString:@"投资"]) {
            [self.delegate investBtnClicked:sender];
        }
    } else if ([self.delegate isKindOfClass:[UCFAssignmentCreditorViewController class]]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(investBtnClicked:)] && [self.progressView.textStr isEqualToString:@"购买"]) {
            [self.delegate investBtnClicked:sender];
        }
    }
}

- (void)animateCircle:(NSInteger)progress isAnim:(BOOL)isAnim{
    self.progressView.status = NSLocalizedString(@"circle-progress-view.status-not-started", nil);
    self.progressView.isAnim = isAnim;
    self.progressView.timeLimit = 1000;//最大值
    self.progressView.elapsedTime = 0;//时间限制
    
    self.progressView.status = NSLocalizedString(@"circle-progress-view.status-in-progress", nil);
    self.progressView.elapsedTime = progress;//最大值是500
//    self.progressView.tintColor = [UIColor redColor];
//    self.progressView.textStr = @"投资";
}

//设置债权转让cell数据
- (void)setTransterInfo:(UCFTransterBid *)aItemInfo{
    _prdNameLab.text = aItemInfo.name;//转让标名称
    _progressLab.text = [NSString stringWithFormat:@"%@%%",aItemInfo.transfereeYearRate];//受让人年化收益
    _repayPeriodLab.text = [NSString stringWithFormat:@"%@天",aItemInfo.lastDays];//天数
    _repayModeLab.text = aItemInfo.repayModeText;//还款方式
    _minInvestLab.text = [NSString stringWithFormat:@"%@元起",aItemInfo.investAmt];//起投金额
    
//    NSString *str = [[NSString getKilobitDecollator:[aItemInfo.cantranMoney doubleValue] withUnit:nil] stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    _remainingLab.text = [NSString stringWithFormat:@"可购%@元",[UCFToolsMehod AddComma:aItemInfo.cantranMoney]];//可投金额
    
    //盾
    if ([aItemInfo.guaranteeCompany isEqualToString:@"1"]) {
        _imgView1.image = [UIImage imageNamed:@"particular_icon_guarantee"];
    }
    
    NSInteger status = [aItemInfo.status integerValue];
    self.progressView.textStr = status == 0?@"购买":@"已转完";
    
    float progress = [aItemInfo.completeRate floatValue];//[aItemInfo.realPrincipalAmt floatValue]/[aItemInfo.planPrincipalAmt floatValue];
    if (status == 0) {
        self.progressView.tintColor = UIColorWithRGB(0xfa4d4c);
        if (aItemInfo.isAnim) {
            [self animateCircle:10*progress isAnim:YES];
            aItemInfo.isAnim = NO;
        }else{
            [self animateCircle:10*progress isAnim:NO];
        }
    }else{
        self.progressView.tintColor = UIColorWithRGB(0xe2e2e2);//未绘制的进度条颜色
        self.progressView.progressLabel.textColor = UIColorWithRGB(0x909dae);
        self.progressView.progressLabel.font = [UIFont systemFontOfSize:13];
    }
}

- (NSString *)moneywithRemaining:(id)rem total:(id)total{
    NSInteger rem1 = [rem integerValue]*0.0001;
    double rem2 = [rem doubleValue]*0.0001;
    
    NSInteger total1 = [total integerValue]*0.0001;
    double total2 = [total doubleValue]*0.0001;
    
    NSString *str1 = @"";
    NSString *str2 = @"";
    
    if (rem1 == rem2) {
        str1 = [NSString stringWithFormat:@"%.f万",rem2];
    }else
        str1 = [NSString stringWithFormat:@"%.2f万",rem2];
    
    if (total1 == total2) {
        str2 = [NSString stringWithFormat:@"%.f万",total2];
    }else
        str2 = [NSString stringWithFormat:@"%.2f万",total2];
    
    return [NSString stringWithFormat:@"剩%@/%@",str1,str2];
}

@end
