//
//  InvestmentCell.m
//  JRGC
//
//  Created by biyuhuaping on 15/4/14.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "InvestmentCell.h"
#import "NSString+FormatForThousand.h"
#import "UCFToolsMehod.h"
#import "UCFLatestProjectViewController.h"

@implementation InvestmentCell

- (void)awakeFromNib{
    self.progressView.layer.masksToBounds = YES;
    self.progressView.layer.cornerRadius = 35;
    _investButton.exclusiveTouch = YES;
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (IBAction)investmentClick:(id)sender {
    if ([self.delegate isKindOfClass:[UCFLatestProjectViewController class]]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(investBtnClicked:withType:)] && ([self.progressView.textStr isEqualToString:@"投资"] || [self.progressView.textStr isEqualToString:@"认购"])) {
            [self.delegate investBtnClicked:sender withType:self.progressView.textStr];
        }
    } 

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)animateCircle:(NSInteger)progress isAnim:(BOOL)isAnim{
    self.progressView.status = NSLocalizedString(@"circle-progress-view.status-not-started", nil);
    self.progressView.isAnim = isAnim;
    self.progressView.timeLimit = 1000;//最大值
    self.progressView.elapsedTime = 0;//时间限制
    
    self.progressView.status = NSLocalizedString(@"circle-progress-view.status-in-progress", nil);
    self.progressView.elapsedTime = progress;
//    self.progressView.tintColor = [UIColor redColor];
//    self.progressView.textStr = @"投资";
}


//设置最新项目cell数据
- (void)setItemInfo:(InvestmentItemInfo *)aItemInfo{
    _prdNameLab.text = aItemInfo.prdName;//债权名称
    _progressLab.text = [NSString stringWithFormat:@"%@%%",aItemInfo.annualRate];//年化收益率
    [_progressLab setFont:[UIFont systemFontOfSize:13] string:@"%"];
    
    _repayModeLab.text = aItemInfo.repayModeText;//还款方式
    _minInvestLab.text = [NSString stringWithFormat:@"%@元起",aItemInfo.minInvest];//起投金额
    
    NSString *temp = [NSString stringWithFormat:@"%lf",[aItemInfo.borrowAmount doubleValue]-[aItemInfo.completeLoan doubleValue]];
    _remainingLab.text = [self moneywithRemaining:temp total:aItemInfo.borrowAmount];//剩余比例
    
    //贴 盾 固 灵
    NSMutableArray *imaArr = [NSMutableArray array];
    if (aItemInfo.platformSubsidyExpense.length > 0) {//贴
        [imaArr addObject:[UIImage imageNamed:@"invest_icon_buletie"]];
    }
    if (aItemInfo.guaranteeCompany.length > 0) {//盾
        [imaArr addObject:[UIImage imageNamed:@"particular_icon_guarantee_dark"]];
    }
    if (aItemInfo.fixedDate.length > 0) {//固
        [imaArr addObject:[UIImage imageNamed:@"invest_icon_redgu-1"]];
    }
    if (aItemInfo.holdTime.length > 0) {//灵
        _repayPeriodLab.text = [NSString stringWithFormat:@"%@~%@",aItemInfo.holdTime,aItemInfo.repayPeriodtext];//投资期限
        [imaArr addObject:[UIImage imageNamed:@"invest_icon_ling"]];
    }else{
        _repayPeriodLab.text = aItemInfo.repayPeriodtext;//投资期限
    }
    
    switch (imaArr.count) {
        case 1: {
            _imgView1.image = imaArr[0];
        }
            break;
        case 2: {
            _imgView1.image = imaArr[0];
            _imgView2.image = imaArr[1];
        }
            break;
        case 3: {
            _imgView1.image = imaArr[0];
            _imgView2.image = imaArr[1];
            _imgView3.image = imaArr[2];
        }
            break;
        case 4: {
            _imgView1.image = imaArr[0];
            _imgView2.image = imaArr[1];
            _imgView3.image = imaArr[2];
            _imgView4.image = imaArr[3];
        }
            break;
    }
    
    
//    NSArray *statusArr = @[@"投资",@"满标",@"还款中",@"已还清"];//app端只有这几个状态
    NSArray *statusArr = @[@"未审核",@"等待确认",@"投资",@"流标",@"满标",@"回款中",@"已回款"];
    NSInteger status = [aItemInfo.status integerValue];
    if ([aItemInfo.type isEqualToString:@"2"] && status == 2) {
        self.progressView.textStr = @"认购";
    }
    else
        self.progressView.textStr = statusArr[status];
    self.angleView.angleStatus = aItemInfo.status;

    float progress = [aItemInfo.completeLoan floatValue]/[aItemInfo.borrowAmount floatValue];
    progress = 1000*progress;
    if (progress > 0 && progress < 1) {
        progress = 1;
    }
    //控制进度视图显示
    if (status < 3) {
        self.progressView.tintColor = UIColorWithRGB(0xfa4d4c);
        self.progressView.progressLabel.textColor = UIColorWithRGB(0x555555);
        if (aItemInfo.isAnim) {
            [self animateCircle:progress isAnim:YES];
            aItemInfo.isAnim = NO;
        }else{
            [self animateCircle:progress isAnim:NO];
        }
    }else{
        self.progressView.tintColor = UIColorWithRGB(0xe2e2e2);//未绘制的进度条颜色
        self.progressView.progressLabel.textColor = UIColorWithRGB(0x909dae);
    }
    
    //设置字体大小
    if (status == 0 || status == 1 || status == 5 || status == 6) {
        self.progressView.progressLabel.font = [UIFont systemFontOfSize:13];
    }
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

//最新投标页表头
- (void)setBidItemInfo:(InvestmentItemInfo *)aItemInfo{
    _prdNameLab.text = aItemInfo.prdName;//债权名称
    _progressLab.text = [NSString stringWithFormat:@"%@%%",aItemInfo.annualRate];//年化收益率
    [_progressLab setFont:[UIFont systemFontOfSize:13] string:@"%"];
    
    _repayModeLab.text = aItemInfo.repayModeText;//还款方式
    _minInvestLab.text = [NSString stringWithFormat:@"%@元起",aItemInfo.minInvest];//起投金额
    
    NSString *temp = [NSString stringWithFormat:@"%lf",[aItemInfo.borrowAmount doubleValue]-[aItemInfo.completeLoan doubleValue]];
    _remainingLab.text = [self moneywithRemaining:temp total:aItemInfo.borrowAmount];//剩余比例
    
    //贴 盾 固
    NSMutableArray *imaArr = [NSMutableArray array];
    if (aItemInfo.platformSubsidyExpense.length > 0) {//贴
        [imaArr addObject:[UIImage imageNamed:@"invest_icon_buletie"]];
    }
    if (aItemInfo.guaranteeCompany.length > 0) {//盾
        [imaArr addObject:[UIImage imageNamed:@"particular_icon_guarantee_dark"]];
    }
    if (aItemInfo.fixedDate.length > 0) {//固
        [imaArr addObject:[UIImage imageNamed:@"invest_icon_redgu-1"]];
    }
    if (aItemInfo.holdTime.length > 0) {//灵
        _repayPeriodLab.text = [NSString stringWithFormat:@"%@~%@",aItemInfo.holdTime,aItemInfo.repayPeriodtext];//投资期限
        [imaArr addObject:[UIImage imageNamed:@"invest_icon_ling"]];
    }else{
        _repayPeriodLab.text = aItemInfo.repayPeriodtext;//投资期限
    }
    
    switch (imaArr.count) {
        case 1: {
            _imgView1.image = imaArr[0];
        }
            break;
        case 2: {
            _imgView1.image = imaArr[0];
            _imgView2.image = imaArr[1];
        }
            break;
        case 3: {
            _imgView1.image = imaArr[0];
            _imgView2.image = imaArr[1];
            _imgView3.image = imaArr[2];
        }
            break;
        case 4: {
            _imgView1.image = imaArr[0];
            _imgView2.image = imaArr[1];
            _imgView3.image = imaArr[2];
            _imgView4.image = imaArr[3];
        }
            break;
    }
    CGFloat temp2 = 100 * ([aItemInfo.completeLoan doubleValue]/[aItemInfo.borrowAmount doubleValue]);
    int temp1 = (int)(temp2);
    if (temp1 == 0) {
        temp1 = 1;
    }
    if ([aItemInfo.completeLoan doubleValue] < [aItemInfo.minInvest doubleValue]) {
        temp1 = 0;
    }
    self.angleView.angleStatus = @"2";
    self.progressView.textStr = [NSString stringWithFormat:@"%d%%",temp1];
    
    float progress = [aItemInfo.completeLoan floatValue]/[aItemInfo.borrowAmount floatValue];
    progress = 1000*progress;
    if (progress > 0 && progress < 1) {
        progress = 1;
    }
    NSInteger status = [aItemInfo.status integerValue];
    //控制进度视图显示
    if (status < 3) {
        self.progressView.tintColor = UIColorWithRGB(0xfa4d4c);
        self.progressView.progressLabel.textColor = UIColorWithRGB(0x333333);
        self.progressView.progressLabel.font = [UIFont systemFontOfSize:14.0f];
        [self animateCircle:progress isAnim:NO];
    }else {
        self.progressView.tintColor = UIColorWithRGB(0xcfd5d7);
    }
}

// 投资页普通表头
- (void)setInvestItemInfo:(InvestmentItemInfo *)aItemInfo{
    _investButton.userInteractionEnabled = NO;
    _prdNameLab.text = aItemInfo.prdName;//债权名称
    _prdNameLab.textColor = UIColorWithRGB(0x333333);
    _prdNameLab.font = [UIFont systemFontOfSize:14.0];
    _progressLab.text = [NSString stringWithFormat:@"%@%%",aItemInfo.annualRate];//年化收益率
    [_progressLab setFont:[UIFont systemFontOfSize:13] string:@"%"];


    if (aItemInfo.holdTime.length > 0) {
        _repayPeriodLab.text = [NSString stringWithFormat:@"%@~%@",aItemInfo.holdTime,aItemInfo.repayPeriodtext];//投资期限
    }else{
        _repayPeriodLab.text = aItemInfo.repayPeriodtext;//投资期限
    }
    //还款方式
    _repayModeLab.text = aItemInfo.repayModeText;

    _minInvestLab.text = [NSString stringWithFormat:@"%@元起",aItemInfo.minInvest];//起投金额
    NSString *remainStr = [NSString stringWithFormat:@"%.2f",[aItemInfo.borrowAmount doubleValue] - [aItemInfo.completeLoan doubleValue]];
    remainStr = [UCFToolsMehod AddComma:remainStr];
    _remainingLab.text = [NSString stringWithFormat:@"剩¥%@",remainStr];//剩余钱数
    //贴 盾 固
    NSMutableArray *imaArr = [NSMutableArray array];
    if (aItemInfo.platformSubsidyExpense.length > 0) {//贴
        [imaArr addObject:[UIImage imageNamed:@"invest_icon_buletie"]];
    }
    if (aItemInfo.guaranteeCompany.length > 0) {//盾
        [imaArr addObject:[UIImage imageNamed:@"particular_icon_guarantee_dark"]];
    }
    if (aItemInfo.fixedDate.length > 0) {//固
        [imaArr addObject:[UIImage imageNamed:@"invest_icon_redgu-1"]];
    }
    if (aItemInfo.holdTime.length > 0) {//灵
        _repayPeriodLab.text = [NSString stringWithFormat:@"%@~%@",aItemInfo.holdTime,aItemInfo.repayPeriodtext];//投资期限
        [imaArr addObject:[UIImage imageNamed:@"invest_icon_ling"]];
    }else{
        _repayPeriodLab.text = aItemInfo.repayPeriodtext;//投资期限
    }

    
    switch (imaArr.count) {
        case 1: {
            _imgView1.image = imaArr[0];
        }
            break;
        case 2: {
            _imgView1.image = imaArr[0];
            _imgView2.image = imaArr[1];
        }
            break;
        case 3: {
            _imgView1.image = imaArr[0];
            _imgView2.image = imaArr[1];
            _imgView3.image = imaArr[2];
        }
            break;
        case 4: {
            _imgView1.image = imaArr[0];
            _imgView2.image = imaArr[1];
            _imgView3.image = imaArr[2];
            _imgView4.image = imaArr[3];
        }
            break;
    }
    CGFloat temp = 100 * ([aItemInfo.completeLoan doubleValue]/[aItemInfo.borrowAmount doubleValue]);
    int temp1 = (int)(temp);
    if (temp1 == 0) {
        temp1 = 1;
    }
    if ([aItemInfo.completeLoan doubleValue] < [aItemInfo.minInvest doubleValue]) {
        temp1 = 0;
    }
    self.angleView.angleStatus = @"2";
    self.progressView.textStr = [NSString stringWithFormat:@"%d%%",temp1];
    
    float progress = [aItemInfo.completeLoan floatValue]/[aItemInfo.borrowAmount floatValue];
    progress = 1000*progress;
    if (progress > 0 && progress < 1) {
        progress = 1;
    }
    NSInteger status = [aItemInfo.status integerValue];
    //控制进度视图显示
    if (status < 3) {
        self.progressView.tintColor = UIColorWithRGB(0xfa4d4c);
        self.progressView.progressLabel.textColor = UIColorWithRGB(0x333333);
        self.progressView.progressLabel.font = [UIFont systemFontOfSize:14.0f];
        [self animateCircle:progress isAnim:NO];
    }else {
        self.progressView.tintColor = UIColorWithRGB(0xcfd5d7);
    }
}

// 债权转让投资页普通表头
- (void)setTransInvestItemInfo:(NSDictionary *)aItemInfo{
    _investButton.userInteractionEnabled = NO;
    _prdNameLab.textColor = UIColorWithRGB(0x333333);
    _prdNameLab.font = [UIFont systemFontOfSize:14.0];
    _prdNameLab.text = [aItemInfo objectForKey:@"name"];
    _progressLab.text = [NSString stringWithFormat:@"%@%%",[aItemInfo objectForKey:@"transfereeYearRate"]];//年化收益率
//    _progressLab.textColor = UIColorWithRGB(0x333333);
//    _progressLab.font = [UIFont systemFontOfSize:13.0f];
    
    NSString *lastDays = [aItemInfo objectForKey:@"lastDays"];
    _repayPeriodLab.text = [NSString stringWithFormat:@"%@天",lastDays];//投资期限
    _repayModeLab.text = [aItemInfo objectForKey:@"repayModeText"];
    
    NSString *minInvest = [NSString stringWithFormat:@"%@",[aItemInfo objectForKey:@"investAmt"]];
    _minInvestLab.text = [NSString stringWithFormat:@"%@元起",minInvest];//起投金额
//    NSString *planPrincipalAmt = [aItemInfo objectForKey:@"planPrincipalAmt"];
//    NSString *realPrincipalAmt = [aItemInfo objectForKey:@"realPrincipalAmt"];
    
    NSString *keTouStr = [aItemInfo objectForKey:@"cantranMoney"];
    _remainingLab.text = [NSString stringWithFormat:@"可购¥%@",[UCFToolsMehod AddComma:keTouStr]];//剩余比例
    
    self.progressView.textStr  = [NSString stringWithFormat:@"%0.f%%",[[aItemInfo objectForKey:@"completeRate"] doubleValue]];
//    float progress = ([realPrincipalAmt doubleValue]/[planPrincipalAmt doubleValue]);
     float progress = ([[aItemInfo objectForKey:@"completeRate"] doubleValue]/100.0f);
    progress = 1000*progress;
    if (progress > 0 && progress < 1) {
        progress = 1;
    }
    //控制进度视图显示
    self.progressView.tintColor = UIColorWithRGB(0xfa4d4c);
    self.progressView.progressLabel.textColor = UIColorWithRGB(0x333333);
    [self animateCircle:progress isAnim:NO];
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

//    return [NSString stringWithFormat:@"剩%@/%@",str1,str2];
    //标未满的时候显示剩余 //满标的时候，显示总额
    if (rem2 == 0) {
        return [NSString stringWithFormat:@"%@",str2];
    }
    return [NSString stringWithFormat:@"剩%@",str1];
}
- (void)setCollectionKeyBidInvestItemInfo:(NSDictionary *)aItemInfo{
    
    _investButton.userInteractionEnabled = NO;
    _prdNameLab.text =  [aItemInfo objectSafeForKey:@"colName"] ;//名称
    _prdNameLab.textColor = UIColorWithRGB(0x333333);
    _prdNameLab.font = [UIFont systemFontOfSize:14.0];
    _progressLab.text = [NSString stringWithFormat:@"%@%%",[aItemInfo objectSafeForKey:@"colRate"]];//年化收益率
    [_progressLab setFont:[UIFont systemFontOfSize:13] string:@"%"];
    
    
    _repayPeriodLab.text = [aItemInfo objectSafeForKey:@"colPeriodTxt"];//投资期限
    //还款方式
    _repayModeLab.text = [aItemInfo objectSafeForKey:@"colRepayModeTxt"];
    
    _minInvestLab.text = [NSString stringWithFormat:@"%@元起",[aItemInfo objectSafeForKey:@"colMinInvest"]];//起投金额
    
    //可投金额
    NSString *remainStr = [NSString stringWithFormat:@"%.2f",[[aItemInfo objectSafeForKey:@"canBuyAmt"] doubleValue] ];
    _remainingLab.text = [NSString stringWithFormat:@"剩¥%@",[UCFToolsMehod AddComma:remainStr]];//剩余钱数
    
    //总金额
    NSString *totalAmtStr =[NSString stringWithFormat:@"%.2f",[[aItemInfo objectSafeForKey:@"totalAmt"] doubleValue]];
    
    CGFloat temp = 100 * (([totalAmtStr  doubleValue] - [remainStr doubleValue] )/[totalAmtStr doubleValue]);
    int temp1 = (int)(temp);
    if (temp1 == 0) {
        temp1 = 1;
    }
    self.angleView.angleStatus = @"2";
    self.progressView.textStr = [NSString stringWithFormat:@"%d%%",temp1];
    
    float progress = ([totalAmtStr  doubleValue] - [remainStr doubleValue] )/[totalAmtStr doubleValue];
    progress = 1000*progress;
    if (progress > 0 && progress < 1) {
        progress = 1;
    }
    NSInteger status = 2;
    //控制进度视图显示
    if (status < 3) {
        self.progressView.tintColor = UIColorWithRGB(0xfa4d4c);
        self.progressView.progressLabel.textColor = UIColorWithRGB(0x333333);
        self.progressView.progressLabel.font = [UIFont systemFontOfSize:14.0f];
        [self animateCircle:progress isAnim:NO];
    }else {
        self.progressView.tintColor = UIColorWithRGB(0xcfd5d7);
    }

    
    
}

@end
