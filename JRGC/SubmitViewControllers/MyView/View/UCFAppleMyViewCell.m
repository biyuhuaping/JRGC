//
//  UCFAppleMyViewCell.m
//  JRGC
//
//  Created by hanqiyuan on 2018/8/21.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFAppleMyViewCell.h"

@implementation UCFAppleMyViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setItemData:(UCFSettingItem *)itemData
{
    _itemData = itemData;
    self.iconImageView.image = [UIImage imageNamed:itemData.icon];
    self.titleDesLabel.text = itemData.title;
    self.valueLabel.text = [NSString stringWithFormat:@"¥%@ 元",itemData.subtitle];
}

@end
