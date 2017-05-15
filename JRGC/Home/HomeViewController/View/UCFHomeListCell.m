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

@end

@implementation UCFHomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.circleProgressView.animationModel = CircleIncreaseSameTime;
    self.circleProgressView.showProgressText = YES;
    self.circleProgressView.notAnimated = NO;
    self.circleProgressView.startAngle = -90;
    self.circleProgressView.pathBackColor = [UIColor lightGrayColor];
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
    }
    else if (self.presenter.modelType == UCFHomeListCellModelTypeOneImageHonorTransfer) {
        self.oneImageNumLabel.text = self.presenter.item.zxTransferNum;
    }
    else if (self.presenter.modelType == UCFHomeListCellModelTypeOneImageBatchCycle) {
        
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
