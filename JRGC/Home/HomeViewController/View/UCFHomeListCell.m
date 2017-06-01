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

@interface UCFHomeListCell ()
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView3;
@property (weak, nonatomic) IBOutlet UIView *proSignImageView;
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

@property (weak, nonatomic) IBOutlet UIView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *oneImageBackView;
@property (weak, nonatomic) IBOutlet UIView *titleBackView;
@property (weak, nonatomic) IBOutlet UIView *numBackView;
@property (weak, nonatomic) IBOutlet UILabel *oneImageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneImageDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneImageNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numBackViewW;
@property (weak, nonatomic) IBOutlet UILabel *characteristicLabel;
@property (weak, nonatomic) IBOutlet UIView *characteristicBackView;

@property (weak, nonatomic) IBOutlet UIView *upSegLine;
@property (weak, nonatomic) IBOutlet UIView *downSegLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineLeftSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneImageUpHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneImageDownHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signViewWidth;

@end

@implementation UCFHomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rateLabel.textColor = UIColorWithRGB(0xfd4d4c);
    self.circleProgressView.animationModel = CircleIncreaseSameTime;
    self.circleProgressView.showProgressText = YES;
    self.circleProgressView.notAnimated = NO;
    self.circleProgressView.startAngle = -90;
    self.circleProgressView.pathBackColor = UIColorWithRGB(0xcfd5d7);
    self.circleProgressView.pathFillColor = UIColorWithRGB(0xfa4d4c);
    self.circleProgressView.strokeWidth = 3;
    self.oneImageBackView.layer.cornerRadius = 3;
    self.oneImageBackView.clipsToBounds = YES;
}

- (void)setPresenter:(UCFHomeListCellPresenter *)presenter
{
    _presenter = presenter;
    if (presenter.modelType == UCFHomeListCellModelTypeDefault
        ) {
        self.oneImageView.hidden = YES;
        self.proName.text = presenter.proTitle;
        self.rateLabel.text = presenter.annualRate;
        self.timeLabel.text = presenter.repayPeriodtext;
        self.repayModelLabel.text = presenter.repayModeText;
        self.startMoneyLabel.text = presenter.minInvest;
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
        float progress = [presenter.item.completeLoan floatValue]/[presenter.item.borrowAmount floatValue];
        if (progress < 0 || progress > 1) {
            progress = 1;
        }
        else
            self.circleProgressView.progress = progress;
        
        NSInteger status = [presenter.item.status integerValue];
        //控制进度视图显示
        if (status < 3) {
            self.circleProgressView.pathFillColor = UIColorWithRGB(0xfa4d4c);
//            self.progressView.progressLabel.textColor = UIColorWithRGB(0x555555);
        }else{
            self.circleProgressView.pathFillColor = UIColorWithRGB(0xe2e2e2);//未绘制的进度条颜色
//            self.progressView.progressLabel.textColor = UIColorWithRGB(0x909dae);
        }
        
        NSArray *statusArr = @[@"未审核",@"等待确认",@"出借",@"流标",@"满标",@"回款中",@"已回款"];
        if (([presenter.item.type isEqualToString:@"2"]) && status == 2) {
            self.circleProgressView.progressText = @"认购";
        }
        else
            self.circleProgressView.progressText = statusArr[status];
        
        if (presenter.item.prdLabelsList.count>0) {
            UCFProjectLabel *projectLabel = [presenter.item.prdLabelsList firstObject];
            if ([projectLabel.labelPriority integerValue] == 1) {
                self.characteristicBackView.hidden = NO;
                NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:10]};
                CGSize nameSize = [projectLabel.labelName boundingRectWithSize:CGSizeMake(MAXFLOAT, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
                self.signViewWidth.constant = nameSize.width + 11;
                self.characteristicLabel.text = projectLabel.labelName;
            }
            else {
                self.characteristicBackView.hidden = YES;
            }
        }
        else {
            self.characteristicBackView.hidden = YES;
        }
    }
    else if (presenter.modelType == UCFHomeListCellModelTypeOneImageBatchLending || presenter.modelType == UCFHomeListCellModelTypeOneImageHonorTransfer || presenter.modelType == UCFHomeListCellModelTypeOneImageBondTransfer)  {
        self.oneImageView.hidden = NO;
        self.titleBackView.hidden = NO;
        self.numBackView.hidden = NO;
        self.oneImageBackView.image = [UIImage imageNamed:self.presenter.item.backImage];
        self.oneImageTitleLabel.text = presenter.proTitle;
        self.oneImageDescribeLabel.text = presenter.type;
    }
    else if (presenter.modelType == UCFHomeListCellModelTypeOneImageBatchCycle) {
        self.oneImageView.hidden = NO;
        self.titleBackView.hidden = YES;
        self.numBackView.hidden = YES;
        self.oneImageBackView.image = [UIImage imageNamed:self.presenter.item.backImage];
    }
    
}
- (IBAction)cyclePressClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homelistCell:didClickedProgressViewWithPresenter:)]) {
        [self.delegate homelistCell:self didClickedProgressViewWithPresenter:self.presenter.item];
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
        self.downLineLeftSpace.constant = 15;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        self.upSegLine.hidden = indexPath.section == 3 ? YES : NO;
        self.downSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = indexPath.section == 2 ? 0 : 15;
        self.downLineLeftSpace.constant = 0;
    } else {
        self.upSegLine.hidden = indexPath.section == 3 ? YES : NO;
        self.downSegLine.hidden = YES;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 15;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.presenter.modelType == UCFHomeListCellModelTypeDefault) {
        [self.rateLabel setFont:[UIFont systemFontOfSize:12] string:@"%"];
    }
    else if (self.presenter.modelType == UCFHomeListCellModelTypeOneImageBatchLending)  {
        self.oneImageNumLabel.text = self.presenter.item.totalCount;
    }
    else if (self.presenter.modelType == UCFHomeListCellModelTypeOneImageBondTransfer) {
        self.oneImageNumLabel.text = self.presenter.item.p2pTransferNum;
        self.oneImageDownHeight.constant = 5;
    }
    else if (self.presenter.modelType == UCFHomeListCellModelTypeOneImageHonorTransfer) {
        self.oneImageNumLabel.text = self.presenter.item.zxTransferNum;
        self.oneImageUpHeight.constant = 5;
        self.oneImageDownHeight.constant = 5;
    }
    else if (self.presenter.modelType == UCFHomeListCellModelTypeOneImageBatchCycle) {
        self.oneImageUpHeight.constant = 5;
        self.oneImageDownHeight.constant = 10;
    }
    
    if (self.oneImageNumLabel.text.length == 1) {
        self.numBackViewW.constant = 22;
    }
    else if (self.oneImageNumLabel.text.length == 2) {
        self.numBackViewW.constant = 32;
    }
    else if (self.oneImageNumLabel.text.length == 3) {
        self.numBackViewW.constant = 43;
    }
}

@end
