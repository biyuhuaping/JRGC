//
//  UCFHomeListCell.m
//  JRGC
//
//  Created by njw on 2017/5/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListCell.h"
#import "ZZCircleProgress.h"
#import "NZLabel.h"
#import "UCFProjectLabel.h"
#import "UCFMicroMoneyModel.h"
#import "UCFAngleView.h"
#import "UCFGoldModel.h"

@interface UCFHomeListCell ()
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView4;
@property (weak, nonatomic) IBOutlet ZZCircleProgress *circleProgressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image1W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image2W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image3W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image4W;
@property (weak, nonatomic) IBOutlet NZLabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *repayModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *startMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainLabel;
@property (weak, nonatomic) IBOutlet UIView *proSignBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proSignBackViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *proSignLabel;

@property (weak, nonatomic) IBOutlet UIView *upSegLine;
@property (weak, nonatomic) IBOutlet UIView *downSegLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *annurateLabelW;

@end

@implementation UCFHomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rateLabel.textColor = UIColorWithRGB(0xfd4d4c);
    self.proName.textColor = UIColorWithRGB(0x555555);
    self.timeLabel.textColor = UIColorWithRGB(0x555555);
    self.repayModelLabel.textColor = UIColorWithRGB(0x555555);
    self.startMoneyLabel.textColor = UIColorWithRGB(0x999999);
    self.remainLabel.textColor = UIColorWithRGB(0x999999);
    self.circleProgressView.animationModel = CircleIncreaseSameTime;
    self.circleProgressView.showProgressText = YES;
    self.circleProgressView.notAnimated = NO;
    self.circleProgressView.startAngle = -90;
    self.circleProgressView.pathBackColor = UIColorWithRGB(0xcfd5d7);
    self.circleProgressView.pathFillColor = UIColorWithRGB(0xfa4d4c);
    self.circleProgressView.strokeWidth = 3;
}

- (void)setPresenter:(UCFHomeListCellPresenter *)presenter
{
    _presenter = presenter;
    if (presenter.modelType == UCFHomeListCellModelTypeDefault
        ) {
        self.proName.text = presenter.proTitle;
        self.rateLabel.text = presenter.annualRate;
        if ([presenter.item.type isEqualToString:@"3"]) {
            self.rateLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        else {
            self.rateLabel.font = [UIFont boldSystemFontOfSize:20];
        }
        self.timeLabel.text = presenter.repayPeriodtext;
        self.repayModelLabel.text = presenter.repayModeText;
        self.remainLabel.text = presenter.availBorrowAmount;
        if (presenter.platformSubsidyExpense.length > 0) {//贴
            self.image1W.constant = 18;
            self.proImageView1.image = [UIImage imageNamed:@"invest_icon_buletie"];
        }
        else {
            self.image1W.constant = 0;
        }
        if (presenter.guaranteeCompany.length > 0) {//贴
            self.image2W.constant = 18;
            self.proImageView2.image = [UIImage imageNamed:@"particular_icon_guarantee_dark"];
        }
        else {
            self.image2W.constant = 0;
        }
        if (presenter.fixedDate.length > 0) {//贴
            self.image3W.constant = 18;
            self.proImageView3.image = [UIImage imageNamed:@"invest_icon_redgu-1"];
        }
        else {
            self.image3W.constant = 0;
        }
        if (presenter.holdTime.length > 0) {//贴
            self.image4W.constant = 18;
            self.proImageView4.image = [UIImage imageNamed:@"invest_icon_ling"];
        }
        else {
            self.image4W.constant = 0;
        }
        float progress;
        if ([presenter.item.type isEqualToString:@"3"]) {
            progress = 1 - [presenter.item.remainAmount floatValue]/[presenter.item.borrowAmount floatValue];
            if (progress < 0 || progress > 1) {
                progress = 1;
            }
            else
                self.circleProgressView.progress = progress;
        }
        else {
            progress = [presenter.item.completeLoan floatValue]/[presenter.item.borrowAmount floatValue];
            if (progress < 0 || progress > 1) {
                progress = 1;
            }
            else
                self.circleProgressView.progress = progress;
        }
        NSInteger status = [presenter.item.status integerValue];
    
        DBLOG(@"type : %@", presenter.item.type);
        if([presenter.item.type isEqualToString:@"3"])
        {
            if (status == 1) {
                self.circleProgressView.pathFillColor = UIColorWithRGB(0xffc027);
                //            self.progressView.progressLabel.textColor = UIColorWithRGB(0x555555);
            }else{
                self.circleProgressView.pathFillColor = UIColorWithRGB(0xe2e2e2);//未绘制的进度条颜色
                //            self.progressView.progressLabel.textColor = UIColorWithRGB(0x909dae);
            }
            self.startMoneyLabel.text = @"年化收益克重";
        }
        else{
            //控制进度视图显示
            if (status < 3) {
                self.circleProgressView.pathFillColor = UIColorWithRGB(0xfa4d4c);
                //            self.progressView.progressLabel.textColor = UIColorWithRGB(0x555555);
            }else{
                self.circleProgressView.pathFillColor = UIColorWithRGB(0xe2e2e2);//未绘制的进度条颜色
                //            self.progressView.progressLabel.textColor = UIColorWithRGB(0x909dae);
            }
            self.startMoneyLabel.text = presenter.minInvest;
        }
        NSArray *statusArr = @[@"未审核",@"等待确认",@"出借",@"流标",@"满标",@"回款中",@"已回款"];
        if ([presenter.item.type isEqualToString:@"3"]) {
            if (status == 21) {
                self.circleProgressView.progressText = @"暂停交易";
                self.circleProgressView.textColor = UIColorWithRGB(0x909dae);
                self.circleProgressView.pathFillColor = UIColorWithRGB(0xe2e2e2);
            }
            else if (status==2) {
                self.circleProgressView.progressText = @"已售罄";
                self.circleProgressView.textColor = UIColorWithRGB(0x909dae);
                self.circleProgressView.pathFillColor = UIColorWithRGB(0xe2e2e2);
            }
            else {
                self.circleProgressView.textColor = UIColorWithRGB(0x555555);
                self.circleProgressView.progressText = @"购买";
                self.circleProgressView.pathFillColor = UIColorWithRGB(0xfc8f0e);
            }
        }
        else {
            if (status>2) {
                self.circleProgressView.progressText = @"已售罄";
                self.circleProgressView.textColor = UIColorWithRGB(0x909dae);
            }
            else {
                self.circleProgressView.textColor = UIColorWithRGB(0x555555);
                if ([presenter.item.type isEqualToString:@"14"] && status == 2) {
                    self.circleProgressView.progressText = @"批量出借";
                }
                else
                {
                    if (([presenter.item.type isEqualToString:@"2"] || [presenter.item.type isEqualToString:@"3"] || [presenter.item.type isEqualToString:@"4"]) && status == 2) {
                        self.circleProgressView.progressText = @"认购";
                    }
                    else
                        self.circleProgressView.progressText = statusArr[status];
                }
            }
        }
        
        
        
//        self.angleView.angleStatus = presenter.item.status;
////        DBLOG(@"%@", model.status);
//        if (presenter.item.prdLabelsList.count>0) {
//            UCFProjectLabel *projectLabel = [presenter.item.prdLabelsList firstObject];
//            if ([projectLabel.labelPriority integerValue] == 1) {
//                self.angleView.angleString = [NSString stringWithFormat:@"%@", projectLabel.labelName];
//            }
//        }
        
        if (presenter.item.prdLabelsList.count > 0) {
            UCFProjectLabel *projectLabel = [presenter.item.prdLabelsList firstObject];
            if ([projectLabel.labelPriority integerValue] == 1) {
                self.proSignBackView.hidden = NO;
                self.proSignLabel.text = [NSString stringWithFormat:@"%@", projectLabel.labelName];
                CGSize size = [projectLabel.labelName boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0f]} context:nil].size;
                self.proSignBackViewWidth.constant = size.width + 11;
            }
            else {
                self.proSignBackView.hidden = YES;
                self.proSignBackViewWidth.constant = 0;
            }
        }
        else {
            self.proSignBackView.hidden = YES;
            self.proSignBackViewWidth.constant = 0;
        }
    }
}

- (IBAction)cyclePressClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homelistCell:didClickedProgressViewWithPresenter:)]) {
        [self.delegate homelistCell:self didClickedProgressViewWithPresenter:self.presenter.item];
    }
    else if ([self.honorDelegate respondsToSelector:@selector(homelistCell:didClickedProgressViewAtIndexPath:)]) {
        [self.honorDelegate homelistCell:self didClickedProgressViewAtIndexPath:self.indexPath];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger totalRows = [self.tableView numberOfRowsInSection:indexPath.section];
    
    if (totalRows == 1) { // 这组只有1行
        self.downSegLine.hidden = NO;
        self.upSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 0;
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        self.upSegLine.hidden = NO;
        self.downSegLine.hidden = YES;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 25;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        self.upSegLine.hidden = indexPath.section == 4 ? YES : NO;
        self.downSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = indexPath.section == 3 ? 0 : 25;
        self.downLineLeftSpace.constant = 0;
    } else {
        self.upSegLine.hidden = indexPath.section == 4 ? YES : NO;
        self.downSegLine.hidden = YES;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 25;
        self.downLineLeftSpace.constant = 25;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.presenter.modelType == UCFHomeListCellModelTypeDefault) {
        if ([self.presenter.type isEqualToString:@"3"] || self.goldModel) {
            [self.rateLabel setFont:[UIFont systemFontOfSize:10] string:@"克/100克"];
            self.annurateLabelW.constant = 52;
            self.rateLabel.textColor = UIColorWithRGB(0xfc8f0e);
            self.proSignBackView.backgroundColor = UIColorWithRGB(0xffc027);
        }
        else {
            [self.rateLabel setFont:[UIFont systemFontOfSize:12] string:@"%"];
            self.annurateLabelW.constant = 0;
            self.rateLabel.textColor = UIColorWithRGB(0xfd4d4c);
            self.proSignBackView.backgroundColor = UIColorWithRGB(0xfd4d4c);
        }
    }
}

- (void)setMicroMoneyModel:(UCFMicroMoneyModel *)microMoneyModel
{
    _microMoneyModel = microMoneyModel;
    self.proName.text = microMoneyModel.prdName;
    self.rateLabel.text = [NSString stringWithFormat:@"%@%%", microMoneyModel.annualRate];
    self.timeLabel.text = microMoneyModel.repayPeriodtext;
    self.repayModelLabel.text = microMoneyModel.repayModeText;
    self.startMoneyLabel.text = [NSString stringWithFormat:@"%@元起", microMoneyModel.minInvest];
    NSString *temp = [NSString stringWithFormat:@"%lf",[microMoneyModel.borrowAmount doubleValue]-[microMoneyModel.completeLoan doubleValue]];
    self.remainLabel.text = [self moneywithRemaining:temp total:microMoneyModel.borrowAmount];
    
    NSInteger status = [microMoneyModel.status integerValue];
    NSArray *statusArr = @[@"未审核",@"等待确认",@"出借",@"流标",@"满标",@"回款中",@"已回款"];
    
   
    if (status>2) {
        self.circleProgressView.progressText = @"已售罄";
        self.circleProgressView.textColor = UIColorWithRGB(0x909dae);
    }
    else {
        self.circleProgressView.textColor = UIColorWithRGB(0x555555);
        if (microMoneyModel.modelType == UCFMicroMoneyModelTypeBatchBid && status == 2) {
            self.circleProgressView.progressText = @"批量出借";
        }
        else {
            self.circleProgressView.progressText = [statusArr objectAtIndex:status];
        }
    }
    
//    self.angleView.angleStatus = microMoneyModel.status;
//    //        DBLOG(@"%@", model.status);
//    if (microMoneyModel.prdLabelsList.count>0) {
//        UCFProjectLabel *projectLabel = [microMoneyModel.prdLabelsList firstObject];
//        if ([projectLabel.labelPriority integerValue] == 1) {
//            self.angleView.angleString = [NSString stringWithFormat:@"%@", projectLabel.labelName];
//        }
//    }
    if (microMoneyModel.prdLabelsList.count > 0) {
        UCFProjectLabel *projectLabel = [microMoneyModel.prdLabelsList firstObject];
        if ([projectLabel.labelPriority integerValue] == 1) {
            self.proSignBackView.hidden = NO;
            self.proSignLabel.text = [NSString stringWithFormat:@"%@", projectLabel.labelName];
            CGSize size = [projectLabel.labelName boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0f]} context:nil].size;
            self.proSignBackViewWidth.constant = size.width + 11;
        }
        else {
            self.proSignBackView.hidden = YES;
            self.proSignBackViewWidth.constant = 0;
        }
    }
    else {
        self.proSignBackView.hidden = YES;
        self.proSignBackViewWidth.constant = 0;
    }
    if (microMoneyModel.platformSubsidyExpense.length > 0) {//贴
        self.image1W.constant = 18;
        self.proImageView1.image = [UIImage imageNamed:@"invest_icon_buletie"];
    }
    else {
        self.image1W.constant = 0;
    }
    if (microMoneyModel.guaranteeCompany.length > 0) {//贴
        self.image2W.constant = 18;
        self.proImageView2.image = [UIImage imageNamed:@"particular_icon_guarantee_dark"];
    }
    else {
        self.image2W.constant = 0;
    }
    if (microMoneyModel.fixedDate.length > 0) {//贴
        self.image3W.constant = 18;
        self.proImageView3.image = [UIImage imageNamed:@"invest_icon_redgu-1"];
    }
    else {
        self.image3W.constant = 0;
    }
    if (microMoneyModel.holdTime.length > 0) {//贴
        self.image4W.constant = 18;
        self.proImageView4.image = [UIImage imageNamed:@"invest_icon_ling"];
    }
    else {
        self.image4W.constant = 0;
    }
    
    float progress = [microMoneyModel.completeLoan floatValue]/[microMoneyModel.borrowAmount floatValue];
    if (progress < 0 || progress > 1) {
        progress = 1;
    }
    else
        self.circleProgressView.progress = progress;
    
    //控制进度视图显示
    if (status < 3) {
        self.circleProgressView.pathFillColor = UIColorWithRGB(0xfa4d4c);
        //            self.progressView.progressLabel.textColor = UIColorWithRGB(0x555555);
    }else{
        self.circleProgressView.pathFillColor = UIColorWithRGB(0xe2e2e2);//未绘制的进度条颜色
        //            self.progressView.progressLabel.textColor = UIColorWithRGB(0x909dae);
    }
}
- (void)setHonerListModel:(UCFMicroMoneyModel *)microMoneyModel
{
    _microMoneyModel = microMoneyModel;
    self.proName.text = microMoneyModel.prdName;
    self.rateLabel.text = [NSString stringWithFormat:@"%@%%", microMoneyModel.annualRate];
    self.timeLabel.text = microMoneyModel.repayPeriodtext;
    self.repayModelLabel.text = microMoneyModel.repayModeText;
    self.startMoneyLabel.text = [NSString stringWithFormat:@"%@元起", microMoneyModel.minInvest];
    NSString *temp = [NSString stringWithFormat:@"%lf",[microMoneyModel.borrowAmount doubleValue]-[microMoneyModel.completeLoan doubleValue]];
    self.remainLabel.text = [self moneywithRemaining:temp total:microMoneyModel.borrowAmount];
    
    NSInteger status = [microMoneyModel.status integerValue];
    NSArray *statusArr = @[@"未审核",@"等待确认",@"认购",@"流标",@"满标",@"回款中",@"已回款"];
    if (status>2) {
        self.circleProgressView.progressText = @"已售罄";
        self.circleProgressView.textColor = UIColorWithRGB(0x909dae);
    }
    else {
        self.circleProgressView.textColor = UIColorWithRGB(0x555555);
        self.circleProgressView.progressText = statusArr[status];
    }
    
    
//    self.angleView.angleStatus = microMoneyModel.status;
//    //        DBLOG(@"%@", model.status);
//    if (microMoneyModel.prdLabelsList.count>0) {
//        UCFProjectLabel *projectLabel = [microMoneyModel.prdLabelsList firstObject];
//        if ([projectLabel.labelPriority integerValue] == 1) {
//            self.angleView.angleString = [NSString stringWithFormat:@"%@", projectLabel.labelName];
//        }
//    }
    if (microMoneyModel.prdLabelsList.count > 0) {
        UCFProjectLabel *projectLabel = [microMoneyModel.prdLabelsList firstObject];
        if ([projectLabel.labelPriority integerValue] == 1) {
            self.proSignBackView.hidden = NO;
            self.proSignLabel.text = [NSString stringWithFormat:@"%@", projectLabel.labelName];
            CGSize size = [projectLabel.labelName boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0f]} context:nil].size;
            self.proSignBackViewWidth.constant = size.width + 11;
        }
        else {
            self.proSignBackView.hidden = YES;
            self.proSignBackViewWidth.constant = 0;
        }
    }
    else {
        self.proSignBackView.hidden = YES;
        self.proSignBackViewWidth.constant = 0;
    }
    if (microMoneyModel.platformSubsidyExpense.length > 0) {//贴
        self.image1W.constant = 18;
        self.proImageView1.image = [UIImage imageNamed:@"invest_icon_buletie"];
    }
    else {
        self.image1W.constant = 0;
    }
    if (microMoneyModel.guaranteeCompany.length > 0) {//贴
        self.image2W.constant = 18;
        self.proImageView2.image = [UIImage imageNamed:@"particular_icon_guarantee_dark"];
    }
    else {
        self.image2W.constant = 0;
    }
    if (microMoneyModel.fixedDate.length > 0) {//贴
        self.image3W.constant = 18;
        self.proImageView3.image = [UIImage imageNamed:@"invest_icon_redgu-1"];
    }
    else {
        self.image3W.constant = 0;
    }
    if (microMoneyModel.holdTime.length > 0) {//贴
        self.image4W.constant = 18;
        self.proImageView4.image = [UIImage imageNamed:@"invest_icon_ling"];
    }
    else {
        self.image4W.constant = 0;
    }
    float progress = [microMoneyModel.completeLoan floatValue]/[microMoneyModel.borrowAmount floatValue];
    if (progress < 0 || progress > 1) {
        progress = 1;
    }
    else
        self.circleProgressView.progress = progress;
    
    //控制进度视图显示
    if (status < 3) {
        self.circleProgressView.pathFillColor = UIColorWithRGB(0xfa4d4c);
        //            self.progressView.progressLabel.textColor = UIColorWithRGB(0x555555);
    }else{
        self.circleProgressView.pathFillColor = UIColorWithRGB(0xe2e2e2);//未绘制的进度条颜色
        //            self.progressView.progressLabel.textColor = UIColorWithRGB(0x909dae);
    }
    
}

- (void)setGoldModel:(UCFGoldModel *)goldModel
{
    _goldModel = goldModel;
    self.rateLabel.font = [UIFont systemFontOfSize:15];
    self.proName.text = goldModel.nmPrdClaimName;
    self.rateLabel.text = [NSString stringWithFormat:@"%@克/100克", goldModel.annualRate];
    [self.rateLabel setFont:[UIFont systemFontOfSize:10] string:@"克/100克"];
    self.timeLabel.text = goldModel.periodTerm;
    self.repayModelLabel.text = goldModel.paymentType;
    self.startMoneyLabel.text = @"年化收益克重";
//    [NSString stringWithFormat:@"%@克起", goldModel.minPurchaseAmount];
    if ([goldModel.remainAmount floatValue] > 0) {
        self.remainLabel.text = [NSString stringWithFormat:@"剩%@克", goldModel.remainAmount];
    }
    else {
        self.remainLabel.text = [NSString stringWithFormat:@"%@克", goldModel.totalAmount];
    }
    
    NSInteger status = [goldModel.status integerValue];
    
    
    float progress = ([goldModel.totalAmount floatValue]- [goldModel.remainAmount floatValue])/[goldModel.totalAmount floatValue];
    if (progress < 0 || progress > 1)
    {
        progress = 1;
    }
    else
    {
       self.circleProgressView.progress = progress;
    }
    
    
    if (status == 2 ) {
        self.circleProgressView.progressText = @"已售罄";
        self.circleProgressView.textColor = UIColorWithRGB(0x909dae);
        self.circleProgressView.pathFillColor = UIColorWithRGB(0xe2e2e2);
    }
    else if (status == 1) {
        self.circleProgressView.textColor = UIColorWithRGB(0x555555);
        self.circleProgressView.pathFillColor = UIColorWithRGB(0xfc8f0e);
        self.circleProgressView.progressText = @"购买";
    }else if (status == 21){
        self.circleProgressView.progressText = @"暂停交易";
        self.circleProgressView.textColor = UIColorWithRGB(0x909dae);
        self.circleProgressView.pathFillColor = UIColorWithRGB(0xe2e2e2);
    }
    if (goldModel.prdLabelsList.count > 0) {
        UCFProjectLabel *projectLabel = [goldModel.prdLabelsList firstObject];
        if ([projectLabel.labelPriority integerValue] == 1) {
            self.proSignBackView.hidden = NO;
            self.proSignLabel.text = [NSString stringWithFormat:@"%@", projectLabel.labelName];
            CGSize size = [projectLabel.labelName boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0f]} context:nil].size;
            self.proSignBackViewWidth.constant = size.width + 11;
        }
        else {
            self.proSignBackView.hidden = YES;
            self.proSignBackViewWidth.constant = 0;
        }
    }
    else {
        self.proSignBackView.hidden = YES;
        self.proSignBackViewWidth.constant = 0;
    }
    
    self.image1W.constant = 0;
    self.image2W.constant = 0;
    self.image3W.constant = 0;
    self.image4W.constant = 0;
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

@end
