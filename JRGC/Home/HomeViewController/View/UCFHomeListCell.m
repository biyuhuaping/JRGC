//
//  UCFHomeListCell.m
//  JRGC
//
//  Created by njw on 2017/5/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListCell.h"
#import "ZZCircleProgress.h"

@interface UCFHomeListCell ()
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView3;
@property (weak, nonatomic) IBOutlet UIView *proSignImageView;
@property (weak, nonatomic) IBOutlet ZZCircleProgress *circleProgressView;

@property (weak, nonatomic) IBOutlet UIView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *oneImageBackView;
@property (weak, nonatomic) IBOutlet UIView *titleBackView;
@property (weak, nonatomic) IBOutlet UIView *numBackView;
@property (weak, nonatomic) IBOutlet UILabel *oneImageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneImageDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneImageNumLabel;

@end

@implementation UCFHomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.circleProgressView.animationModel = CircleIncreaseSameTime;
    self.circleProgressView.showProgressText = YES;
    self.circleProgressView.notAnimated = NO;
    self.circleProgressView.progress = [@"0.8" floatValue];
    self.circleProgressView.startAngle = -90;
    self.circleProgressView.pathBackColor = [UIColor lightGrayColor];
    self.circleProgressView.pathFillColor = [UIColor redColor];
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

@end
