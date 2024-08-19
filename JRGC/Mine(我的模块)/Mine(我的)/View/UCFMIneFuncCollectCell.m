//
//  UCFMIneFuncCollectCell.m
//  JRGC
//
//  Created by njw on 2017/12/21.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFMIneFuncCollectCell.h"
#import "UCFSettingArrowItem.h"

@interface UCFMIneFuncCollectCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UIView *segLineRight;
@property (weak, nonatomic) IBOutlet UIView *segLineBottom;
@property (weak, nonatomic) IBOutlet UIImageView *hot_ImageView;
@property (weak, nonatomic) IBOutlet UILabel *hot_Label;
@property (weak, nonatomic) IBOutlet UIImageView *mine_sign_tip_imageView;

@end

@implementation UCFMIneFuncCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.signView.hidden = YES;
    self.valueLabel.textColor = UIColorWithRGB(0x4aa1f9);
    self.segLineBottom.hidden = NO;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger total = [self.collectView numberOfItemsInSection:self.indexPath.section];
    NSInteger currentNo = (indexPath.row + 1) / 2 + (indexPath.row + 1) % 2;
    if (currentNo != total/2 + total % 2) {
        self.segLineBottom.hidden = NO;
    }
    else {
        self.segLineBottom.hidden = YES;
    }
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//}

- (void)setSetItem:(UCFSettingArrowItem *)setItem
{
    _setItem = setItem;
    self.imageview.image = [UIImage imageNamed:self.setItem.icon];
    self.titleLabel.text = self.setItem.title;

    self.signView.hidden = !self.setItem.isShowOrHide;
    self.valueLabel.text = self.setItem.subtitle;
    if (self.setItem.isShowHot) {
        _hot_ImageView.hidden = NO;
        _hot_Label.hidden = NO;
    } else {
        _hot_ImageView.hidden = YES;
        _hot_Label.hidden = YES;
    }
    if (self.setItem.isShowSignTips) {
        _mine_sign_tip_imageView.hidden = NO;
    } else {
        _mine_sign_tip_imageView.hidden = YES;

    }
}

@end
