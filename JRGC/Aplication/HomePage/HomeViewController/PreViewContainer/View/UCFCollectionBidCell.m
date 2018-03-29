//
//  UCFCollectionBidCell.m
//  JRGC
//
//  Created by njw on 2017/2/20.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCollectionBidCell.h"
#import "UCFCollectionBidModel.h"

@interface UCFCollectionBidCell ()
@property (weak, nonatomic) IBOutlet UIView *progressBgView;
@property (weak, nonatomic) IBOutlet UIView *moreBgView;
@property (weak, nonatomic) IBOutlet UIButton *batchBidButton;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftAmtLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressValueTrailSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBgViewWidth;

@end

@implementation UCFCollectionBidCell

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.progressBgView.layer.cornerRadius = self.progressBgView.frame.size.height * 0.5;
    self.progressBgView.clipsToBounds = YES;
    
    self.moreBgView.layer.cornerRadius = self.moreBgView.frame.size.height * 0.5;
    self.moreBgView.clipsToBounds = YES;
    
    self.moreValueLabel.layer.cornerRadius = self.moreValueLabel.frame.size.height * 0.5;
    self.moreValueLabel.clipsToBounds = YES;
}

- (IBAction)batchBidButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(collectionCell:didClickedBatchBidButton:)]) {
        [self.delegate collectionCell:self didClickedBatchBidButton:sender];
    }
}

- (IBAction)moreButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(collectionCell:didClickedMoreButton:)]) {
        [self.delegate collectionCell:self didClickedMoreButton:sender];
    }
}

- (void)setCollectionBidModel:(UCFCollectionBidModel *)collectionBidModel
{
    _collectionBidModel = collectionBidModel;
    _collectionBidName.text = collectionBidModel.colName;
    _preYearRateLabel.text = [NSString stringWithFormat:@"%@%%", collectionBidModel.colRate];
    [_preYearRateLabel setFont:[UIFont systemFontOfSize:24] string:@"%"];
    _returnModeLabel.text = collectionBidModel.colRepayModeTxt;
    _periodLabel.text = collectionBidModel.colPeriodTxt;
    if (collectionBidModel.full) {
        [_batchBidButton setTitle:@"满标" forState:UIControlStateNormal];
    }
    else {
        [_batchBidButton setTitle:@"批量出借" forState:UIControlStateNormal];
    }
    self.leftAmtLabel.text = [self moneywithRemaining:collectionBidModel.canBuyAmt total:collectionBidModel.totalAmt];
    
    CGFloat progressValue = [collectionBidModel.canBuyAmt floatValue]/[collectionBidModel.totalAmt floatValue];
    if (progressValue>1 || collectionBidModel.full == YES) {
        _progressValueTrailSpace.constant = 0;
    }
    else if (progressValue<0) {
        _progressValueTrailSpace.constant = self.progressBgView.frame.size.width;
    }
    else {
        _progressValueTrailSpace.constant = (ScreenWidth - 90) * progressValue;
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
    
    //    return [NSString stringWithFormat:@"剩%@/%@",str1,str2];
    //标未满的时候显示剩余 //满标的时候，显示总额
    if (rem2 == 0) {
        return [NSString stringWithFormat:@"%@",str2];
    }
    return [NSString stringWithFormat:@"剩%@",str1];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.moreValueLabel.text isEqualToString:@"99+"]) {
        self.moreBgViewWidth.constant = 69;
    }
    else {
        NSInteger number = [self.moreValueLabel.text integerValue];
        if (number>10) {
            self.moreBgViewWidth.constant = 64;
        }
        else {
            self.moreBgViewWidth.constant = 55;
        }
    }
    
}

@end
