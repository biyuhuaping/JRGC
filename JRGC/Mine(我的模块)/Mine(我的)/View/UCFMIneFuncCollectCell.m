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

@end

@implementation UCFMIneFuncCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageview.image = [UIImage imageNamed:self.setItem.icon];
    self.titleLabel.text = self.setItem.title;
    self.signView.hidden = !self.setItem.isShowOrHide;
    self.valueLabel.text = self.setItem.subtitle;
}

@end
