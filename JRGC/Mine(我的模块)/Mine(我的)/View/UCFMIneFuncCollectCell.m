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

@end

@implementation UCFMIneFuncCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.signView.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageview.image = [UIImage imageNamed:self.setItem.icon];
    self.titleLabel.text = self.setItem.title;
    self.signView.hidden = !self.setItem.isShowOrHide;
    self.valueLabel.text = self.setItem.subtitle;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger total = [self.collectView numberOfItemsInSection:indexPath.section];
    NSInteger currentNo = indexPath.row / 2;
    if (currentNo != total/2) {
        self.segLineBottom.hidden = NO;
    }
    else {
        self.segLineBottom.hidden = YES;
    }
}

@end
