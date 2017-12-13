//
//  UCFAssetProofApplyFirstCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/12/1.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFAssetProofApplyFirstCell.h"
#import "UCFToolsMehod.h"
#import "Common.h"
#import "NSString+CJString.h"
#import "CLAmplifyView.h"
@interface UCFAssetProofApplyFirstCell ()
- (IBAction)gotoAssetProofApplyVC:(id)sender;

- (IBAction)seeAssetProofModel:(id)sender;


@end
@implementation UCFAssetProofApplyFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _thumbnailImageView.userInteractionEnabled = YES;
    [_thumbnailImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)gotoAssetProofApplyVC:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(gotoAssetProofApplyVC)]) {
        [self.delegate gotoAssetProofApplyVC];
    }
}
- (void)clickImageView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(seeAssetProofModel:)]) {
        [self.delegate seeAssetProofModel:tap];
    }

}
- (IBAction)seeAssetProofModel:(id)sender
{
//    if ([self.delegate respondsToSelector:@selector(seeAssetProofModel:)]) {
//        [self.delegate seeAssetProofModel:(UIButton *)sender];
//    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    NSDictionary *dic = [Common getParagraphStyleDictWithStrFont:12.0f WithlineSpacing:3.0];

    self.tipLabel1.attributedText = [NSString getNSAttributedString:self.tipLabel1.text labelDict:dic];
    CGSize size1 =  [Common getStrHeightWithStr:self.tipLabel1.text AndStrFont:12 AndWidth:ScreenWidth - 30 AndlineSpacing:3];
    self.tipLabel1Height.constant = size1.height ;

    NSDictionary *dic1 = [Common getParagraphStyleDictWithStrFont:12.0f WithlineSpacing:3.0];
    self.tipLabel2.attributedText = [NSString getNSAttributedString:self.tipLabel2.text labelDict:dic1];
    CGSize size2 =  [Common getStrHeightWithStr:self.tipLabel2.text AndStrFont:12 AndWidth:ScreenWidth - 30 AndlineSpacing:3];
    self.tipLabel2Height.constant = size2.height;
}

@end

@implementation UCFAssetProofApplySecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
   
}
-(void)setAssetProofModel:(UCFAssetProofListModel *)assetProofModel
{
    _assetProofModel = assetProofModel;//0:申请中 1:申请成功 2:申请失败
    switch ([assetProofModel.applyStatus intValue]) {
        case 0:
        {
            self.applyStatusImageView.image = [UIImage imageNamed:@"applying.png"];
            self.applyTimeLabel.text  = @"资产证明开具中";
            self.proofFileNameLabel.text = assetProofModel.proofFileName;
            self.tipLabel.text = @"预计2小时内完成";
            self.tipLabel.textColor = UIColorWithRGB(0x999999);
            self.imageWidth.constant = 26.5;
            self.imageHeight.constant = 26.5;
        }
            break;
        case 1:
        {
            self.applyStatusImageView.image = [UIImage imageNamed:@"applySuccess.png"];
            self.applyTimeLabel.text  = [UCFToolsMehod getMyCollectionTimeStr: [assetProofModel.applyTime doubleValue]];
            self.proofFileNameLabel.text = assetProofModel.proofFileName;
            self.tipLabel.text = @"下载";
            self.tipLabel.textColor = UIColorWithRGB(0x4aa1f9);
            self.imageWidth.constant = 17.5;
            self.imageHeight.constant = 17.5;
        }
            break;
        case 2:
        {
            self.applyStatusImageView.image = [UIImage imageNamed:@"reapplyProof.png"];
            self.applyTimeLabel.text  = @"请重新申请";
            self.proofFileNameLabel.text = @"资产证明开具遇到问题";
            self.tipLabel.text = @"";
            self.tipLabel.textColor = UIColorWithRGB(0x4aa1f9);
            self.imageWidth.constant = 17.5;
            self.imageHeight.constant = 17.5;
        }
            break;
            
        default:
            break;
    }
    
    
}
@end
