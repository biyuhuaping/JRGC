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
    _returnModeLabel.text = collectionBidModel.colRepayModeTxt;
}

@end
