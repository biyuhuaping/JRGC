//
//  UCFProjectListCell.m
//  JRGC
//
//  Created by NJW on 2016/11/21.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFProjectListCell.h"
#import "CircleProgressView.h"
#import "UCFAngleView.h"
#import "UCFProjectListModel.h"
#import "UCFTransferModel.h"
#import "NZLabel.h"
#import "UCFToolsMehod.h"
#import "UCFProjectLabel.h"

@interface UCFProjectListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *invest_bg_cell;

@property (strong, nonatomic) IBOutlet UILabel *prdNameLab;     //债权名称
@property (strong, nonatomic) IBOutlet NZLabel *progressLab;    //进度百分比
@property (strong, nonatomic) IBOutlet UILabel *repayPeriodLab; //投资期限
@property (strong, nonatomic) IBOutlet UILabel *repayModeLab;   //还款方式
@property (strong, nonatomic) IBOutlet UILabel *minInvestLab;   //起投金额
@property (strong, nonatomic) IBOutlet UILabel *remainingLab;   //可投金额


@property (strong, nonatomic) IBOutlet UIImageView *imgView1;
@property (strong, nonatomic) IBOutlet UIImageView *imgView2;
@property (strong, nonatomic) IBOutlet UIImageView *imgView3;
@property (strong, nonatomic) IBOutlet UIImageView *imgView4;

@property (strong, nonatomic) IBOutlet UCFAngleView *angleView;
@property (weak, nonatomic) IBOutlet CircleProgressView *circleProgressView;

@property (nonatomic, strong) NSArray *status;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW_01;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW_02;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW_03;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW_04;

@end

@implementation UCFProjectListCell

- (NSArray *)status
{
    if (!_status) {
        _status = [[NSArray alloc] initWithObjects:@"未审核",@"等待确认",@"投资",@"流标",@"满标",@"回款中",@"已回款", nil];
    }
    return _status;
}

- (IBAction)buttonClicked:(UIButton *)sender {
    if (self.type == UCFProjectListCellTypeProject) {
        if ([self.delegate respondsToSelector:@selector(cell:clickInvestBtn:withModel:)]) {
            [self.delegate cell:self clickInvestBtn:sender withModel:self.model];
        }
    }
    else if (self.type == UCFProjectListCellTypeTransfer) {
        if ([self.delegate respondsToSelector:@selector(cell:clickInvestBtn1:withModel:)]) {
            [self.delegate cell:self clickInvestBtn1:sender withModel:self.transferModel];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.circleProgressView.layer.masksToBounds = YES;
    self.circleProgressView.layer.cornerRadius = CGRectGetHeight(self.circleProgressView.frame)*0.5;
    self.circleProgressView.exclusiveTouch = YES;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 5;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)animateCircle:(NSInteger)progress isAnim:(BOOL)isAnim{
    self.circleProgressView.status = NSLocalizedString(@"circle-progress-view.status-not-started", nil);
    self.circleProgressView.isAnim = isAnim;
    self.circleProgressView.timeLimit = 1000;//最大值
    self.circleProgressView.elapsedTime = 0;//时间限制
    
    self.circleProgressView.status = NSLocalizedString(@"circle-progress-view.status-in-progress", nil);
    self.circleProgressView.elapsedTime = progress;//最大值是500
    //    self.progressView.tintColor = [UIColor redColor];
    //    self.progressView.textStr = @"投资";
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

- (void)setModel:(UCFProjectListModel *)model
{
    _model = model;
    self.prdNameLab.text = model.prdName;//债权名称
    
    //贴 盾 固 灵
    NSMutableArray *imaArr = [NSMutableArray array];
    if (model.platformSubsidyExpense.intValue > 0) {//贴
        [imaArr addObject:[UIImage imageNamed:@"invest_icon_buletie"]];
    }
    if (model.guaranteeCompany.length > 0) {//盾
        [imaArr addObject:[UIImage imageNamed:@"particular_icon_guarantee_dark"]];
    }
    if (model.fixedDate.length > 0) {//固
        [imaArr addObject:[UIImage imageNamed:@"invest_icon_redgu-1"]];
    }
    if (model.holdTime.length > 0) {//灵
        _repayPeriodLab.text = [NSString stringWithFormat:@"%@~%@",model.holdTime,model.repayPeriodtext];//投资期限
        [imaArr addObject:[UIImage imageNamed:@"invest_icon_ling"]];
    }else{
        _repayPeriodLab.text = model.repayPeriodtext;//投资期限
    }

    
    self.progressLab.text = [NSString stringWithFormat:@"%@%%",model.annualRate];//年化收益率
    [self.progressLab setFont:[UIFont systemFontOfSize:13] string:@"%"];
    
    _minInvestLab.text = [NSString stringWithFormat:@"%@元起",model.minInvest];//起投金额
//
    NSString *temp = [NSString stringWithFormat:@"%lf",[model.borrowAmount doubleValue]-[model.completeLoan doubleValue]];
    
    _repayModeLab.text = [self moneywithRemaining:temp total:model.borrowAmount];//剩余比例
    _remainingLab.text = model.repayModeText;//还款方式

    switch (imaArr.count) {
        case 1: {
            _imgView1.image = imaArr[0];
            self.iconW_01.constant = 18;
            self.iconW_02.constant = 0;
            self.iconW_03.constant = 0;
            self.iconW_04.constant = 0;
        }
            break;
        case 2: {
            _imgView1.image = imaArr[0];
            _imgView2.image = imaArr[1];
            self.iconW_01.constant = 18;
            self.iconW_02.constant = 18;
            self.iconW_03.constant = 0;
            self.iconW_04.constant = 0;
        }
            break;
        case 3: {
            _imgView1.image = imaArr[0];
            _imgView2.image = imaArr[1];
            _imgView3.image = imaArr[2];
            self.iconW_01.constant = 18;
            self.iconW_02.constant = 18;
            self.iconW_03.constant = 18;
            self.iconW_04.constant = 0;
        }
            break;
        case 4: {
            _imgView1.image = imaArr[0];
            _imgView2.image = imaArr[1];
            _imgView3.image = imaArr[2];
            _imgView4.image = imaArr[3];
            self.iconW_01.constant = 18;
            self.iconW_02.constant = 18;
            self.iconW_03.constant = 18;
            self.iconW_04.constant = 18;
        }
            break;
    }

    NSInteger status = [model.status integerValue];
    if (_type == UCFProjectListCellTypeProject) {
        self.circleProgressView.textStr = [self.status objectAtIndex:status];
    }
    self.angleView.angleStatus = model.status;
    DBLOG(@"%@", model.status);
    if (model.prdLabelsList.count>0) {
        for (UCFProjectLabel *projectLabel in model.prdLabelsList) {
            if ([projectLabel.labelPriority integerValue] == 1) {
                self.angleView.angleString = [NSString stringWithFormat:@"%@", projectLabel.labelName];
            }
        }
    }
    
    
    float progress = [model.completeLoan floatValue]/[model.borrowAmount floatValue];
    progress = 1000*progress;
    
    if (progress > 0 && progress < 1) {
        progress = 1;
    }

    //控制进度视图显示
    if (status < 3) {
        self.circleProgressView.tintColor = UIColorWithRGB(0xfa4d4c);
        self.circleProgressView.progressLabel.textColor = UIColorWithRGB(0x555555);
        if (model.isAnim) {
            [self animateCircle:progress isAnim:YES];
            model.isAnim = NO;
        }else{
            [self animateCircle:progress isAnim:NO];
        }
    }else{
        self.circleProgressView.tintColor = UIColorWithRGB(0xe2e2e2);//未绘制的进度条颜色
        self.circleProgressView.progressLabel.textColor = UIColorWithRGB(0x909dae);
    }
    
    //设置字体大小
    if (status == 0 || status == 1 || status == 5 || status == 6) {
        self.circleProgressView.progressLabel.font = [UIFont systemFontOfSize:13];
    }
}


- (void)setTransferModel:(UCFTransferModel *)transferModel
{
    _transferModel = transferModel;
    _prdNameLab.text = transferModel.name;//转让标名称
    _progressLab.text = [NSString stringWithFormat:@"%@%%",transferModel.transfereeYearRate];//受让人年化收益
    _repayPeriodLab.text = [NSString stringWithFormat:@"%@天",transferModel.lastDays];//天数
    _repayModeLab.text = transferModel.repayModeText;//还款方式
    _minInvestLab.text = [NSString stringWithFormat:@"%@元起",transferModel.investAmt];//起投金额
    
    //    NSString *str = [[NSString getKilobitDecollator:[aItemInfo.cantranMoney doubleValue] withUnit:nil] stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    _remainingLab.text = [NSString stringWithFormat:@"可购%@元",[UCFToolsMehod AddComma:transferModel.cantranMoney]];//可投金额
    
    //盾
    if ([transferModel.guaranteeCompany isEqualToString:@"1"]) {
        _imgView1.image = [UIImage imageNamed:@"particular_icon_guarantee"];
        self.iconW_01.constant = 18;
        self.iconW_02.constant = self.iconW_03.constant = self.iconW_04.constant = 0;
    }
    else {
        self.iconW_01.constant = self.iconW_02.constant = self.iconW_03.constant = self.iconW_04.constant = 0;
    }
    
    NSInteger status = [transferModel.status integerValue];
    self.circleProgressView.textStr = status == 0?@"购买":@"已转完";
    
    float progress = [transferModel.completeRate floatValue];//[aItemInfo.realPrincipalAmt floatValue]/[aItemInfo.planPrincipalAmt floatValue];
    if (status == 0) {
        self.circleProgressView.tintColor = UIColorWithRGB(0xfa4d4c);
        if (transferModel.isAnim) {
            [self animateCircle:10*progress isAnim:YES];
            transferModel.isAnim = NO;
        }else{
            [self animateCircle:10*progress isAnim:NO];
        }
    }else{
        self.circleProgressView.tintColor = UIColorWithRGB(0xe2e2e2);//未绘制的进度条颜色
        self.circleProgressView.progressLabel.textColor = UIColorWithRGB(0x909dae);
        self.circleProgressView.progressLabel.font = [UIFont systemFontOfSize:13];
    }
}


@end
